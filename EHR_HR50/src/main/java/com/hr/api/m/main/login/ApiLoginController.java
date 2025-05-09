package com.hr.api.m.main.login;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.hr.api.common.util.JweToken;
import com.hr.common.com.ComService;
import com.hr.common.logger.Log;
import com.hr.common.mail.CommonMailService;
import com.hr.common.other.OtherService;
import com.hr.common.security.SecurityMgrService;
import com.hr.common.springSession.SpringSessionService;
import com.hr.common.util.DateUtil;
import com.hr.common.util.RSA;
import com.hr.common.util.SessionUtil;
import com.hr.common.util.StringUtil;
import com.hr.common.util.api.ApiUtil;
import com.hr.common.util.mail.MailUtil;
import com.hr.common.util.mail.SmtpMailUtil;
import com.hr.main.login.LoginService;
import com.hr.main.privacyAgreement.PrivacyAgreementService;
import com.hr.sys.other.noticeTemplateMgr.NoticeCommonConstants;
import com.hr.sys.other.noticeTemplateMgr.NoticeTemplateMgrService;
import com.hr.sys.security.userMgr.UserMgrService;
import com.nhncorp.lucy.security.xss.LucyXssFilter;
import com.nhncorp.lucy.security.xss.XssPreventer;
import com.nhncorp.lucy.security.xss.XssSaxFilter;
import com.nimbusds.jose.JOSEException;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.MDC;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.UnsupportedEncodingException;
import java.security.GeneralSecurityException;
import java.security.PrivateKey;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

@RestController
@RequestMapping(value="/api/v5")
public class ApiLoginController {

    @Autowired
    private LoginService loginService;

    @Inject
    @Named("SecurityMgrService")
    private SecurityMgrService securityMgrService;

    @Inject
    @Named("PrivacyAgreementService")
    private PrivacyAgreementService privacyAgreementService;

    @Inject
    @Named("ComService")
    private ComService comService;

    @Inject
    @Named("UserMgrService")
    private UserMgrService userMgrService;

    @Inject
    @Named("CommonMailService")
    private CommonMailService commonMailService;

    @Inject
    @Named("OtherService")
    private OtherService otherService;

    @Inject
    @Named("NoticeTemplateMgrService")
    private NoticeTemplateMgrService noticeTemplateMgrService;

    @Autowired
    private SpringSessionService springSessionService;

    @Value("${mail.server}")
    private String mailServer;
    @Value("${mail.user}")
    private String mailUser;
    @Value("${mail.passwd}")
    private String mailPasswd;
    @Value("${mail.tester}")
    private String mailTester;
    @Value("${mail.sender}")
    private String mailSender;


    /**
     * 메인 로그인 회사 조회
     *
     * @param paramMap
     * @throws Exception
     */
    //@RequestMapping(params="cmd=getLoginEnterList", method = RequestMethod.POST )
    @RequestMapping(value="/getLoginEnterList", method=RequestMethod.GET )
    public Map<String, Object> getLoginEnterList(Map<String, Object> paramMap) throws Exception {
        Log.DebugStart();
        Map<String, Object> result = new HashMap<>();

        paramMap.put("localeCd",	paramMap.get("localeCd"));

        //paramMap.put("domain",	request.getServerName());
        List<?> list = loginService.getLoginEnterList(paramMap);
        ModelAndView mv = new ModelAndView();

        result.put("loginEnterList", list);

        Log.DebugEnd();
        return result;
    }

    /**
     * getRsaKey
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/login/getRsaKey")
    public Map<String, Object> getRsaKey(HttpSession session) throws Exception {
        Map<String, Object> result = new HashMap<>();
        RSA rsa = RSA.getEncKey();

        String modulus = null;
        String exponent = null;

        if (rsa != null) {
            modulus = rsa.getPublicKeyModulus();
            exponent = rsa.getPublicKeyExponent();
            session.setAttribute("_RSA_WEB_Key_", rsa.getPrivateKey());
        }

        result.put("modulus", modulus);
        result.put("exponent", exponent);

        return result;
    }

    /**
     * 로그인
     * @param paramMap
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/login/join")
    public Map<String, Object> join(
            @RequestBody Map<String, Object> paramMap,
            HttpSession session, HttpServletRequest request,
            HttpServletResponse response) throws Exception {
        Map<String, Object> result = new HashMap<>();

        try {
            Log.Debug("Login Check =====");
            String uid 	= StringUtil.stringValueOf(paramMap.get("userId"));
            String pwd 	= StringUtil.stringValueOf(paramMap.get("userPwd"));
            String lan 	= StringUtil.stringValueOf(paramMap.get("userLang"));

            PrivateKey privateKey = (PrivateKey) session.getAttribute("_RSA_WEB_Key_");  //로그인전에 세션에 저장된 개인키를 가져온다.

            /**
             * 비밀번호 실패 횟수 제한 체크
             */
            //암호화처리된 사용자계정정보를 복호화 처리한다.
            String _uid = RSA.decryptRsa(privateKey, uid);
            String _pwd = RSA.decryptRsa(privateKey, pwd);
            String _lan = lan;

            paramMap.put("link", paramMap.get("userLink"));
            paramMap.put("loginEnterCd", paramMap.get("userComp"));
            paramMap.put("loginUserId", _uid);
            paramMap.put("loginPassword", _pwd);
            paramMap.put("localeCd", _lan);

            // 비밀번호 마스킹 처리를 위한 선언
            MDC.put("PWD", _pwd);

            Map<String,String> loginTryCntMap = (Map<String, String>) loginService.loginTryCnt(paramMap);

            /**
             *  해당 ID가 존재 하지 않음
             */
            if(loginTryCntMap.get("idExst").equals("N")){
                result.put("isUser", "notExist");
                result.put("message", "Authorized access");
                result.put("code", "401");
                return result;
            }

            /**
             * ID가 잠김
             */
            if(loginTryCntMap.get("rockingYn").equals("Y")){
                result.put("isUser", "rocking");
                result.put("message", "Authorized access");
                result.put("code", "401");
                return result;
            }

            /**
             * 로그인 실패 횟수 Over
             */
            if(loginTryCntMap.get("loginFailCntYn").equals("Y")){
                result.put("isUser", "cntOver");
                result.put("message", "Authorized access");
                result.put("code", "401");
                return result;
            }

            /**
             * 비밀번호가 틀림
             */
            if(loginTryCntMap.get("pswdClct").equals("Y")){
                int loginFailCnt = Integer.parseInt(StringUtil.stringValueOf(loginTryCntMap.get("loginFailCnt"))); //로그인 실패 횟수
                paramMap.put("loginFailCnt", loginFailCnt);
                loginService.saveLoingFailCnt(paramMap);
                result.put("isUser", "notMatch");
                result.put("loginFailCntStd", loginTryCntMap.get("loginFailCntStd"));
                result.put("loginFailCnt", loginFailCnt+1);
                result.put("message", "Authorized access");
                result.put("code", "401");
                return result;
            }

            /**
             * 로그인 사용자 정보 조회
             */
            Map<String,String> loginUserChk = (Map<String, String>) loginService.loginUserChk(paramMap);

            Log.Debug("=========================)");
            Log.Debug("로그인 사용자 정보 조회="+ loginUserChk.toString());
            Log.Debug("=========================)");

            /**
             * 사용자 정보가 없음
             */
            if (loginUserChk == null || loginUserChk.size() == 0) {
                result.put("isUser", "noLogin");
                result.put("message", "Authorized access");
                result.put("code", "401");
                return result;
            }

            Map<String,String> systemOptionMap = (Map<String, String>) loginService.systemOption(paramMap);
            Log.Debug("=========================)");
            Log.Debug("정보 ="+ systemOptionMap.toString());
            Log.Debug("=========================)");

            Set<String> systemSet = systemOptionMap.keySet();
            Iterator<String> sysIterator = systemSet.iterator();
            Log.Debug("┌────────────────── Create System Option Start ─────────────────");
            while (sysIterator.hasNext()) {
                String key = sysIterator.next();
                String value = systemOptionMap.get(key);
                Log.Debug("│ " + key + ":" + value);
                session.setAttribute(key, value);
            }
            Log.Debug("└────────────────── Create System Option End ────────────────────");

            //중복로그인 알림 메시지
            String loginSabun = (String)loginUserChk.get("ssnSabun");
            String ssnSecurityYn = (String)session.getAttribute("ssnSecurityYn");
            String ssnSecurityDetail = (String)session.getAttribute("ssnSecurityDetail"); // SPU

            if(ssnSecurityDetail.indexOf("S") > -1) { //중복로그인,세션변조 체크 여부
                // 회사코드, 사번으로 세션 ID 조회
                Map<String, Object> sessionParamMap = new HashMap<String, Object>();
                sessionParamMap.put("ssnEnterCd", paramMap.get("userComp"));
                sessionParamMap.put("ssnSabun", loginSabun);
                List<String> existingSessions = springSessionService.getSessionIdsByEnterCdSabun(sessionParamMap);

                // 기존 세션이 존재하면 중복 로그인 처리
                if (existingSessions != null && !existingSessions.isEmpty()) {
                    result.put("loginDup", "Y");
                }
            }

//            //파라미터 정보를 임시로 세션에 담아 놓음.
            paramMap.put("loginSabun", loginUserChk.get("ssnSabun"));

            Log.Debug("=========================)");
            Log.Debug("loginUser.do 처음 ="+ paramMap.toString());
            Log.Debug("=========================)");

            /**
             * 사용자 정보 체크 여부 : ssnLoginUserId, ssnSabun 값이 없으면 잘못된 접근임.
             */
            String ssnLoginUserId 	= StringUtil.stringValueOf(paramMap.get("loginUserId"));
            String ssnAdmin 		= StringUtil.stringValueOf(session.getAttribute("ssnAdminGrpYn")); // 누가 이름 변경함 ..
            String ssnSabun 		= StringUtil.stringValueOf(loginUserChk.get("ssnSabun"));

            ssnSabun = ssnSabun.equals("") ?  ssnLoginUserId : ssnSabun;

            String ssnEncodedKey 	= StringUtil.stringValueOf(session.getAttribute("ssnEncodedKey"));
            String ssnSso		 	= StringUtil.stringValueOf(session.getAttribute("ssnSso"));

            //로그인 토큰 생성
            String token = setJwtToken(paramMap.get("loginEnterCd").toString(), ssnSabun);

            boolean bSso = false;

            /* sso 변수 세팅 시작  */

            if(ssnSso.equals("Y")){
                bSso = true;
            }

            Log.Debug(">>>>>>단계101");

            Log.Debug("◆◆ssnLoginUserId : 	"+ssnLoginUserId);
            Log.Debug("◆◆ssnSabun : 		"+ssnSabun);

            // 비밀번호 마스킹 처리를 위한 선언
            MDC.put("PWD", (String) paramMap.get("loginPassword"));

            Log.Debug(">>>>>>"+ paramMap.toString());

            if ( ssnSabun.length() == 0 ) {
                Log.Debug(">>>>>>ssnSabun.length()");
                result.put("message", "Authorized access");
                result.put("code", "401");
                return result;
//            return new ModelAndView("redirect:/Info.do?code=999"); //잘못된 접근
            }

            if ( ssnEncodedKey.length() > 0  && ssnSabun.length() > 0 ) { //이미 로그인 되어 있음.
                result.put("token", token);

                Log.Debug(">>>>>>단계111_4");
                //관리자가 회사,사용자 변경 했을 때
                String chgSabun = StringUtil.stringValueOf(paramMap.get("chgSabun")); //관리자가 사용자 변경
                String chgEnterCd = StringUtil.stringValueOf(paramMap.get("chgEnterCd")); //변경 회사코드
                String confirmPwd = StringUtil.stringValueOf(paramMap.get("confirmPwd")); //비밀번호

                Log.Debug("◆◆ chgSabun : "+chgSabun + ", ssnAdmin : "+ssnAdmin+ ", chgEnterCd : "+chgEnterCd+ ", confirmPwd : "+confirmPwd);

                //관리자가 아니면
                if(!"Y".equals(ssnAdmin)){
                    Log.Debug(">>>>>>ssnAdmin");
                    result.put("message", "Authorized access");
                    result.put("code", "401");
                    return result;
//                return new ModelAndView("redirect:/Main.do"); //잘못된 접근
                }
                //사용자 변경
                if( !( paramMap.get("chgSabun") == null || chgSabun.equals("") || paramMap.get("confirmPwd") == null || confirmPwd.equals("")) ){
                    //if( (chgSabun + confirmPwd).length() >0 ){
                    Log.Debug(">>>>>>chgSabun");
                    return chguser(session, paramMap, request, response);
                }
                //회사 변경
                if( !( paramMap.get("chgEnterCd") == null || chgEnterCd.equals("") || paramMap.get("confirmPwd") == null || confirmPwd.equals("")) ){
                    //if( (chgEnterCd + confirmPwd).length() > 0 ){
                    Log.Debug(">>>>>>chgCompany");
                    result.put("message", "Authorized access");
                    result.put("code", "401");
                    return result;
//                    return chgCompany(session, paramMap, request);
                }
//            return new ModelAndView("redirect:/Main.do"); //잘못된 접근
//                result.put("message", "Authorized access");
//                result.put("code", "401");
//                return result;
            }

            String ssnPwChkCode = "";
            String ssnPwChkLev = "";

            Log.Debug(">>>>>>sso인");
            if ( bSso ){
                //sso인 경우
                ssnPwChkCode = "UCK";
                Log.Debug(">>>>>>0_1");
            } else {
                /**
                 * 개인정보보호법동의
                 */
                List<?> pvAgreelist  = new ArrayList<Object>();
                paramMap.put("ssnSabun", loginUserChk.get("ssnSabun"));
                paramMap.put("ssnEnterCd", paramMap.get("loginEnterCd"));
                pvAgreelist = privacyAgreementService.getPrivacyAgreementMaster(paramMap);
                if( pvAgreelist.size() > 0 ){
                    //개인정보보호법동의가 필요함.
                    Log.DebugEnd();
//                return new ModelAndView("redirect:/Privacy.do");
                    result.put("message", "Authorized access");
                    result.put("code", "401");
                    return result;
                }

                /**
                 * 패스워드 만료 조회
                 */
                Map<String,String> pwdsMdfDateMap = (Map<String, String>) loginService.getChkPwdsMdfDateMap(paramMap);
                ssnPwChkCode = (String)pwdsMdfDateMap.get("chkCode");
                ssnPwChkLev = (String)pwdsMdfDateMap.get("pwChkLev");
                int ssnRmnDate = 0;
                if( pwdsMdfDateMap.get("rmnDate") != null ){
                    ssnRmnDate = Integer.parseInt(String.valueOf(pwdsMdfDateMap.get("rmnDate")));
                }

                session.setAttribute("ssnPwChkLev", ssnPwChkLev);  //비밀번호 체크 레벨 - 로그인후 비밀번호 변경 팝업에서 사용함.
                session.setAttribute("ssnPwChkCode", ssnPwChkCode); //비밀번호 만료 여부
                session.setAttribute("ssnRmnDate", ssnRmnDate);  //비밀번호 체크 기한

                //비밀번호 변경에서 다음에 변경하기 버튼 클릭시 로그인 화면이 아니고 메인으로 로그인 하도록 변경
                //chkPwdYn 이 N 면 로그인 되도록 수정함
                String chkPwdYn = (String)paramMap.get("chkPwdYn")  == null ? "Y" : (String)paramMap.get("chkPwdYn");
                if(chkPwdYn.equals("N")){
                    ssnPwChkCode = "UCK";
                    session.setAttribute("ssnPwChkCode", "UCK");
                }
            }

            Log.Debug(">>>>>>ssnPwChkCode");
            if( ssnPwChkCode.equals("BLK")  ){
                //로그인 안함.
                Log.Debug(">>>>>>2");
            }else{
                Log.Debug(">>>>>>Login");
                /**
                 * 로그인 사용자 정보 조회
                 */
                paramMap.put("strParam","'BASE_LANG'");
                paramMap.put("baseLang",comService.getComRtnStr(paramMap));

                Map<String, String> loginUserMap = (Map<String, String>) loginService.loginUser(paramMap);

                // 세션 관리자에 세션 정보 저장
                springSessionService.setSession(
                    token,
                    loginUserMap.get("ssnEnterCd"),
                    loginUserMap.get("ssnSabun")
                );

                Set<String> sessionSet = loginUserMap.keySet();
                Iterator<String> sessionIterator = sessionSet.iterator();
                Log.Debug("┌────────────────── Create Session Start1 ────────────────────────");
                while (sessionIterator.hasNext()) {
                    String key = sessionIterator.next();
                    String value = loginUserMap.get(key);
                    Log.Debug("│ " + key + ":" + value);

                    session.setAttribute(key, value);
                }

                //그룹설정
                paramMap.put("ssnSabun", loginUserMap.get("ssnSabun"));
                paramMap.put("ssnEnterCd", loginUserMap.get("ssnEnterCd"));
                paramMap.put("ssnLocaleCd",	paramMap.get("localeCd"));
                List<?> athGrpList = loginService.getAuthGrpList(paramMap);
                Map<String, Object> athGrpMap = (Map<String, Object>)athGrpList.get(0);
                Set<String> athGrpSet = athGrpMap.keySet();
                Iterator<String> athGrpIterator = athGrpSet.iterator();

                while (athGrpIterator.hasNext()) {
                    String key = athGrpIterator.next();

                    String value = athGrpMap.get(key) == null ? "" : String.valueOf(athGrpMap.get(key));
                    Log.Debug("││ " + key + ":" + value);
                    session.setAttribute(key, value);
                }
                // 관리자그룹 권한을 가지고 있는지 여부를 체크
                if( "Y".equals(String.valueOf(session.getAttribute("ssnAdminGrpYn"))) ) {
                    session.setAttribute("ssnAdmin", "Y"); //관리자임
                    session.setAttribute("ssnAdminEnterCd", loginUserMap.get("ssnEnterCd")); //ADMIN 회사코드
                    session.setAttribute("ssnAdminSabun", loginUserMap.get("ssnSabun")); //ADMIN 사번
                    session.setAttribute("ssnAdminLoginUserId",(String)session.getAttribute("ssnLoginUserId")); //ADMIN ID
                    session.setAttribute("ssnAdminName", loginUserMap.get("ssnName")); //ADMIN 이름
                }else{
                    session.setAttribute("ssnAdminFncYn", "N"); //관리자가 아니면 무조건 N으로
                }

                if ( session.getAttribute("ssnTimeOut") != null && !"".equals(session.getAttribute("ssnTimeOut")) ){//null 여부
                    // 숫자인지 확인  sheet에 입력제한없음----------------------
                    String expr = "^[-+]?(0|[1-9][0-9]*)(\\.[0-9]+)?([eE][-+]?[0-9]+)?$";
                    String str = (String) session.getAttribute("ssnTimeOut");
                    Pattern pattern = Pattern.compile(expr);
                    Matcher matcher = pattern.matcher(str);

                    // 숫자인지 확인  sheet에 입력제한없음----------------------
                    if ( matcher.matches()){ // 숫자일경우
                        Float ssnTimeOut = Float.parseFloat(str);

                        if ( ssnTimeOut > 0 ){ // 0보다 클경우 중간에 문자로 - 넣을수있어서 체크
                            ssnTimeOut = ssnTimeOut * 60;
                            session.setMaxInactiveInterval(Math.round(ssnTimeOut));
                        }else{
                            session.setMaxInactiveInterval( 30 * 60);
                        }
                    }else{//숫자가 아닐경우 default 30분
                        session.setMaxInactiveInterval( 30 * 60);
                    }
                }else{// null 값일 경우 default 30분
                    session.setMaxInactiveInterval( 30 * 60);
                }

                session.setAttribute("theme", session.getAttribute("ssnSkinType")); //차후 DB 에서
                session.setAttribute("wfont", session.getAttribute("ssnFontType")); //차후 DB 에서
                session.setAttribute("maintype", session.getAttribute("ssnMainType")); //차후 DB 에서

                //JSESSIONID : PC = session.getId(), Mobile = token
                session.setAttribute("logingetId", token);//
                session.setAttribute("ssnLoginTime", DateUtil.getDateTime());//
                session.setAttribute("ssnLoginAgent", request.getHeader("User-Agent"));//

                Log.Debug("│ ssnLoginTime:" + session.getAttribute("ssnLoginTime"));
                Log.Debug("│ ssnLoginAgent:" + session.getAttribute("ssnLoginAgent"));
                Log.Debug("│ theme:" + session.getAttribute("theme"));
                Log.Debug("│ wfont:" + session.getAttribute("wfont"));
                Log.Debug("│ maintype:" + session.getAttribute("maintype"));
                Log.Debug("│ MaxInactiveInterval:" + session.getMaxInactiveInterval());
                Log.Debug("└────────────────── Create Session End ────────────────────────");

                //session.setAttribute("logIp", request.getRemoteHost());
                session.setAttribute("logIp", StringUtil.getClientIP(request));
                session.setAttribute("logRequestUrl", request.getRequestURL() + (request.getQueryString() != null  ? "?" + request.getQueryString(): ""));
                session.setAttribute("logController", "LoginController");

                /*■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■*/
                // 시스템 보안체크 여부에 따라 보안체크
                /*■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■*/
//                String ssnSecurityYn = (String)session.getAttribute("ssnSecurityYn");
//                String ssnSecurityDetail = (String)session.getAttribute("ssnSecurityDetail"); // SPU
                String ssnSecDupLoginAllowYn = (String)session.getAttribute("ssnSecDupLoginAllowYn"); // 중복로그인 허용 여부
                Log.Debug("■ SSN_SECURITY_YN:" + ssnSecurityYn);
                Log.Debug("■ SSN_SECURITY_DETAIL:" + ssnSecurityDetail);
                Log.Debug("■ SSN_SEC_DUP_LOGIN_ALLOW_YN:" + ssnSecDupLoginAllowYn);

                /**
                 *  체크 대상 파라미터 이름
                 */
                //if( ssnSecurityDetail.indexOf("P") > -1 ){ //파라미터 변조 체크 여부
                Map<String, Object> sabunNames = (Map<String, Object>) securityMgrService.getCheckSabunName(paramMap);
                session.setAttribute("ssnCheckSabun", sabunNames.get("sabuns"));
                //}

                /**
                 * 이전 로그인 정보 조회
                 */
                Log.Debug("ssnSecurityDetail==>>"+ ssnSecurityDetail);
                if( ssnSecurityDetail.indexOf("S") > -1 ){ //중복로그인,세션변조 체크 여부
                    Map<?, ?> getToken = securityMgrService.getSelectTSEC007(paramMap) ;
                    if( getToken != null ){
                        String before_sessionId = (String)getToken.get("jsessionid");
                        Log.Debug("■ before_sessionId : " +before_sessionId );

                        // 세션 유무 확인
                        String[] attributeNames = {"ssnEnterCd", "ssnSabun"};
                        Map<String, Object> sessionParamMap = new HashMap<String, Object>();
                        sessionParamMap.put("sessionId", before_sessionId);
                        sessionParamMap.put("attributeNames", attributeNames);

                        Map<String, Object> sessionInfo = (Map<String, Object>) springSessionService.getSessionDataBySessionId(sessionParamMap);

                        if( sessionInfo != null && !sessionInfo.isEmpty()){
                            String sessionEnterCd = (String) sessionInfo.get("ssnEnterCd");
                            String sessionSabun = (String) sessionInfo.get("ssnSabun");

                            // 기존 세션이 존재 하는 경우,
                            if(sessionEnterCd != null && !sessionEnterCd.isEmpty() && sessionSabun != null && !sessionSabun.isEmpty()){
                                // 중복 로그인 플래그 설정 (현재 세션)
                                session.setAttribute("loginDup", "Y");

                                // 중복 로그인 허용 여부가 'N'인 경우 추가 세션 무효화처리
                                if ("N".equals(ssnSecDupLoginAllowYn)) {

                                    // 세션 목록 조회
                                    List<String> sessions = springSessionService.getSessionIdsByEnterCdSabun(sessionInfo);
                                    if(sessions != null && !sessions.isEmpty()){
                                        sessionInfo.put("currentSessionId", session.getId());
                                        springSessionService.invalidateSessionsExcludeCurrent(sessionInfo);
                                    }
                                }
                                paramMap.put("loginDup", "Y");

                                //중복 로그인 정보 DB 저장
                                paramMap.put("ssnEnterCd",	session.getAttribute("ssnEnterCd"));
                                paramMap.put("job",			"view");
                                paramMap.put("ip",			getToken.get("IP") + "->" + StringUtil.getClientIP(request));
                                paramMap.put("refererUrl",	"");
                                paramMap.put("requestUrl",	"");
                                paramMap.put("controller",	"");
                                paramMap.put("queryId",		"992");
                                paramMap.put("menuId",		"");
                                paramMap.put("ssnGrpCd",	session.getAttribute("ssnGrpCd"));
                                paramMap.put("memo",		"중복 로그인"); //관리자 표시 안함
                                paramMap.put("ssnSabun",	session.getAttribute("ssnSabun"));

                                securityMgrService.PrcCall_P_COM_SET_OBSERVER(paramMap);

                                //로그아웃 정보 저장
                                Map<String, Object> paramMap2 = new HashMap<String, Object>();
                                paramMap2.put("jsessionid", before_sessionId);
                                securityMgrService.updateLogoutDup(paramMap2);
                            }
                        }
                    }
                }


                /**
                 *  로그인 정보 DB에 저장
                 */
                String clientIp = (String) SessionUtil.getRequestAttribute("logIp");
                if( !StringUtils.isBlank(clientIp) ) {
                    clientIp = StringUtil.getClientIP(request);
                }
                paramMap.put("clientIp", clientIp);

                Log.Debug("=========================)");
                Log.Debug("로그인 정보 DB에 저장 ="+ paramMap.toString());
                Log.Debug("=========================)");

                /**  로그인 기록 **/
                securityMgrService.insertLogin(paramMap);


                /**  로그인 기록 **/
                Log.Debug("=========================)");
                Log.Debug("로그인 정보 기록  ="+ paramMap.toString());
                Log.Debug("=========================)");

                loginService.loginUserLog(paramMap);

                //String goDoStr = (null == paramMap.get("link")) ? "/Main.do" : "/Link.do";


                String goDoStr = (0 == (paramMap.get("link") == null ? "" : String.valueOf(paramMap.get("link"))).length()) ? "/Main.do" : "/Link.do?link="+ paramMap.get("link");

                Log.Debug("┌────────────────── Out Link Start ────────────────────────");
                Log.Debug("│ link :" + paramMap.get("link"));
                Log.Debug("│ link len:" + (String.valueOf(paramMap.get("link"))).length());
                Log.Debug("│ link rlen:" + (paramMap.get("link") == null ? "" : String.valueOf(paramMap.get("link"))).length());
                Log.Debug("│ goDoStr :" + goDoStr);
                Log.Debug("│ paramMap :" + paramMap);
                Log.Debug("└────────────────── Out Link End ────────────────────────");

                //비밀번호 실패 횟수 초기화
                loginService.saveLoingFailCntInte(paramMap);

                //strLocale 선택 없을경우 대비
                String strLocale = paramMap.get("localeCd") == null ? "" : String.valueOf(paramMap.get("localeCd"));

                if(strLocale.length() >0 ){
                    Log.Debug("strLocale 있다") ;
                    paramMap.put("strLocale",strLocale);
                    comService.changeLocale(session,request,response,paramMap);
                }
                else{
                    Log.Debug("strLocale 없다") ;
                    session.setAttribute("localeCd1", null);
                    session.setAttribute("localeCd2", null);
                    session.setAttribute("language", "kr");
                }

                //정상 로그인.
                if( ssnPwChkCode.equals("UCK")  ){
                    //임시 세션 값 삭제
                    session.removeAttribute("ssnPwChkCode");
                    session.removeAttribute("ssnRmnDate");
                    session.removeAttribute("ssnPwChkLev");

                    Map<String,String> loginUser = (Map<String, String>) loginService.loginUser(paramMap);

                    result.put("loginUser", loginUser);
                    //생성된 토큰 리턴
                    result.put("token", token);

                    return result;
                } else if( ssnPwChkCode.equals("IPS") ) {
                    // 비밀번호가 주민번호 뒷자리와 일치하는 경우 비밀번호 변경 화면으로 이동함.
//                return new ModelAndView("redirect:/PwdChgForm.do");
                    result.put("code", "999");
                    result.put("msg", "비밀번호 변경");
                    return result;
                }
            }

            Log.DebugEnd();
//        return new ModelAndView("redirect:/PwdChgForm.do");
            result.put("code", "999");
            result.put("msg", "잘못된 접근");
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

    @RequestMapping(value="/logout", method=RequestMethod.POST )
    public Map<String, Object> logoutUser(HttpServletRequest request) throws Exception {
        Log.DebugStart();
        Map<String, Object> result = new HashMap<>();
        HttpSession session = request.getSession(false);

        Log.Debug("logout=>>"+StringUtil.stringValueOf(session));
        String sessionStr =StringUtil.stringValueOf(session);
        Log.Debug("logout=>>"+sessionStr.length() + "==>>"+ sessionStr);

        if (session != null) { // 세션이 존재하면
            session.invalidate(); // 세션 무효화 (Spring Session이 DB에서 자동 삭제)
        }

        Log.DebugEnd();
        return result;
    }

    /**
     * 비밀번호 찾기
     */
    @RequestMapping(value="/PwdFindAction", method=RequestMethod.POST )
    public Map<String, Object> userFindPwdInit(
            HttpSession session, HttpServletRequest request,
            @RequestBody Map<String, Object> paramMap) throws Exception {
        Log.DebugStart();
        Log.Debug("PwdFindAction =====");
        Log.Debug(paramMap.toString());
        Map<String, Object> result = new HashMap<>();

        session.removeAttribute("ssnNewPwd");

        paramMap.put("phone", 	paramMap.get("loginphone"));
        paramMap.put("email", 	paramMap.get("loginEmail"));
        paramMap.put("type", 	paramMap.get("type"));

        Log.Debug("paramMap.get(type)= "+ paramMap.get("type"));
        String resultMsg = "";

        /**
         * 본인 확인
         */
        Map<?, ?> findMap = loginService.getLoginPwdFind(paramMap);
        int resultCnt = Integer.parseInt( findMap.get("cnt").toString());
        Log.Debug("cnt=> "+ resultCnt);

        if (resultCnt < 1){
            resultMsg = "notMatch";

        }else {

            //임시 비밀번호 생성
            Map<?, ?> newPwd = userMgrService.pwdRandom(paramMap);
            Log.Debug("newPwd=> "+ newPwd.get("nPwd"));

            paramMap.put("newPwd",newPwd.get("nPwd"));
            paramMap.put("ssnEnterCd", paramMap.get("enterCd"));
            paramMap.put("ssnSabun", paramMap.get("sabun"));

            try{
                //패스워드 초기화
                int initResult = userMgrService.setUserMgrPwdInit(paramMap);

                if (initResult > 0) {
                    session.setAttribute("ssnNewPwd", newPwd.get("encPwd"));
                    resultMsg = "success";
                }else {
                    resultMsg = "error";
                }

            }catch(Exception e){
                resultMsg = "error";
            }
        }

        result.put("result", resultMsg);
        Log.DebugEnd();

        return result;
    }

    /* 비밀번호 찾기 : 세션값 존재하지 않음 */
    @RequestMapping(value="/callMailPwd", method=RequestMethod.POST )
    public Map<String, Object> callMailPwd(HttpServletRequest request, @RequestBody Map<String, Object> paramMap)
            throws Exception {
        Map<String, Object> result = new HashMap<>();
        Log.Debug("callMailPwd =====");
        Log.Debug(paramMap.toString());

        String receverStr = "";
        String newPwdStr = "";

        String bizCd = NoticeCommonConstants.BIZ.FIND_PWD.name();
        String uri   = request.getRequestURL().toString().replace(request.getRequestURI(), "");

        paramMap.put("enterCd"   , paramMap.get("enterCd").toString());
        paramMap.put("ssnEnterCd", paramMap.get("enterCd").toString());
        paramMap.put("sabun"     , paramMap.get("sabun").toString());
        paramMap.put("data1"     , request.getSession().getAttribute("ssnNewPwd"));
        paramMap.put("bizCd"     , bizCd);

        Map<?, ?> deEncPwd = otherService.getBase64De(paramMap);
        newPwdStr = deEncPwd != null && deEncPwd.get("code") != null ? deEncPwd.get("code").toString():"";


        /** 알림서식 조회 */
        Map<String, Map<String, Object>> template = noticeTemplateMgrService.getTemplateMapByBizCd((String) paramMap.get("enterCd"), bizCd, null);
        Map<String,Object> templateCont = null;
        /** [END] 알림서식 조회 */


        if (paramMap.get("type").toString().equals("0")) {

            Map<?, ?> mailInfo = commonMailService.mailSendSabunToInfo(paramMap);

            if( template != null && !template.isEmpty() ) {
                templateCont = template.get(NoticeCommonConstants.TYPE.MAIL.name());
            }

            String mailTitle   = "";
            String mailContent = "";
            String applName    = "";
            String applSabun   = "";
            String fromMail    = "";
            String sender      = "";

            if (templateCont == null || mailInfo == null) {
                result.put("result", "메일 발송실패하였습니다. \n관리자에게 문의하세요.");

            } else if (templateCont.get("useYn").toString().equals("N")) {
                result.put("result", "알림서식의 메일 사용여부가 설정되지 않았습니다. \n관리자에게 문의하세요.");
            } else {

                receverStr  = mailInfo.get("receverStr").toString();
                applName    = mailInfo.get("name").toString();
                applSabun   = mailInfo.get("sabun").toString();

                sender      = templateCont.get("senderNm").toString();
                fromMail    = templateCont.get("sendMail").toString();
                mailTitle   = templateCont.get("templateTitle").toString();
                mailContent = templateCont.get("templateContent").toString();

                /*
                 * 2019-05-02 메일 파라메터 CONTENT_TITLE - 메일 본문 제목 APPL_NAME - 신청자명 APPL_SABUN -
                 * 신청자사번 INIT_PWD - 임시비밀번호
                 */
                mailContent = StringUtil.stringReplace(mailContent, "#CONTENT_TITLE#", mailTitle);
                mailContent = StringUtil.stringReplace(mailContent, "#APPL_NAME#"    , applName);
                mailContent = StringUtil.stringReplace(mailContent, "#APPL_SABUN#"   , applSabun);
                mailContent = StringUtil.stringReplace(mailContent, "#INIT_PWD#"     , newPwdStr);
                mailContent = StringUtil.stringReplace(mailContent, "#URI#"          , uri);

                paramMap.put("receverStr" , receverStr);
                paramMap.put("mailTitle"  , mailTitle);
                paramMap.put("mailContent", mailContent);
                paramMap.put("fromMail"   , fromMail);
                paramMap.put("bizCd"      , bizCd);
                paramMap.put("fileStr"    , "");
                paramMap.put("sender"     , sender);
                paramMap.put("receiveType", "0");

                result = callMail(request, paramMap);
            }

        } else {
            if( template != null && !template.isEmpty() ) {
                templateCont = template.get(NoticeCommonConstants.TYPE.SMS.name());
            }

            if (templateCont == null) {
                result.put("result", "발송실패하였습니다. \n관리자에게 문의하세요.");

            } else if (templateCont.get("useYn").toString().equals("N")) {
                result.put("result", "알림서식의 SMS 사용여부가 설정되지 않았습니다. \n관리자에게 문의하세요.");
            } else {
                Map<?, ?> smsInfo = commonMailService.smsSendSabunToInfo(paramMap);
                receverStr = smsInfo.get("receverStr").toString();
                paramMap.put("receverStr", receverStr);
                paramMap.put("context"   , templateCont.get("templateContent").toString().replace("#INIT_PWD#", newPwdStr));
                paramMap.put("sender"    , templateCont.get("senderNm").toString());
                paramMap.put("fromSms"   , templateCont.get("sendPhone").toString());
                paramMap.put("bizCd"     , bizCd);

                result = (Map<String, Object>) callSms(request, paramMap);
            }

        }
        return result;

    }

    @RequestMapping(params="callMail", method = RequestMethod.POST )
    public Map<String, Object> callMail(HttpServletRequest request, @RequestBody Map<String, Object> paramMap)
            throws Exception {
        Map<String, Object> result = new HashMap<>();
        /**
         * [0] : 수신자정보(주소;이름^주소;이름^...주소;이름) [1] : 제목 [2] : 본문 [3] : 보내는 사람 사번 [4] :
         * 발송메일주소 [5] : 업무코드[급여:CPN...
         */
        Log.Debug("----------------------------------" + paramMap.toString());

        MailUtil mailUtil = new MailUtil(request);

        /* 메일전송 관련 설정 데이터 조회 */
        SmtpMailUtil mUtil = null;
        String MAIL_SEND_TYPE = "1";
        String MAIL_SERVER    = mailServer;
        String MAIL_PORT      = null;
        String MAIL_USER      = mailUser;
        String MAIL_PASSWORD  = mailPasswd;
        String MAIL_TESTER    = mailTester;
        Map<?,?> mailStdMap = commonMailService.mailStdMap(paramMap);
        if( mailStdMap != null && !mailStdMap.isEmpty() ) {
            MAIL_SEND_TYPE = (String) mailStdMap.get("mailSendType");
            MAIL_SERVER    = (String) mailStdMap.get("mailServer");
            MAIL_PORT      = (String) mailStdMap.get("mailPort");
            MAIL_USER      = (String) mailStdMap.get("mailUser");
            MAIL_PASSWORD  = (String) mailStdMap.get("mailPassword");
            MAIL_TESTER    = (String) mailStdMap.get("mailTester");
        }
        /* [END] 메일전송 관련 설정 데이터 조회 */


        String resultStr        = "";
        String enterCd       = (String) paramMap.get("enterCd");
        String title         = (String) paramMap.get("mailTitle");
        String content       = (String) paramMap.get("mailContent");
        String sender        = (String) paramMap.get("sender");
        String fromMail      = (String) paramMap.get("fromMail");
        String receverStr    = (String) paramMap.get("receverStr");
        String ccReceiverStr = (String) paramMap.get("ccReceiverStr");
        String fileStr       = (String) paramMap.get("fileStr");
        String rcvName       = "";
        String log           = null;

        String[] tmpReceverList = null;
        String[] receverAddList = null;
        String[] tmpFileList    = null;
        String[] fileAddList    = null;

        // 회사코드 설정
        if(enterCd == null) {
            enterCd = (String) paramMap.get("ssnEnterCd");
        }

        // 이메일 내용 설정
        if(content == null) {
            content = (String) paramMap.get("content");
        }

        /**
         * 크로스 사이트 스크립팅 공격에 대비한 XssFilter 적용.
         * XssFilter 적용 시 스크립트와 같은 XSS 공격에 취약한 요소를 걸러낸다.
         * ex) 입력 값:           <img src="x" onerror="alert(document.cookie)"/>
         *     XssFilter 적용 후: <img src="x"/>
         * XssPreventer.escape: 문자열에서 HTML으로 인식될만한 요소까지도 완전 변환. 예를 들어, '<'는 '&lt;', '>'는 '&gt;'로 변환.
         * XssPreventer.unescape: 문자열에서 변환된 HTML 요소를 원본 HTML로 변환. 예를 들어, '&lt;'는 '<', '&gt;'는 '>'로 변환.
         * XssFilter: HTML 요소를 유지하되 XSS 공격에 취약한 요소만 제거.
         */
        LucyXssFilter filter = XssSaxFilter.getInstance("lucy-xss-sax.xml", true); // 두 번째 인자값은 withoutComment 로, 값이 없거나 false 인 경우 필터링 된 스크립트의 로그가 결과값에 추가됨.
        content = filter.doFilter(XssPreventer.unescape(content));
        title = filter.doFilter(XssPreventer.unescape(title));

        content = mailUtil.getMailContent(paramMap.get("receiveType").toString(), content.toString());

        // 수신자 이메일 설정
        if( !StringUtil.isBlank(receverStr) ) {
            tmpReceverList = receverStr.split("\\^");
            receverAddList = new String[tmpReceverList.length];
        }

        // 첨부파일 설정
        if( !StringUtil.isBlank(fileStr) ) {
            tmpFileList = fileStr.split("\\^");
            fileAddList = new String[tmpFileList.length];
        }

        // 전송방식이 [WAS]에서 전송하는 경우
        if( "1".equals(MAIL_SEND_TYPE) ) {
            mUtil = new SmtpMailUtil(MAIL_SERVER, Integer.parseInt(MAIL_PORT), MAIL_USER, MAIL_PASSWORD, fromMail);
        }

        // 수신자가 존재하는 경우 진행
        if( tmpReceverList != null && tmpReceverList.length > 0 ) {
            //int cnt =0;
            // 메일건수(수신자의 명수)
            int mailCnt = 0;
            // 발송성공건수
            int successMailCnt = 0;

            // 메일 SEQ
            String mailSeq = "";
            // mailSeq 조회 파라미터 삽입
            paramMap.put("seqId", "MAIL");

            for (int i = 0; i < tmpReceverList.length; i++) {
                // Reset SMTP Exception Message
                log = null;

                // 메일주소 세팅
                if (tmpReceverList[i].indexOf(";") > 0) { // test@test.com;홍길동 형식일 경우 메일주소만 취득
                    receverAddList[i] = tmpReceverList[i].split(";")[0];
                } else {
                    receverAddList[i] = tmpReceverList[i];
                }
                rcvName = tmpReceverList[i];

                // 전송방식이 [WAS]에서 전송하는 경우
                if( "1".equals(MAIL_SEND_TYPE) ) {
                    try {
                        if (mUtil != null) resultStr = mUtil.sendEmail(sender, title, receverAddList[i], content, fileAddList, MAIL_TESTER);
                    } catch (Exception e) {
                        resultStr = "N";
                        log = e.getMessage();
                    }
                } else {
                    resultStr = "N";
                }

                // SEQ 조회
                Map<?, ?> seqmap = otherService.getSequence(paramMap);

                mailSeq = seqmap != null && seqmap.get("getSeq") != null ? seqmap.get("getSeq").toString():null;
                Log.Debug("mailSeq=>>>>" + mailSeq);

                // SET paramMap
                paramMap.put("mailSeq"      , mailSeq);
                paramMap.put("title"        , title);
                paramMap.put("content"      , content);
                paramMap.put("result"       , resultStr);
                paramMap.put("mailCnt"      , "1");
                paramMap.put("rcvName"      , rcvName);
                paramMap.put("log"          , (log == null) ? "" : log);
                paramMap.put("ccReceiverStr", (ccReceiverStr == null) ? "" : ccReceiverStr);
                Log.Debug("paramMap=>>>>" + paramMap);

                // 메일 발송 결과 DB 저장
                //cnt = commonMailService.tsys996InsertMail(paramMap);
                commonMailService.tsys996InsertMail(paramMap);

                mailCnt = mailCnt + 1;
                if( "Y".equals(resultStr) ) {
                    successMailCnt = successMailCnt + 1;
                }
            }

            resultStr = "메일발송요청  : " + tmpReceverList.length + ", 메일발송건수  : " + mailCnt + ", 발송성공건수 : " + successMailCnt;
            Log.Debug("resultStr=>>>>" + resultStr);
        }

        result.put("result", resultStr);
        Log.DebugEnd();
        return result;
    }

    /**
     * SMS 전송 (이수그룹 사용)
     * @param request
     * @param paramMap
     * @return
     * @throws Exception
     */
    @RequestMapping(params="callSms", method = RequestMethod.POST )
    public ModelAndView callSms(HttpServletRequest request, @RequestParam Map<String, Object> paramMap)
            throws Exception {
        Log.DebugStart();

        String sender = String.valueOf(paramMap.get("fromSms"));
        List<String> receivers = Arrays.asList(String.valueOf(paramMap.get("receverStr")).split("\\^"));
        String title = String.valueOf(paramMap.get("title"));
        String context = String.valueOf(paramMap.get("context"));
        String chkid = String.valueOf(paramMap.get("sender"));

        Map<String, Object> param = new HashMap<String, Object>();
        param.put("fromPhoneNumber", sender);
        param.put("toPhoneNumbers", receivers);
        param.put("title", title);
        param.put("body", context);

        Map<?, ?> resultMap = ApiUtil.sendSms(param);

        Map<String, Object> logMap = new HashMap<String, Object>();
        logMap.put("enterCd", paramMap.get("enterCd").toString());
        logMap.put("jobType", "sms");
        logMap.put("jobYmd", new SimpleDateFormat("yyyyMMdd").format(Calendar.getInstance().getTime()));
        logMap.put("sender", sender);
        logMap.put("receivers", receivers);
        String temp = String.valueOf(receivers);
        if (temp != null && temp.length() > 1) {
            temp = temp.substring(1, temp.length() - 1);
        }
        logMap.put("receivers", temp);
        logMap.put("departmentCode", paramMap.get("departmentCode"));
        logMap.put("title", title);
        logMap.put("content", context);
        logMap.put("resultCd", resultMap.get("code").toString());
        logMap.put("resultMsg", resultMap.get("message").toString());
        logMap.put("chkid", chkid);
        logMap.put("seqId", "MAIL");


        Map<?, ?> seqmap = otherService.getSequence(logMap);
        String mailSeq = seqmap != null && seqmap.get("getSeq") != null ? seqmap.get("getSeq").toString():null;
        logMap.put("mailSeq", mailSeq);

        commonMailService.tsys992Insert(logMap);

        ModelAndView mv = new ModelAndView();
        mv.setViewName("jsonView");
        mv.addObject("result", resultMap);
        Log.DebugEnd();
        return mv;
    }

    /**
     * 메인 로그인 처리, 세션 생성
     *
     * @param paramMap
     * @param request
     * @return Map
     * @throws Exception
     */
    public Map<String, Object> chguser(HttpSession session,
                                @RequestParam Map<String, Object> paramMap,
                                HttpServletRequest request, HttpServletResponse response) throws Exception {
        Log.DebugStart();
        Log.Debug("LoginController.chguser Start");

        Map<String, Object> result = new HashMap<>();

        PrivateKey privateKey = (PrivateKey) session.getAttribute("_RSA_WEB_Key_");  //로그인전에 세션에 저장된 개인키를 가져온다.
        if( privateKey == null ){
//            mv.addObject("isUser", "notExist");
//            return mv;
            result.put("isUser", "notExist");
            result.put("msg", "Authorized access");
            result.put("code", "401");
            return result;
        }
        String confirmPwd = RSA.decryptRsa(privateKey, String.valueOf(paramMap.get("confirmPwd")) );//비밀번호

        //현재 로그인 사용자의 비밀번호 확인
        Map<String, Object> pwdParamMap = new HashMap<String, Object>();
        pwdParamMap.put("ssnEnterCd", 	session.getAttribute("ssnAdminEnterCd"));
        pwdParamMap.put("loginSabun", 	session.getAttribute("ssnAdminSabun"));
        pwdParamMap.put("confirmPwd", 	confirmPwd);

        // 비밀번호 마스킹 처리를 위한 선언
        MDC.put("PWD", confirmPwd);


//    	여기에서 ssnSabun 을 담는데 왜 NULL이 존재 하는가 ..confirmPwd
        Log.Debug("changUser pwdParamMap = "+ pwdParamMap.toString());

        Map<?, ?> pwdMap = loginService.getPwdConfirm(pwdParamMap); //비밀번호 체크

        if( pwdMap != null ){
            String pwdChk = String.valueOf( pwdMap.get("chk") ); //비밀번호 체크 여부
            if( pwdChk != null && !pwdChk.equals("") && pwdChk.equals("Y") ){
                //비밀번호 체크 성공
            }else{
                //비밀번호가 틀림
//                mv.addObject("isUser", "notMatch");
                result.put("isUser", "notMatch");
                result.put("msg", "Authorized access");
                result.put("code", "401");
                return result;
            }
        }else{
            //알 수 없는 오류 - null이 나올 수가 없는데...
//            mv.addObject("isUser", "notExist");
//            return mv;
            result.put("isUser", "notExist");
            result.put("msg", "Authorized access");
            result.put("code", "401");
            return result;
        }

        //개인 설정
        paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));

        //관리자인지 체크

        String ssnAdmin = (String)session.getAttribute("ssnAdmin");
        if( ssnAdmin != null && ssnAdmin.equals( "Y" ) ){
            paramMap.put("ssnTokenChkTime", session.getAttribute("ssnTokenChkTime"));

            Map<String,String> chgTokensabun = (Map<String, String>) loginService.chUserToken(paramMap);

            //없으면 아니면
            if( chgTokensabun == null ){
//                return new ModelAndView("redirect:/Main.do"); //잘못된 접근
                result.put("msg", "Authorized access");
                result.put("code", "401");
                return result;
            }else{
                paramMap.put("chgSabun", (String)chgTokensabun.get("tsabun"));
            }

            //로그에 사용자변경 이력을 남기기 위함.
            paramMap.put("_chguser_", session.getAttribute("ssnSabun")+" -> "+chgTokensabun.get("tsabun"));
            Map<String,String> chguser = (Map<String, String>) loginService.chgUser(paramMap);

            if (chguser != null && chguser.size() > 0) {

                //그룹설정
                paramMap.put("ssnSabun", chguser.get("ssnSabun"));
                paramMap.put("ssnEnterCd", chguser.get("ssnEnterCd"));
                paramMap.put("ssnLocaleCd",	paramMap.get("localeCd"));

                paramMap.put("chgSsnSabun", chguser.get("ssnSabun"));
                paramMap.put("chgSsnEnterCd", chguser.get("ssnEnterCd"));
                paramMap.put("chgSsnLocaleCd",	paramMap.get("localeCd"));

                List<?> athGrpList = loginService.getChgUserAuthGrpList(paramMap);
                Map<String, Object> athGrpMap = new HashMap<>();

                Set<String> sessionSet = chguser.keySet();
                Iterator<String> iterator = sessionSet.iterator();
                Log.Debug("┌────────────────── Create Session Start2 ────────────────────────");
                while (iterator.hasNext()) {
                    String key = iterator.next();
                    String value = chguser.get(key);
                    Log.Debug("│ " + key + ":" + value);

                    session.setAttribute(key, value);
                }
                athGrpMap = (Map<String, Object>)athGrpList.get(0);
                sessionSet = athGrpMap.keySet();
                iterator = sessionSet.iterator();
                while (iterator.hasNext()) {
                    String key = iterator.next();
                    String value = athGrpMap.get(key) == null ? "" : String.valueOf(athGrpMap.get(key));

                    Log.Debug("│ " + key + ":" + value);
                    session.setAttribute(key, value);
                }

                session.setAttribute("theme", session.getAttribute("ssnSkinType")); //차후 DB 에서
                session.setAttribute("wfont", session.getAttribute("ssnFontType")); //차후 DB 에서
                session.setAttribute("maintype", session.getAttribute("ssnMainType")); //차후 DB 에서
                Log.Debug("│ theme:" + session.getAttribute("theme"));
                Log.Debug("│ wfont:" + session.getAttribute("wfont"));
                Log.Debug("│ maintype:" + session.getAttribute("maintype"));
                Log.Debug("│ MaxInactiveInterval:" + session.getMaxInactiveInterval());
                Log.Debug("└────────────────── Create Session End ────────────────────────");

                session.setAttribute("logIp", StringUtil.getClientIP(request));
                session.setAttribute("logRequestUrl", request.getRequestURL() + "?" + request.getQueryString());
                session.setAttribute("logController", "LoginController");

                loginService.loginUserLog(paramMap);

                result.put("isUser", "exist");

                //기본 언어 설정 차후 DB에서 조회된 사용자 언어로 변경 되어야 함
                session.setAttribute("language", "kr");
            }else{
                result.put("isUser", "notExist");
                result.put("msg", "Authorized access");
                result.put("code", "401");
            }
        }else{
            result.put("isUser", "notExist");
            result.put("msg", "Authorized access");
            result.put("code", "401");
        }
        Log.DebugEnd();
        return result;
    }


    /**
     * 회사 변경
     * @param paramMap
     * @param request
     * @return Map
     * @throws Exception
     */
    public Map<String, Object> chgCompany(HttpSession session,
                                   @RequestParam Map<String, Object> paramMap,
                                   HttpServletRequest request) throws Exception {

        Log.DebugStart();
        Log.Debug("LoginController.chgCompany Start");

//        ModelAndView mv = new ModelAndView();
        Map<String, Object> result = new HashMap<>();

//        mv.setViewName("main/main/chgUserPopupRst"); //결과값을 보여주는 화면

        PrivateKey privateKey = (PrivateKey) session.getAttribute("_RSA_WEB_Key_");  //로그인전에 세션에 저장된 개인키를 가져온다.
        if( privateKey == null ){
            result.put("isUser", "notExist");
            return result;
        }
        String confirmPwd = RSA.decryptRsa(privateKey, String.valueOf(paramMap.get("confirmPwd")) );//비밀번호
        String chgEnterCd = String.valueOf(paramMap.get("chgEnterCd")); //변경 회사코드



        //현재 로그인 사용자의 비밀번호 확인
        Map<String, Object> pwdParamMap = new HashMap<String, Object>();
        pwdParamMap.put("ssnEnterCd", 	session.getAttribute("ssnAdminEnterCd"));
        pwdParamMap.put("loginSabun", 	session.getAttribute("ssnAdminSabun"));
        pwdParamMap.put("confirmPwd", 	confirmPwd);

        // 비밀번호 마스킹 처리를 위한 선언
        MDC.put("PWD", confirmPwd);

        Map<?, ?> pwdMap = loginService.getPwdConfirm(pwdParamMap); //비밀번호 체크

        if( pwdMap != null ){
            String pwdChk = String.valueOf( pwdMap.get("chk") ); //비밀번호 체크 여부
            if( pwdChk != null && !pwdChk.equals("") && pwdChk.equals("Y") ){
                //비밀번호 체크 성공
            }else{
                //비밀번호가 틀림
                result.put("isUser", "notMatch");
                return result;
            }
        }else{
            //알 수 없는 오류 - null이 나올 수가 없는데...
            result.put("isUser", "notExist");
            return result;
        }

        //로그에 회사변경 했다는 이력을 남기기 위함.
        paramMap.put("_chgCompany_", session.getAttribute("ssnEnterCd")+" -> "+chgEnterCd);


        //개인 설정
        session.setAttribute("ssnEnterCd", chgEnterCd);
        paramMap.put("chgSabun", session.getAttribute("ssnSabun"));

        //======================================================================================
        // SSN_ENTER_CD = CHG_ENTER_CD로 변경 필요
        //======================================================================================
        //관리자인지 체크
        String ssnAdmin = (String)session.getAttribute("ssnAdmin");
        if( ssnAdmin != null && ssnAdmin.equals( "Y" ) ){

            Map<String,String> chguser = (Map<String, String>) loginService.chgUser(paramMap);

            if (chguser != null && chguser.size() > 0) {

                //그룹설정
                paramMap.put("ssnSabun", chguser.get("ssnSabun"));
                paramMap.put("ssnEnterCd", chguser.get("ssnEnterCd"));
                paramMap.put("ssnLocaleCd",	paramMap.get("localeCd"));
                List<?> athGrpList = loginService.getAuthGrpList(paramMap);
                Map<String, Object> athGrpMap = new HashMap<>();

                Set<String> sessionSet = chguser.keySet();
                Iterator<String> iterator = sessionSet.iterator();
                Log.Debug("┌────────────────── Create Session Start3 ────────────────────────");
                while (iterator.hasNext()) {
                    String key = iterator.next();
                    String value = chguser.get(key);
                    Log.Debug("│ " + key + ":" + value);

                    session.setAttribute(key, value);
                }
                athGrpMap = (Map<String, Object>)athGrpList.get(0);
                sessionSet = athGrpMap.keySet();
                iterator = sessionSet.iterator();
                while (iterator.hasNext()) {
                    String key = iterator.next();
                    String value = String.valueOf( athGrpMap.get(key) );
                    Log.Debug("│ " + key + ":" + value);
                    session.setAttribute(key, value);
                }

                session.setAttribute("theme", session.getAttribute("ssnSkinType")); //차후 DB 에서
                session.setAttribute("wfont", session.getAttribute("ssnFontType")); //차후 DB 에서
                session.setAttribute("maintype", session.getAttribute("ssnMainType")); //차후 DB 에서
                Log.Debug("│ theme:" + session.getAttribute("theme"));
                Log.Debug("│ wfont:" + session.getAttribute("wfont"));
                Log.Debug("│ maintype:" + session.getAttribute("maintype"));
                Log.Debug("│ MaxInactiveInterval:" + session.getMaxInactiveInterval());
                Log.Debug("└────────────────── Create Session End ────────────────────────");

                //session.setAttribute("logIp", request.getRemoteHost());
                session.setAttribute("logIp", StringUtil.getClientIP(request));
                session.setAttribute("logRequestUrl", request.getRequestURL() + "?" + request.getQueryString());
                session.setAttribute("logController", "LoginController");

                /**  로그인 기록 **/
                securityMgrService.insertLogin(paramMap);

                loginService.loginUserLog(paramMap);

                result.put("isUser", "exist");

                //기본 언어 설정 차후 DB에서 조회된 사용자 언어로 변경 되어야 함
                session.setAttribute("language", "kr");
            }else{
                result.put("isUser", "notExist");
            }
        }else{
            result.put("isUser", "notExist");
        }
        Log.Debug("LoginController.chgCompany End");
        Log.DebugEnd();
        return result;
    }

    public String setJwtToken(String enterCd, String sabun) throws GeneralSecurityException, UnsupportedEncodingException, ParseException, JOSEException, JsonProcessingException {
        Map<String, Object> tokenMap = new HashMap<>();
        tokenMap.put("enterCd", enterCd);
        tokenMap.put("sabun", sabun);
        Log.Debug(tokenMap.toString());
        return JweToken.createJWT(tokenMap, 120);
//        return JweToken.createJWT(tokenMap, 60000);
    }
}
