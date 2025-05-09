package com.hr.main.login;

import java.io.UnsupportedEncodingException;
import java.security.GeneralSecurityException;
import java.text.ParseException;
import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.hr.api.common.util.JweToken;
import com.hr.common.com.ComService;
import com.hr.common.security.SecurityMgrService;
import com.hr.common.springSession.SpringSessionService;
import com.hr.common.util.DateUtil;
import com.hr.common.util.SessionUtil;
import com.hr.common.util.StringUtil;
import com.nimbusds.jose.JOSEException;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
import com.hr.sys.other.logMgr.LogMgrService;

/**
 * 로그인 서비스
 *
 * @author ParkMoohun
 *
 */
@Service("LoginService")
public class LoginService{

	@Inject
	@Named("Dao")
	private Dao dao;

	@Inject
	@Named("LogMgrService")
	private	LogMgrService logMgrService;

	@Inject
	@Named("SecurityMgrService")
	private SecurityMgrService securityMgrService;

	@Inject
	@Named("ComService")
	private ComService comService;

	@Autowired
	private SpringSessionService springSessionService;

	/**
	 * 회사 조회
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getLoginEnterList(Map<?, ?> paramMap) throws Exception {
		return (List<?>) dao.getList("getLoginEnterList", paramMap);
	}

	/**
	 *  회사 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getLoginEnterMap(Map<?, ?> paramMap) throws Exception {
		return dao.getMap("getLoginEnterMap", paramMap);
	}

	/**
	 * 본인확인  Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getLoginPwdFind(Map<String, Object> paramMap) throws Exception {
		return dao.getMap("getLoginPwdFind", paramMap);
	}

	/**
	 * System 설정값 불러오기
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> systemOption(Map<?, ?> paramMap) throws Exception {
		return (Map<?, ?>) dao.getMap("systemOption", paramMap);
	}

	/**
	 * System 설정값 불러오기(Grobal) 
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getLoadGrobal(Map<?, ?> paramMap) throws Exception {
		return (Map<?, ?>) dao.getMap("getLoadGrobal", paramMap);
	}

	/**
	 * 사용자 조회 - 간단 체크
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> loginUserChk(Map<?, ?> paramMap) throws Exception {
		return (Map<?, ?>) dao.getMap("loginUserChk", paramMap);
	}

	/**
	 * 사용자 조회
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> loginUser(Map<?, ?> paramMap) throws Exception {
		return (Map<?, ?>) dao.getMap("loginUser", paramMap);
	}

	/**
	 * 사용자 조회
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public void login(HttpServletRequest request, HttpServletResponse response, HttpSession session, Map<String, Object> paramMap) throws Exception {
		/**
		 * 로그인 사용자 정보 조회
		 */

		paramMap.put("strParam","'BASE_LANG'");
		paramMap.put("baseLang",comService.getComRtnStr(paramMap));

		Map<String, String> loginUserMap = (Map<String, String>) loginUser(paramMap);

		// 세션 관리자에 세션 정보 저장
		springSessionService.setSession(
			session.getId(),
			loginUserMap.get("ssnEnterCd"),
			loginUserMap.get("ssnSabun")
		);

		//그룹설정
		paramMap.put("ssnSabun", loginUserMap.get("ssnSabun"));
		paramMap.put("ssnEnterCd", loginUserMap.get("ssnEnterCd"));
		paramMap.put("ssnLocaleCd",	session.getAttribute("ssnLocaleCd"));
		List<?> athGrpList = getAuthGrpList(paramMap);
		Map<String, Object> athGrpMap = new HashMap<>();

		Set<String> sessionSet = loginUserMap.keySet();
		Iterator<String> iterator = sessionSet.iterator();
		Log.Debug("┌────────────────── Create Session Start ────────────────────────");
		while (iterator.hasNext()) {
			String key = iterator.next();
			String value = loginUserMap.get(key);
			Log.Debug("│ " + key + ":" + value);

			session.setAttribute(key, value);
		}
		athGrpMap = (Map<String, Object>)athGrpList.get(0);
		sessionSet = athGrpMap.keySet();
		iterator = sessionSet.iterator();

		while (iterator.hasNext()) {
			String key = iterator.next();

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

		//String setTimeout = ((String) session.getAttribute("ssnTimeOut")!=null) ? (String) session.getAttribute("ssnTimeOut"):"30";
		//session.setMaxInactiveInterval(Integer.parseInt(setTimeout)*60); //기본 30분

		//session.setMaxInactiveInterval( 30*60); //기본 30분
		//Log.Debug("ssnTimeOut====>"+ session.getAttribute("ssnTimeOut"));
		//Log.Debug("ssnTimeOut====>"+ ( ((String)session.getAttribute("ssnTimeOut")!=null) ? (String) session.getAttribute("ssnTimeOut"):"5" ));


		session.setAttribute("theme", session.getAttribute("ssnSkinType")); //차후 DB 에서
		session.setAttribute("wfont", session.getAttribute("ssnFontType")); //차후 DB 에서
		session.setAttribute("maintype", session.getAttribute("ssnMainType")); //차후 DB 에서

		session.setAttribute("logingetId", session.getId());//
		//session.setAttribute("ssnLoginTime", DateUtil.getTimeStamp());// 2020.06.23 변경
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
		String ssnSecurityYn = (String)session.getAttribute("ssnSecurityYn");
		String ssnSecurityDetail = (String)session.getAttribute("ssnSecurityDetail"); // SPU
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

		loginUserLog(paramMap);

		//String goDoStr = (null == paramMap.get("link")) ? "/Main.do" : "/Link.do";


		String goDoStr = (0 == (paramMap.get("link") == null ? "" : String.valueOf(paramMap.get("link"))).length()) ? "/Main.do" : "/Link.do?link="+ paramMap.get("link");

		Log.Debug("┌────────────────── Out Link Start ────────────────────────");
		Log.Debug("│ link :" + paramMap.get("link"));
		Log.Debug("│ link len:" + (String.valueOf(paramMap.get("link"))).length());
		Log.Debug("│ link rlen:" + (paramMap.get("link") == null ? "" : String.valueOf(paramMap.get("link"))).length());
		Log.Debug("│ goDoStr :" + goDoStr);
		Log.Debug("│ paramMap :" + paramMap);
		Log.Debug("└────────────────── Out Link End ────────────────────────");

		//로그인 토큰 생성
		Enumeration<String> attributeNames = session.getAttributeNames();
		Map<String, String> sessionData = new HashMap<>();

		while (attributeNames.hasMoreElements()) {
			String attributeName = attributeNames.nextElement();
			Object attributeValue = session.getAttribute(attributeName);
			sessionData.put(attributeName, attributeValue != null ? attributeValue.toString() : null);
		}

		ObjectMapper objectMapper = new ObjectMapper();
		String jsonString = objectMapper.writeValueAsString(sessionData);

		//로그인 토큰 생성
		String token = setJwtToken(loginUserMap.get("ssnEnterCd"), loginUserMap.get("ssnSabun"), jsonString);
		session.setAttribute("token", token);
		paramMap.put("sessionToken", token);
		
		//로그인 토큰 저장
		updateLoginToken(paramMap);

		//비밀번호 실패 횟수 초기화
		saveLoingFailCntInte(paramMap);

		//strLocale 선택 없을경우 대비
		String strLocale = session.getAttribute("ssnLocaleCd")== null ? "" : String.valueOf(session.getAttribute("ssnLocaleCd"));

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
	}

	/**
     * 비밀번호 실패 횟수 제한 체크
     *
     * @param paramMap
     * @return Map
     * @throws Exception
     */
    public Map<?, ?> loginTryCnt(Map<?, ?> paramMap) throws Exception {
        return (Map<?, ?>) dao.getMap("loginTryCnt", paramMap);
    }


    /**
     * 비밀번호 실패횟수 증가 Service
     *
     * @param paramMap
     * @return int
     * @throws Exception
     */
    public int saveLoingFailCnt(Map<?, ?> paramMap) throws Exception {
        return dao.update("saveLoingFailCnt", paramMap);
    }

    /**
     * 비밀번호 실패횟수 초기화
     *
     * @param paramMap
     * @return int
     * @throws Exception
     */


    public int saveLoingFailCntInte(Map<?, ?> paramMap) throws Exception {
        return dao.update("saveLoingFailCntInte", paramMap);
    }

	/**
     *  패스워드 만료 단건 조회 Service
     *
     * @param paramMap
     * @return List
     * @throws Exception
     */
    public Map<?, ?> getChkPwdsMdfDateMap(Map<?, ?> paramMap) throws Exception {
        return dao.getMap("getChkPwdsMdfDateMap", paramMap);
    }

	/**
	 * 권한 조회
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public  List<?> getAuthGrpList(Map<?, ?> paramMap) throws Exception {
		return (List<?>) dao.getList("getAuthGrpList", paramMap);
	}

	/**
	 * 권한 조회 (사용자변경용)
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public List<?> getChgUserAuthGrpList(Map<?, ?> paramMap) throws Exception {
		return (List<?>) dao.getList("getChgUserAuthGrpList", paramMap);
	}
	
	/**
	 * 토큰 저장
	 *
	 * @param paramMap
	 * @throws Exception
	 */
	public void updateLoginToken(Map<String, Object> paramMap) throws Exception {
		Log.Debug();
		paramMap.put("jsessionid", SessionUtil.getRequestAttribute("logingetId"));
		dao.update("updateLoginToken", paramMap);
	}
	/**
	 * 로그인 로그 (성공)
	 *
	 * @param paramMap
	 * @throws Exception
	 */
	public void loginUserLog(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Log.Debug("=========================)");
		Log.Debug("Service  ="+ paramMap.toString());
		Log.Debug("=========================)");
		logMgrService.insertLog("success", "로그인", paramMap);
	}

	/**
	 * 사용자 변경시 TOKEN 조회
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> chUserToken(Map<?, ?> paramMap) throws Exception {
		return (Map<?, ?>) dao.getMap("chUserToken", paramMap);
	}

	/**
	 * 사용자 조회
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> chgUser(Map<?, ?> paramMap) throws Exception {
		return (Map<?, ?>) dao.getMap("chgUser", paramMap);
	}

	/**
	 * 패스워드 확인
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getPwdConfirm(Map<?, ?> paramMap) throws Exception {
		return (Map<?, ?>) dao.getMap("getPwdConfirm", paramMap);
	}

	public String setJwtToken(String enterCd, String sabun) throws GeneralSecurityException, UnsupportedEncodingException, ParseException, JOSEException, JsonProcessingException {
		Map<String, Object> tokenMap = new HashMap<>();
		tokenMap.put("enterCd", enterCd);
		tokenMap.put("sabun", sabun);
		Log.Debug(tokenMap.toString());
		return JweToken.createJWT(tokenMap, 120);
//        return JweToken.createJWT(tokenMap, 60000);
	}

	public String setJwtToken(String enterCd, String sabun, String s) throws GeneralSecurityException, UnsupportedEncodingException, ParseException, JOSEException, JsonProcessingException {
		Map<String, Object> tokenMap = new HashMap<>();
		tokenMap.put("enterCd", enterCd);
		tokenMap.put("sabun", sabun);
		tokenMap.put("s", s);
		Log.Debug(tokenMap.toString());
		return JweToken.createJWT(tokenMap, 120);
//        return JweToken.createJWT(tokenMap, 60000);
	}
}