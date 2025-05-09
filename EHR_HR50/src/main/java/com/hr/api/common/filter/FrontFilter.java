package com.hr.api.common.filter;

import com.hr.api.common.util.AES256;
import com.hr.api.common.util.JweToken;
import com.hr.api.common.wrapper.Api50RequestWrapper;
import com.hr.api.common.wrapper.Api50ResponseWrapper;
import com.hr.common.logger.Log;
import com.hr.common.security.SecurityMgrService;
import com.hr.common.wrapper.ReadableRequestWrapper;
import com.nimbusds.jose.JOSEException;
import com.nimbusds.jwt.SignedJWT;
import org.apache.commons.lang3.StringUtils;
import org.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.security.GeneralSecurityException;
import java.text.ParseException;
import java.util.Iterator;
import java.util.Map;

@Component
@Order(0)
public class FrontFilter implements Filter {
    private final Logger logger = LoggerFactory.getLogger(this.getClass());

    //앱과 상호 교환한 키 정보
    public static final String PubKEY = "iSusYSTems01Ut10ndeVe10pM2ntt2am";

    //empKey Response 암호화 키
    public static final String PriKEY = "a2sEo6pr1v@t2k2yf0rReqr2st0hr@Pp";

    public static final String HEADER_AUTHORIZATION = "Authorization";

    protected static final String HEADER_FREEPATH = "com.isu.hrtong";

    @Autowired
    private JweToken jwt;

    @Autowired
    private SecurityMgrService securityMgrService;

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

        String header = ((HttpServletRequest) request).getHeader(HEADER_AUTHORIZATION);
        String requestUri = ((HttpServletRequest) request).getRequestURI().substring(((HttpServletRequest) request).getContextPath().length());
        AES256 pubAes = new AES256(PubKEY);

        try {
            if(HEADER_FREEPATH.equals(pubAes.decrypt(header))) {
                Log.Debug("FREE PATH HEADER:: " + header);
                chain.doFilter(request, response);
            }
        } catch (IllegalArgumentException | GeneralSecurityException e) {
            // BASE 64 디코딩에 실패한 경우, 토큰확인 후 세션 값 설정
            try {
                SignedJWT sToken = null;

                sToken = jwt.decodeJWT(header);
                Log.Debug("sToken :: {}", sToken);
                Log.Debug("sToken.getPayload :: {}", (String) sToken.getPayload().toJSONObject().toString());

                Map<String, Object> s = sToken.getPayload().toJSONObject();
                Log.Debug("===== SET SESSION FROM TOKEN =====");
                HttpSession session = ((HttpServletRequest) request).getSession();

                if (s.containsKey("s") && s.get("s") != null) {
                    String sessionData = s.get("s").toString();
                    // JSON 문자열을 JSONObject로 파싱
                    JSONObject jsonObject = new JSONObject(sessionData);

                    // 키-값 쌍을 출력
                    Iterator<String> keys = jsonObject.keys();
                    while (keys.hasNext()) {
                        String key = keys.next();

                        // theme 키인 경우, 세션에 값이 없거나 빈 값일 때만 업데이트
                        // 그 외의 키는 항상 업데이트
                        if(!key.equalsIgnoreCase("theme") || 
                           (key.equalsIgnoreCase("theme") && (session.getAttribute(key) == null || "".equals(session.getAttribute(key).toString())))) {
                            Object value = jsonObject.get(key);
                            session.setAttribute(key, value);
                            Log.Debug(key + ": " + value);
                        }
                    }
                }

                String ssnEnterCd = session == null ? null:(String)session.getAttribute("ssnEnterCd");
                String requestURI = ((HttpServletRequest) request).getRequestURI();

                if (ssnEnterCd != null) {
                    String encryptKey = securityMgrService.getEncryptKey(ssnEnterCd);

                    if (requestUri.contains("/api/front/file/upload") || requestUri.contains("/api/front/file/delete")) {
                        Log.Debug("IS DOWNLOAD RESPONSE URI : {}", requestURI);

                        ReadableRequestWrapper requestWrapper = new ReadableRequestWrapper((HttpServletRequest) request, encryptKey, true);
                        chain.doFilter(requestWrapper, response);
                    } else {
                        Api50RequestWrapper requestWrapper = new Api50RequestWrapper((HttpServletRequest) request, encryptKey);
                        Api50ResponseWrapper responseWrapper = new Api50ResponseWrapper((HttpServletResponse) response);

                        chain.doFilter(requestWrapper, responseWrapper);
                        String body = responseWrapper.getResponseBody();
                        if (!StringUtils.isEmpty(body)) {
                            byte[] data = null;
                            data = body.getBytes();
                            response.setContentType(responseWrapper.getContentType());
                            response.setContentLength(data.length);
                            ServletOutputStream out = response.getOutputStream();
                            out.write(data);
                            out.flush();
                            out.close();
                        }
                    }
                }
            } catch (ParseException | JOSEException ex) {
                Log.Error(ex.toString());
                throw new RuntimeException(ex);
            } catch (Exception ex) {
                Log.Error(ex.toString());
            }
        }
    }

    @Override
    public void destroy() {

    }

}
