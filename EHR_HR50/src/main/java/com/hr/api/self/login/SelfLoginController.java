package com.hr.api.self.login;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.hr.api.common.util.JweToken;
import com.hr.api.self.common.SelfCommonService;
import com.hr.common.com.ComService;
import com.hr.common.logger.Log;
import com.hr.common.security.SecurityMgrService;
import com.hr.main.login.LoginService;
import com.nimbusds.jose.JOSEException;
import com.nimbusds.jwt.SignedJWT;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.UnsupportedEncodingException;
import java.security.GeneralSecurityException;
import java.text.ParseException;
import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping(value="/api/v5/self")
public class SelfLoginController {

    @Autowired
    private LoginService loginService;

    @Inject
    @Named("SecurityMgrService")
    private SecurityMgrService securityMgrService;

    @Inject
    @Named("ComService")
    private ComService comService;

    @Inject
    @Named("SelfCommonService")
    private SelfCommonService selfCommonService;

//    @Inject
//    @Named("SelfLoginService")
//    private SelfLoginService selfLoginService;

    @Autowired
    private JweToken jwt;

    /**
     * 로그인
     * @param paramMap
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/login/check")
    public Map<String, Object> loginCheck(
            @RequestBody Map<String, Object> paramMap,
            HttpSession session, HttpServletRequest request,
            HttpServletResponse response) throws Exception {
        Map<String, Object> result = new HashMap<>();

        try {
            Log.Debug("Login Check =====");
            Log.Debug(paramMap.toString());
            String token = request.getHeader("Authorization");
            Log.Debug("token :: {}", token);
            SignedJWT sToken = jwt.decodeJWT(token);
            Log.Debug("sToken :: {}", sToken);

            Log.Debug("sToken.getPayload :: {}", (String) sToken.getPayload().toJSONObject().toString());
            String ssnSabun = (String) sToken.getPayload().toJSONObject().get("sabun");
            String ssnEnterCd = (String) sToken.getPayload().toJSONObject().get("enterCd");

            paramMap.put("ssnEnterCd", ssnEnterCd);
            paramMap.put("ssnSabun", 	ssnSabun);

//            Map<?, ?> loginUser = selfLoginService.getLoginSelf(paramMap);

            Map<String, Object> elemQueryMap = new HashMap<>();
            Map<String, Object> chgMap = new HashMap<>();
            String stdCdClob = "";
            String Message = "";
            String query = "";
            try{
                //재직 이력 쿼리 조회 SELF_EMP_HIS
                paramMap.put("stdCd", "SELF_LOGIN_CHECK_SQL");
                elemQueryMap	= (Map<String, Object>) selfCommonService.getStdCdClob(paramMap);
                stdCdClob   		= (String) elemQueryMap.get("stdCdClob");
                Log.Debug(elemQueryMap.toString());
            }catch(Exception e){
                Message="조회에 실패하였습니다.";
                Log.Debug(e.getMessage());
            }

            query = stdCdClob.replaceAll("#\\{ssnLocaleCd}", cAdd(""));
            query = query.replace("#{ssnEnterCd}", cAdd(ssnEnterCd));
            query = query.replace("#{ssnSabun}", cAdd(ssnSabun));
            Log.Debug(query);
            paramMap.put("resultQuery", query);
            Log.Debug(paramMap.toString());

            Map<?, ?> loginUser = selfCommonService.getSelfQueryResult(paramMap);

//            result.put("loginUser", loginUser);
            result.put("token", token);
        } catch(Exception e){
            Log.Debug(e.getLocalizedMessage());
            result.put("failRev", e);
            result.put("isUser", "loginFail");
            result.put("msg", "Authorized access");
            result.put("code", "401");
            return result;
        }

        return result;
    }

    /**
     * 로그인
     * @param paramMap
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/login")
    public Map<String, Object> login(
            @RequestBody Map<String, Object> paramMap,
            HttpSession session, HttpServletRequest request,
            HttpServletResponse response) throws Exception {
        Map<String, Object> result = new HashMap<>();

        try {
            Log.Debug("Login =====");

//            Map<?, ?> loginUser = selfLoginService.getLoginSelf(paramMap);

            Map<String, Object> elemQueryMap = new HashMap<>();
            Map<String, Object> chgMap = new HashMap<>();
            String stdCdClob = "";
            String Message = "";
            String query = "";
            try{
                //재직 이력 쿼리 조회 SELF_EMP_HIS
                paramMap.put("stdCd", "SELF_LOGIN_SQL");
                elemQueryMap	= (Map<String, Object>) selfCommonService.getStdCdClob(paramMap);
                stdCdClob   		= (String) elemQueryMap.get("stdCdClob");
                Log.Debug(elemQueryMap.toString());
            }catch(Exception e){
                Message="조회에 실패하였습니다.";
                Log.Debug(e.getMessage());
            }

            query = stdCdClob.replaceAll("#\\{ssnLocaleCd}", cAdd(""));
            query = query.replace("#{birYmd}", cAdd(paramMap.get("birYmd").toString()));
            query = query.replace("#{name}", cAdd(paramMap.get("name").toString()));
            query = query.replace("#{phoneNo}", cAdd(paramMap.get("phoneNo").toString()));
            Log.Debug(query);
            paramMap.put("resultQuery", query);
            Log.Debug(paramMap.toString());

            Map<?, ?> loginUser = selfCommonService.getSelfQueryResult(paramMap);

            //로그인 토큰 생성
            String token = setJwtToken(loginUser.get("ssnEnterCd").toString(), loginUser.get("ssnSabun").toString());

//            result.put("loginUser", loginUser);
            //생성된 토큰 리턴
            result.put("token", token);

        } catch(Exception e){
            Log.Debug(e.getLocalizedMessage());
            result.put("failRev", e);
            result.put("isUser", "loginFail");
            result.put("msg", "Authorized access");
            result.put("code", "401");
            return result;
        }

        return result;
    }

    public String setJwtToken(String enterCd, String sabun) throws GeneralSecurityException, UnsupportedEncodingException, ParseException, JOSEException, JsonProcessingException {
        Map<String, Object> tokenMap = new HashMap<>();
        tokenMap.put("enterCd", enterCd);
        tokenMap.put("sabun", sabun);
        Log.Debug(tokenMap.toString());
        return JweToken.createJWT(tokenMap, 120);
    }

    public String cAdd(String str){
        return "'"+str+"'";
    }
}
