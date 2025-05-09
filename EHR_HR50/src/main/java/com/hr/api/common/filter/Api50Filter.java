package com.hr.api.common.filter;

import com.hr.api.common.service.ApiAuthService;
import com.hr.api.common.util.AES256;
import com.hr.api.common.util.JweToken;
import com.hr.api.common.wrapper.Api50RequestWrapper;
import com.hr.api.common.wrapper.Api50ResponseWrapper;
import com.hr.common.logger.Log;
import com.hr.common.security.SecurityMgrService;
import com.hr.common.util.CryptoUtil;
import com.hr.common.wrapper.ReadableRequestWrapper;
import com.nimbusds.jwt.JWTClaimsSet;
import com.nimbusds.jwt.SignedJWT;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import javax.security.sasl.AuthenticationException;
import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.security.GeneralSecurityException;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

@Service
public class Api50Filter implements Filter {
    private final Logger logger = LoggerFactory.getLogger(this.getClass());

    //앱과 상호 교환한 키 정보
    //public static final String PubKEY = "isUsysT2Mmob1l2@p1byD2v2l0perIsu";
    public static final String PubKEY = "iSusYSTems01Ut10ndeVe10pM2ntt2am";

    //empKey Response 암호화 키
    public static final String PriKEY = "a2sEo6pr1v@t2k2yf0rReqr2st0hr@Pp";

    public static final String HEADER_AUTHORIZATION = "Authorization";
    public static final String HEADER_TOKEN = "token";
    //public static final String HEADER_TS_ID = "ts";
    protected static final String HEADER_FREEPATH = "com.isu.hrtong";

    @Autowired
    private JweToken jwt;

    @Autowired
    private ApiAuthService apiAuthService;

    @Autowired
    private SecurityMgrService securityMgrService;

    private String[] freePassPath = {
            "/api/v5/login", //로그인
            "/api/v5/logout", //로그아웃
            "/api/v5/getLoginEnterList", //로그인 enterCd 리스트
            "/api/v5/PwdFindAction", // 비밀번호 찾기
            "/api/v5/callMail",  //비밀번호 이미일 전송
            "/api/v5/load-locale",  //빌드 시 생성 언어
            "/api/v5/common/download",    //다운로드
            "/api/v5/common/upload",    //업로드
            "/api/v5/common/downReport",    //RD print
            "/api/v5/contract/downReport",    //RD print

//            "/api/v5/self/login", //셀프서비스 로그인
//            "/api/v5/self/logout", //셀프서비스 로그아웃
//            "/api/v5/self/common/upload",    //업로드
//            "/api/v5/self/certi/downReport",    //RD print
    };

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {

    }

    /**
     * 모든 Request 에서 empKey (암호화 된) 필수
     * 헤더의 token 값과 비교
     * 어뎁터에서도 empKey값 기준으로 모든 행위를 한다.(회사별 암호화 키값 사용)
     *
     * @param request
     * @param response
     * @param chain
     * @throws IOException
     * @throws ServletException
     */
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        AES256 pubAes = new AES256(PubKEY);

        String requestUri = ((HttpServletRequest) request).getRequestURI().substring(((HttpServletRequest) request).getContextPath().length());
        logger.debug(":: freePassPath : {}", freePassPath);
        logger.debug(":: requestUri : {}", requestUri);
        if (requestUri != null) {
            if (freePassPath.length > 0) {
                for (int i = 0; i < freePassPath.length; i++) {
                    if(requestUri.contains("/api/v5/self")){
                        if(requestUri.contains("/downReport")){
                            ReadableRequestWrapper requestWrapper = new ReadableRequestWrapper((HttpServletRequest) request, this.PriKEY, true);
                            chain.doFilter(requestWrapper, response);
                            return;
                        }else{
                            ReadableRequestWrapper requestWrapper = new ReadableRequestWrapper((HttpServletRequest) request, this.PriKEY, true);
                            Api50ResponseWrapper responseWrapper = new Api50ResponseWrapper((HttpServletResponse) response);
                            chain.doFilter(requestWrapper, responseWrapper);
                            try {
                                logger.debug("::::::: responseWrapper.getResponseBody() :: {} ", responseWrapper.getResponseBody());
                                logger.debug("::::::: MediaType.APPLICATION_JSON_VALUE :: {} ", MediaType.APPLICATION_JSON_VALUE);
                                if (!StringUtils.isEmpty(responseWrapper.getResponseBody())) {//  && (MediaType.APPLICATION_JSON_VALUE.equals(responseWrapper.getContentType()) || "application/json;charset=UTF-8".equals(responseWrapper.getContentType()))) {
                                    String body = responseWrapper.getResponseBody(); // Original response body (clear text)
                                    response.setContentType(requestWrapper.getRequest().getContentType()); // Be consistent with the request
                                    byte[] responseData = null;
                                    try {
                                        JSONArray oldJsonArray = new JSONArray(body);
                                        JSONArray newJsonArray = new JSONArray();

                                        oldJsonArray.forEach(item -> {
                                            if (item instanceof JSONObject) {
                                                String strObject = item.toString();
                                                JSONObject jsonObject = CryptoUtil.cryptoParameter(strObject, "E", this.PriKEY, (HttpServletRequest) request);
                                                newJsonArray.put(jsonObject);
                                            }
                                            //기본 STRING 배열일 경우 추가
                                            else if (item instanceof String) {
                                                newJsonArray.put(item);
                                            }
                                        });
                                        responseData = newJsonArray.toString().getBytes(responseWrapper.getCharacterEncoding()); // The coding is consistent with the actual response
                                    } catch (JSONException e) {
                                        try{
                                            Log.Error(e.getMessage());
                                            JSONObject jsonObject = CryptoUtil.cryptoParameter(body, "E", this.PriKEY, (HttpServletRequest) request);
                                            responseData = jsonObject.toString().getBytes(responseWrapper.getCharacterEncoding()); // The coding is consistent with the actual response
                                        }catch (JSONException je){
                                            Log.Error(je.getMessage());
                                            responseData = body.getBytes(responseWrapper.getCharacterEncoding());
                                        }
                                    }
                                    response.setContentLength(responseData.length);
                                    ServletOutputStream out = response.getOutputStream();
                                    out.write(responseData);
                                }

                            } catch (Exception e) {
                                logger.debug(e.getMessage());
                                e.printStackTrace();
                            }
                        }

                        return;
                    }else{
                        int pathIndex = requestUri.indexOf(freePassPath[i]);
                        if (pathIndex >= 0) {
                            String freepathHeader = ((HttpServletRequest) request).getHeader((this.HEADER_AUTHORIZATION));
                            try {
                                if(requestUri.contains("/api/v5") && requestUri.contains("/downReport")){
                                    ReadableRequestWrapper requestWrapper = new ReadableRequestWrapper((HttpServletRequest) request, this.PriKEY, true);
                                    chain.doFilter(requestWrapper, response);
                                } else {
//                                logger.debug(":: freepathHeader : {}", pubAes.decrypt(freepathHeader));
//                                logger.debug(""+this.HEADER_FREEPATH.equals(pubAes.decrypt(freepathHeader)));
                                    if("/api/v5/common/download".equals(requestUri)
                                            || "/api/v5/common/upload".equals(requestUri)
                                            || "/api/v5/self/common/upload".equals(requestUri)){

                                        Log.Debug("IS FILE RESPONSE URI : {}", requestUri);
                                        ReadableRequestWrapper requestWrapper = new ReadableRequestWrapper((HttpServletRequest) request, this.PriKEY, true);
                                        chain.doFilter(requestWrapper, response);
                                    } else if (this.HEADER_FREEPATH.equals(pubAes.decrypt(freepathHeader))) {
                                        logger.debug(":: HEADER_FREEPATH ::");
                                        chain.doFilter(request, response);
                                    } else {
                                        throw new AuthenticationException();
                                    }
                                }

                            } catch (GeneralSecurityException e) {
                                throw new AuthenticationException();
                            }
                            logger.debug("doFilter Finish");
                            return;
                        }
                    }
                }
            }
        }

        //로그인 후 토큰 필요
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        Api50RequestWrapper requestWrapper = new Api50RequestWrapper((HttpServletRequest) request, this.PriKEY);

        logger.debug(this.PriKEY);
        //requestWrapper.setParameter("tenantKey", ((HttpServletRequest) request).getHeader(this.HEADER_TS_ID));
        AES256 priAes = new AES256(this.PriKEY);
        logger.debug(priAes.toString());
        //이때는 로그인 성공 후 발급 받은 token 이다
        String token = ((HttpServletRequest) request).getHeader(HEADER_AUTHORIZATION);
        System.out.println(token);
        //테넌트 키 입력 화면에서만 사용한다.
        String sabun = null;
        String enterCd = null;

        try {
            SignedJWT sToken = jwt.decodeJWT(token);
            logger.debug("sToken :: {}", sToken);

            logger.debug("sToken.getPayload :: {}", (String) sToken.getPayload().toJSONObject().toString());
            sabun = (String) sToken.getPayload().toJSONObject().get("sabun");
            enterCd = (String) sToken.getPayload().toJSONObject().get("enterCd");

            requestWrapper.setParameter("sabun", sabun);
            requestWrapper.setParameter("enterCd", enterCd);

            //토큰 유효성 체크
            Map<String, Object> paramMap = new HashMap<>();
            paramMap.put("ssnEnterCd", enterCd);
            paramMap.put("ssnSabun", sabun);
            paramMap.put("jsessionid", token);
            //
            Map<?, ?> getToken = apiAuthService.getMobileToken(paramMap) ;

            //토큰 비교
            if(!token.equals(getToken.get("jsessionid"))){
                ((HttpServletResponse) response).setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                return;
            }

            //1. 토큰 만료 확인
            // 클레임셋에서 만료 시간(exp) 가져오기
            JWTClaimsSet claims = sToken.getJWTClaimsSet();
            Date expirationTime = claims.getExpirationTime();

            Log.Debug("expirationTime : " + expirationTime);
            // 현재 시간과 만료 시간 비교
            if(expirationTime == null || new Date().after(expirationTime)){
                Log.Debug("토큰 유효 시간 만료!!!!!");
                ((HttpServletResponse) response).setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                return;
            }

            //2. 세션 만료 확인
            // 세션 타임아웃 확인
            HttpSession session = ((HttpServletRequest) request).getSession();
            long currentTime = System.currentTimeMillis();
            long sessionCreationTime = session.getCreationTime();
            long sessionTimeout = 60 * 60 * 1000; // 60분
            long validTime = currentTime - sessionCreationTime;
            Log.Debug("세션 타임아웃 확인!!");
            Log.Debug("[validTime]"+validTime);
            if (validTime > sessionTimeout || validTime < 0) {
                Log.Debug("세션 유효 시간 만료!!!!!");
                // 세션이 만료되었을 경우
                session.invalidate();
                ((HttpServletResponse) response).setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                return;
            }

            //세션 데이터 확인
            if(StringUtils.isEmpty(session.getAttribute("ssnSabun")) || StringUtils.isEmpty(session.getAttribute("ssnEnterCd"))){
                Log.Debug("세션 만료!!!!!");
                // 세션이 만료되었을 경우
                session.invalidate();
                ((HttpServletResponse) response).setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                return;
            }

        } catch (Exception e) {
            logger.debug(e.getMessage());
            ((HttpServletResponse) response).setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        Api50ResponseWrapper responseWrapper = new Api50ResponseWrapper((HttpServletResponse) response);
        chain.doFilter(requestWrapper, responseWrapper);
        try {
            logger.debug("::::::: responseWrapper.getResponseBody() :: {} ", responseWrapper.getResponseBody());
            logger.debug("::::::: MediaType.APPLICATION_JSON_VALUE :: {} ", MediaType.APPLICATION_JSON_VALUE);
            if (!StringUtils.isEmpty(responseWrapper.getResponseBody())) {//  && (MediaType.APPLICATION_JSON_VALUE.equals(responseWrapper.getContentType()) || "application/json;charset=UTF-8".equals(responseWrapper.getContentType()))) {
                String body = responseWrapper.getResponseBody(); // Original response body (clear text)
                response.setContentType(requestWrapper.getRequest().getContentType()); // Be consistent with the request
                byte[] responseData = null;
                try {
                    JSONArray oldJsonArray = new JSONArray(body);
                    JSONArray newJsonArray = new JSONArray();

                    oldJsonArray.forEach(item -> {
                        if (item instanceof JSONObject) {
                            String strObject = item.toString();
                            //JSONObject jsonObject = CryptoUtil.cryptoParameter(strObject, (HttpServletRequest) request, "E", Api50Filter.PriKEY);
                            JSONObject jsonObject = new JSONObject(strObject);
                            newJsonArray.put(jsonObject);
                        }
                        //기본 STRING 배열일 경우 추가
                        else if (item instanceof String) {
                            newJsonArray.put(item);
                        }
                    });
                    responseData = newJsonArray.toString().getBytes(responseWrapper.getCharacterEncoding()); // The coding is consistent with the actual response
                } catch (JSONException e) {
                    //JSONObject jsonObject = CryptoUtil.cryptoParameter(body, (HttpServletRequest) request, "E", Api50Filter.PriKEY);
                    try{
                        Log.Error(e.getMessage());
                        JSONObject jsonObject = new JSONObject(body);
                        responseData = jsonObject.toString().getBytes(responseWrapper.getCharacterEncoding()); // The coding is consistent with the actual response
                    }catch (JSONException je){
                        Log.Error(je.getMessage());
                        responseData = body.getBytes(responseWrapper.getCharacterEncoding());
                    }
                }

                response.setContentLength(responseData.length);
                ServletOutputStream out = response.getOutputStream();
                out.write(responseData);
            }

        } catch (Exception e) {
            logger.debug(e.getMessage());
            e.printStackTrace();
        }
    }

    @Override
    public void destroy() {

    }

}
