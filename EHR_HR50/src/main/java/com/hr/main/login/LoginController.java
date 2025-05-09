package com.hr.main.login;

import java.security.PrivateKey;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.UUID;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.hr.common.springSession.SpringSessionService;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.MDC;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.hr.common.com.ComService;
import com.hr.common.logger.Log;
import com.hr.common.security.SecurityMgrService;
import com.hr.common.util.DateUtil;
import com.hr.common.util.RSA;
import com.hr.common.util.SessionUtil;
import com.hr.common.util.StringUtil;
import com.hr.main.privacyAgreement.PrivacyAgreementService;
import com.hr.sys.security.userMgr.UserMgrService;


/**
 *  로그인
 *
 * @author ParkMoohun
 *
 */
@Controller
@SuppressWarnings("unchecked")
public class LoginController {

	@Inject
	@Named("LoginService")
	private LoginService loginService;


	@Inject
	@Named("UserMgrService")
	private UserMgrService userMgrService;


	@Inject
	@Named("SecurityMgrService")
	private SecurityMgrService securityMgrService;


	@Inject
	@Named("PrivacyAgreementService")
	private PrivacyAgreementService privacyAgreementService;

	@Inject
	@Named("ComService")
	private	ComService	comService;

	@Autowired
	private SpringSessionService springSessionService;
	//@Autowired
	//private CommonMailController commonMailController;

	@RequestMapping(value="/", method= RequestMethod.GET )
	public String redirect(){
		return "redirect:/Login.do";
	}
	
	@RequestMapping(value="/getRsaKey.do", method=RequestMethod.POST )
	public ModelAndView getRsaKey(HttpSession session) throws Exception {
		RSA rsa = RSA.getEncKey();
		
		ModelAndView mv = new ModelAndView();
	    mv.setViewName("jsonView");
	    String modulus = null;
		String exponent = null;
		
		if (rsa != null) {
			modulus = rsa.getPublicKeyModulus();
			exponent = rsa.getPublicKeyExponent();
			session.setAttribute("RSAModulus", modulus);
			session.setAttribute("RSAExponent", exponent);
			session.setAttribute("_RSA_WEB_Key_", rsa.getPrivateKey());
		} 
		
		mv.addObject("modulus", modulus);
	    mv.addObject("exponent", exponent);
	    
		return mv;
	}

	/**
	 * 메인 로그인 화면
	 *
	 * @param paramMap
	 * @param request
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(value="/Login.do", method=RequestMethod.GET )
	public ModelAndView viewLogin(HttpSession session,
			@RequestParam Map<String, Object> paramMap, HttpServletResponse response, HttpServletRequest request) throws Exception {
		Log.DebugStart();
		paramMap.put("domain",	request.getServerName());
		paramMap.put("gCode",	"multiLang");
		paramMap.put("gNm",		"langYn");

		Log.Debug("paramMap " + paramMap);
		Log.Debug("===========================================================");
		Log.Debug("paramMap : " + paramMap.toString());
		Log.Debug("===========================================================");
		Map<?, ?> map = loginService.getLoadGrobal(paramMap);
		ModelAndView mv = new ModelAndView();

		Log.Debug("Session Chk Start >>>>>");
		String chkSabun =(String)session.getAttribute("ssnSabun");
		Log.Debug("Session Chk end >>>>>"+ chkSabun);

		if (null != chkSabun ) {
			Log.Debug(">>>>> 로그인 페이지로 갈때 남아 있는거  >>>>>"+ chkSabun);
			return new ModelAndView( "redirect:/Main.do");
		}
		//SSO 체크 해서  존재시 .. 여기에서 리다이렉트

		//Cookie newCookie = new Cookie("testCookie", "testCookieValue");
		//newCookie.setMaxAge(24 * 60 * 60);
        //response.addCookie(newCookie);

        Log.Debug("===========================================================");
        Log.Debug("ip : " + StringUtil.getClientIP(request));
        Log.Debug("===========================================================");

		mv.setViewName("main/login/login45");
		mv.addObject("map", map);
		Log.DebugEnd();

		return mv;
	}

	/**
	 * 메인 로그인 화면
	 *
	 * @param paramMap
	 * @param request
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(value="/LoginVue.do", method=RequestMethod.GET )
	public ModelAndView viewLoginVue(HttpSession session,
								  @RequestParam Map<String, Object> paramMap, HttpServletResponse response, HttpServletRequest request) throws Exception {
		Log.DebugStart();
		paramMap.put("domain",	request.getServerName());
		paramMap.put("gCode",	"multiLang");
		paramMap.put("gNm",		"langYn");

		Log.Debug("paramMap " + paramMap);
		Log.Debug("===========================================================");
		Log.Debug("paramMap : " + paramMap.toString());
		Log.Debug("===========================================================");
		Map<?, ?> map = loginService.getLoadGrobal(paramMap);
		ModelAndView mv = new ModelAndView();

		Log.Debug("Session Chk Start >>>>>");
		String chkSabun =(String)session.getAttribute("ssnSabun");
		Log.Debug("Session Chk end >>>>>"+ chkSabun);

		if (null != chkSabun ) {
			Log.Debug(">>>>> 로그인 페이지로 갈때 남아 있는거  >>>>>"+ chkSabun);
			return new ModelAndView( "redirect:/MainVue.do");
//			String url = request.getScheme() + "://" + request.getServerName() + ":3000";
//			mv.setViewName("redirect:" + url);
//			return mv;
		}
		//SSO 체크 해서  존재시 .. 여기에서 리다이렉트

		//Cookie newCookie = new Cookie("testCookie", "testCookieValue");
		//newCookie.setMaxAge(24 * 60 * 60);
		//response.addCookie(newCookie);

		Log.Debug("===========================================================");
		Log.Debug("ip : " + StringUtil.getClientIP(request));
		Log.Debug("===========================================================");

		mv.setViewName("main/login/loginVue");
		mv.addObject("map", map);
		Log.DebugEnd();

		return mv;
	}

	/**
	 * 메인 로그인 체크
	 *
	 * @param paramMap
	 * @param request
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(value="/loginUserCheck.do", method=RequestMethod.POST )
	public ModelAndView loginUserCheck(HttpSession session,
			@RequestParam Map<String, Object> paramMap,
			HttpServletRequest request) throws Exception {
		Log.DebugStart();

		//로그인  페이지에서 생성한 Session 값 삭제 .
		session.removeAttribute("ssnLocaleCd");
		session.removeAttribute("ssnEnterCd");

		Enumeration<String> se = session.getAttributeNames();
		while(se.hasMoreElements()){
			String getse = se.nextElement()+"";
			Log.Debug("@@@@@@@ session : "+getse+" : "+session.getAttribute(getse));
		}

		String uid 	= StringUtil.stringValueOf(paramMap.get("user_id"));
		String pwd 	= StringUtil.stringValueOf(paramMap.get("user_pwd"));
		String lan 	= StringUtil.stringValueOf(paramMap.get("user_lang"));

		PrivateKey privateKey = (PrivateKey) session.getAttribute("_RSA_WEB_Key_");  //로그인전에 세션에 저장된 개인키를 가져온다.
		ModelAndView mv = new ModelAndView();
	    mv.setViewName("jsonView");

		session.removeAttribute("ssnLoginEnterCd");
		Log.Debug("=========================2)+ privateKey="+ privateKey);
		if (privateKey == null) {
			mv.setViewName("jsonView");
			mv.addObject("isUser", "secFail");
			return mv;
		} else {
			try
			{
				/**
				 * 비밀번호 실패 횟수 제한 체크
				 */
				//암호화처리된 사용자계정정보를 복호화 처리한다.
				String _uid = RSA.decryptRsa(privateKey, uid);
				String _pwd = RSA.decryptRsa(privateKey, pwd);
				String _lan = lan;


				//복호화 처리된 계정정보를 map에.
				Log.Debug("=========================)22");

				paramMap.put("link", paramMap.get("user_link"));
				paramMap.put("loginEnterCd", paramMap.get("user_comp"));
				paramMap.put("loginUserId", _uid);
				paramMap.put("loginPassword", _pwd);
				paramMap.put("localeCd", _lan);

				Log.Debug("=========================)2223");

				// 비밀번호 마스킹 처리를 위한 선언
				MDC.put("PWD", _pwd);

				Log.Debug("=========================)1"+ paramMap.toString());
				Map<String,String> loginTryCntMap = (Map<String, String>) loginService.loginTryCnt(paramMap);

				Log.Debug("=========================)");
				Log.Debug(paramMap.toString());
				Log.Debug("=========================)");

				/**
				 *  해당 ID가 존재 하지 않음
				 */
				if(loginTryCntMap.get("idExst").equals("N")){
		            mv.addObject("isUser", "notExist");
		    		Log.DebugEnd();
		    		return mv;

				}
				/**
				 * ID가 잠김
				 */
			    if(loginTryCntMap.get("rockingYn").equals("Y")){
		            mv.addObject("isUser", "rocking");
		    		Log.DebugEnd();
		    		return mv;
			    }

				/**
				 * 로그인 실패 횟수 Over
				 */
			    if(loginTryCntMap.get("loginFailCntYn").equals("Y")){
			        mv.addObject("isUser", "cntOver");
		    		Log.DebugEnd();
		    		return mv;
			    }

				/**
				 * 비밀번호가 틀림
				 */
		        if(loginTryCntMap.get("pswdClct").equals("Y")){
		            int loginFailCnt = Integer.parseInt(StringUtil.stringValueOf(loginTryCntMap.get("loginFailCnt"))); //로그인 실패 횟수
		            paramMap.put("loginFailCnt", loginFailCnt);
		            loginService.saveLoingFailCnt(paramMap);
		            mv.addObject("isUser", "notMatch");
		            mv.addObject("loginFailCntStd", loginTryCntMap.get("loginFailCntStd"));
		            mv.addObject("loginFailCnt", loginFailCnt+1);
		    		Log.DebugEnd();
		    		return mv;
		        }

		  		/**
		  		 * 로그인 사용자 정보 조회
		  		 */
		  		Map<String,String> loginUserMap = (Map<String, String>) loginService.loginUserChk(paramMap);

				Log.Debug("=========================)");
				Log.Debug("로그인 사용자 정보 조회="+ paramMap.toString());
				Log.Debug("=========================)");

		  		/**
		  		 * 사용자 정보가 없음
		  		 */
		  		if (loginUserMap == null || loginUserMap.size() == 0) {
		            mv.addObject("isUser", "noLogin");
		    		Log.DebugEnd();
		    		return mv;
		  		}

		        //파라미터 정보를 임시로 세션에 담아 놓음.
				session.setAttribute("ssnLoginSabun", 	loginUserMap.get("ssnSabun"));
				session.setAttribute("ssnLoginUserId", 	paramMap.get("loginUserId"));
				session.setAttribute("ssnLoginEnterCd", paramMap.get("loginEnterCd"));
				session.setAttribute("ssnLoginPassword",paramMap.get("loginPassword"));
				session.setAttribute("ssnLoginLocaleCd",paramMap.get("localeCd"));
				session.setAttribute("ssnLocaleCd", paramMap.get("localeCd"));
				session.setAttribute("ssnLoginLink", 	paramMap.get("link"));

		  		Map<String,String> systemOptionMap = (Map<String, String>) loginService.systemOption(paramMap);
				Log.Debug("=========================)");
				Log.Debug("정보 ="+ paramMap.toString());
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
				Log.Debug("◆ssnLoginSabun : "+session.getAttribute("ssnLoginSabun"));
				Log.Debug("◆ssnLoginUserId : "+session.getAttribute("ssnLoginUserId"));
				Log.Debug("◆ssnLoginEnterCd : "+session.getAttribute("ssnLoginEnterCd"));
				Log.Debug("◆ssnLoginPassword : "+session.getAttribute("ssnLoginPassword"));
				Log.Debug("◆ssnLoginLocaleCd : "+session.getAttribute("ssnLoginLocaleCd"));
				Log.Debug("◆ssnLoginLink : "+session.getAttribute("ssnLoginLink"));

				//중복로그인 알림 메시지

				String loginSabun = (String)loginUserMap.get("ssnSabun");
				String ssnSecurityYn = (String)session.getAttribute("ssnSecurityYn");
				String ssnSecurityDetail = (String)session.getAttribute("ssnSecurityDetail"); // SPU

				Log.Debug("----------------");
				Log.Debug("ssnSecurityYn="+ ssnSecurityYn);
				Log.Debug("ssnSecurityDetail="+ ssnSecurityDetail);
				Log.Debug("----------------");

				//if( ssnSecurityYn != null && ssnSecurityYn.equals("Y") && ssnSecurityDetail.indexOf("S") > -1  ){  //중복로그인,세션변조 체크 여부
				if(ssnSecurityDetail.indexOf("S") > -1) { //중복로그인,세션변조 체크 여부

					// 회사코드, 사번으로 세션 ID 조회
					Map<String, Object> sessionParamMap = new HashMap<String, Object>();
					sessionParamMap.put("ssnEnterCd", paramMap.get("user_comp"));
					sessionParamMap.put("ssnSabun", loginSabun);
					List<String> existingSessionIds = springSessionService.getSessionIdsByEnterCdSabun(sessionParamMap);

					// 기존 세션이 존재하면 중복 로그인 처리
 					if (existingSessionIds != null && !existingSessionIds.isEmpty()) {
						mv.addObject("loginDup", "Y");
					}
				}
			} catch(Exception e){
				Log.Debug(e.getLocalizedMessage());
				mv.setViewName("jsonView");
				mv.addObject("failRev", e);
				mv.addObject("isUser", "loginFail");
				return mv;
			}
		}

		mv.setViewName("jsonView");
		mv.addObject("isUser", "exist");
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 메인 로그인 회사 조회
	 *
	 * @param paramMap
	 * @param request
	 * @return ModelAndView
	 * @throws Exception
	 */
	//@RequestMapping(params="cmd=getLoginEnterList", method = RequestMethod.POST )
	@RequestMapping(value="/getLoginEnterList.do", method=RequestMethod.POST )
	public ModelAndView getLoginEnterList(
			@RequestParam Map<String, Object> paramMap,
			HttpServletRequest request) throws Exception {
		Log.DebugStart();

		paramMap.put("localeCd",	paramMap.get("localeCd"));

		//paramMap.put("domain",	request.getServerName());
		List<?> result = loginService.getLoginEnterList(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("enterList", result);
		Log.DebugEnd();
		return mv;
	}
	
	/**
	 * 메인 로그인 회사 정보가져오기
	 *
	 * @param paramMap
	 * @param request
	 * @return ModelAndView
	 * @throws Exception
	 */
	
	@RequestMapping(value="/getLoginEnterMap.do", method=RequestMethod.POST )
	public ModelAndView getLoginEnterMap(
			@RequestParam Map<String, Object> paramMap,
			HttpServletRequest request) throws Exception {
		Log.DebugStart();
		
		paramMap.put("localeCd",	paramMap.get("localeCd"));
		Map<?, ?> result = loginService.getLoginEnterMap(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("enterMap", result);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 비밀번호 찾기 팝업
	 *
	 * @param paramMap
	 * @param request
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(value="/PwdFindForm.do", method=RequestMethod.POST )
	public ModelAndView getPwdFind(HttpSession session,
			@RequestParam Map<String, Object> paramMap,
			HttpServletRequest request) throws Exception {
		Log.DebugEnd();
		Map<?,?> map = paramMap;
		ModelAndView mv = new ModelAndView();
		mv.setViewName("main/login/pwdFindForm");
		mv.addObject("map", map);
		return mv;
	}
	
	@RequestMapping(value="/viewPwdFindLayer.do", method=RequestMethod.POST )
	public String viewPwdFindLayer() {
		return "main/login/pwdFindLayer";
	}
	

	/**
	 * 비밀번호 변경 화면
	 *
	 * @param paramMap
	 * @param request
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(value="/PwdChgForm.do", method=RequestMethod.POST )
	public ModelAndView viewPwdChgForm(HttpSession session,
			@RequestParam Map<String, Object> paramMap,
			HttpServletRequest request) throws Exception {

		Log.DebugStart();

		/**
	     * 사용자 정보 체크 여부 : ssnLoginUserId, ssnSabun 값이 없으면 잘못된 접근임.
	     */
	    String ssnLoginUserId = (String)session.getAttribute("ssnLoginUserId");

	    if (ssnLoginUserId == null || ssnLoginUserId.equals("") ) {
	    	Log.Debug("9999==>1");
			return new ModelAndView("redirect:/Info.do?code=999"); //잘못된 접근
  		}
	    
	    if ( session.getAttribute("ssnPwChkCode") == null || "".equals(session.getAttribute("ssnPwChkCode")) ) {
			return new ModelAndView("redirect:/Login.do"); // 로그인 페이지로 이동
	    }
	    
	    String ssnPwChkCode = (String) session.getAttribute("ssnPwChkCode");

		ModelAndView mv = new ModelAndView();
		mv.addObject("chkCode", session.getAttribute("ssnPwChkCode"));
		mv.addObject("rmnDate", session.getAttribute("ssnRmnDate"));
		mv.addObject("ssnPwChkLev", session.getAttribute("ssnPwChkLev"));
		mv.setViewName("main/login/pwdChgForm");

		//임시 세션 값 삭제
		if(!"IPS".equals(ssnPwChkCode)) {
			session.removeAttribute("ssnPwChkCode");
		}
		session.removeAttribute("ssnRmnDate");

		Log.DebugEnd();
		return mv;

	}

	/**
	 * 개인정보보호법동의
	 *
	 * @param paramMap
	 * @param request
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(value="/Privacy.do", method=RequestMethod.POST )
	public ModelAndView getPrivacy(HttpSession session,
			@RequestParam Map<String, Object> paramMap,
			HttpServletRequest request) throws Exception {
		Log.DebugEnd();

		/**
	     * 사용자 정보 체크 여부 : ssnLoginUserId, ssnSabun 값이 없으면 잘못된 접근임.
	     */
	    String ssnLoginUserId = (String)session.getAttribute("ssnLoginUserId");

	    if (ssnLoginUserId == null || ssnLoginUserId.equals("") ) {
	    	Log.Debug("9999==>2");
			return new ModelAndView("redirect:/Info.do?code=999"); //잘못된 접근
  		}
	    if ( session.getAttribute("ssnSabun") != null ) { //이미 로그인 되어 있음.
			return new ModelAndView("redirect:/Main.do"); //잘못된 접근
  		}

		return new ModelAndView("main/login/privacyAgreementForm");
	}

	/**
	 * 비밀번호 찾기
	 */
	@RequestMapping(value="/PwdFindAction.do", method=RequestMethod.POST )
	public ModelAndView userFindPwdInit(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();

		session.removeAttribute("ssnNewPwd");

		paramMap.put("enterCd", paramMap.get("enterCd"));
		paramMap.put("name", 	paramMap.get("name"));
		paramMap.put("sabun", 	paramMap.get("sabun"));
		paramMap.put("phone", 	paramMap.get("loginphone"));
		paramMap.put("email", 	paramMap.get("loginEmail"));
		paramMap.put("type", 	paramMap.get("type"));

		Log.Debug("paramMap.get(type)= "+ paramMap.get("type"));
		String result = "";

		/**
		 * 본인 확인
		 */
		Map<?, ?> findMap = loginService.getLoginPwdFind(paramMap);
		int resultCnt = Integer.parseInt( findMap.get("cnt").toString());
		Log.Debug("cnt=> "+ resultCnt);

		if (resultCnt < 1){
			result = "notMatch";

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
					result = "success";
				}else {
					result = "error";
				}

			}catch(Exception e){
				result = "error";
			}
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("result", 		result);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 메인 로그인 처리, 세션 생성
	 *
	 * @param paramMap
	 * @param request
	 * @return ModelAndView
	 * @throws Exception
	 *
	 * 관리자가 사용자변경, 회사변경 했을 때에도 호출
	 */
	@RequestMapping(value = "/loginUser.do", method = {RequestMethod.GET, RequestMethod.POST})
	public ModelAndView loginUser(HttpSession session,
			@RequestParam Map<String, Object> paramMap, HttpServletResponse response,
			HttpServletRequest request) throws Exception {
		Log.DebugStart();

		Log.Debug("=========================)");
		Log.Debug("loginUser.do 처음 ="+ paramMap.toString());
		Log.Debug("=========================)");

	    /**
	     * 사용자 정보 체크 여부 : ssnLoginUserId, ssnSabun 값이 없으면 잘못된 접근임.
	     */
		String ssnLoginUserId 	= StringUtil.stringValueOf(session.getAttribute("ssnLoginUserId"));
		String ssnAdmin 		= StringUtil.stringValueOf(session.getAttribute("ssnAdminGrpYn")); // 누가 이름 변경함 ..
		String ssnSabun 		= StringUtil.stringValueOf(session.getAttribute("ssnSabun"));

		ssnSabun = ssnSabun.equals("") ?  ssnLoginUserId : ssnSabun;

		String ssnEncodedKey 	= StringUtil.stringValueOf(session.getAttribute("ssnEncodedKey"));
		String ssnSso		 	= StringUtil.stringValueOf(session.getAttribute("ssnSso"));

		boolean bSso = false;

		/* sso 변수 세팅 시작  */

		if(ssnSso.equals("Y")){
			bSso = true;
		}

		Log.Debug(">>>>>>단계101");

		Log.Debug("◆◆ssnLoginUserId : 	"+ssnLoginUserId);
		Log.Debug("◆◆ssnLoginSabun : 	"+session.getAttribute("ssnLoginSabun"));
		Log.Debug("◆◆ssnLoginEnterCd : "+session.getAttribute("ssnLoginEnterCd"));
		Log.Debug("◆◆ssnLoginLocaleCd : "+session.getAttribute("ssnLoginLocaleCd"));
		Log.Debug("◆◆ssnSabun : 		"+ssnSabun);

		paramMap.put("loginSabun", 		session.getAttribute("ssnLoginSabun"));
		paramMap.put("loginUserId", 	session.getAttribute("ssnLoginUserId"));
		paramMap.put("loginEnterCd", 	session.getAttribute("ssnLoginEnterCd"));
		paramMap.put("loginPassword", 	session.getAttribute("ssnLoginPassword"));
		paramMap.put("localeCd", 		session.getAttribute("ssnLoginLocaleCd"));
		paramMap.put("link", 			session.getAttribute("ssnLoginLink"));

		// 비밀번호 마스킹 처리를 위한 선언
		MDC.put("PWD", (String) paramMap.get("loginPassword"));

		Log.Debug(">>>>>>단계1021"+ ssnLoginUserId);
		Log.Debug(">>>>>>단계1022"+ ssnSabun);
		Log.Debug(">>>>>>단계1023"+ paramMap.toString());

		if ( ssnSabun.length() == 0 ) {
			Log.Debug(">>>>>>단계103");
			Log.Debug("9999==>3");
			return new ModelAndView("redirect:/Info.do?code=999"); //잘못된 접근
  		}

	    //if ( session.getAttribute("ssnSabun") != null ) { //이미 로그인 되어 있음.
	    if ( ssnEncodedKey.length() > 0  && ssnSabun.length() > 0 ) { //이미 로그인 되어 있음.
	    	Log.Debug(">>>>>>단계111_4");
	    	//관리자가 회사,사용자 변경 했을 때
	    	String chgSabun = StringUtil.stringValueOf(paramMap.get("chgSabun")); //관리자가 사용자 변경
	    	String chgEnterCd = StringUtil.stringValueOf(paramMap.get("chgEnterCd")); //변경 회사코드
	    	String confirmPwd = StringUtil.stringValueOf(paramMap.get("confirmPwd")); //비밀번호

	    	Log.Debug("◆◆ chgSabun : "+chgSabun + ", ssnAdmin : "+ssnAdmin+ ", chgEnterCd : "+chgEnterCd+ ", confirmPwd : "+confirmPwd);

	    	//관리자가 아니면
	    	if(!"Y".equals(ssnAdmin)){
	    		Log.Debug(">>>>>>단계111_3");
	    		return new ModelAndView("redirect:/Main.do"); //잘못된 접근
	    	}
	    	//사용자 변경
	    	if( !( paramMap.get("chgSabun") == null || chgSabun.equals("") || paramMap.get("confirmPwd") == null || confirmPwd.equals("")) ){
	   		//if( (chgSabun + confirmPwd).length() >0 ){
	    		Log.Debug(">>>>>>단계111_4");
	    		Log.Debug(" ♥ chguser ♥ ");
	    		return chguser(session, paramMap, request);
	    	}
	    	//회사 변경
	    	if( !( paramMap.get("chgEnterCd") == null || chgEnterCd.equals("") || paramMap.get("confirmPwd") == null || confirmPwd.equals("")) ){
	    	//if( (chgEnterCd + confirmPwd).length() > 0 ){
	    		Log.Debug(">>>>>>단계111_5");
	    		Log.Debug(" ♥ chgCompany ♥ ");
	    		return chgCompany(session, paramMap, request);

	    	}

    		return new ModelAndView("redirect:/Main.do"); //잘못된 접근

  		}


	    String ssnPwChkCode = "";
	    String ssnPwChkLev = "";

	    Log.Debug(">>>>>>0");

	    if ( bSso ){
	    	//sso인 경우
	    	ssnPwChkCode = "UCK";
	    	Log.Debug(">>>>>>0_1");

	    }
	    else {



		    /**
		     * 개인정보보호법동의
		     */
		    List<?> pvAgreelist  = new ArrayList<Object>();
			paramMap.put("ssnSabun", session.getAttribute("ssnLoginSabun"));
			paramMap.put("ssnEnterCd", session.getAttribute("ssnLoginEnterCd"));
			pvAgreelist = privacyAgreementService.getPrivacyAgreementMaster(paramMap);
			if( pvAgreelist.size() > 0 ){
				//개인정보보호법동의가 필요함.
				Log.DebugEnd();
				return new ModelAndView("redirect:/Privacy.do");
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

	    Log.Debug(">>>>>>1");

		if( ssnPwChkCode.equals("BLK")  ){
			//로그인 안함.
			Log.Debug(">>>>>>2");
		}else{
			Log.Debug(">>>>>>3");
	  		/**
	  		 * 로그인 사용자 정보 조회
	  		 */

			paramMap.put("strParam","'BASE_LANG'");
			paramMap.put("baseLang",comService.getComRtnStr(paramMap));

	  		Map<String, String> loginUserMap = (Map<String, String>) loginService.loginUser(paramMap);

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
			List<?> athGrpList = loginService.getAuthGrpList(paramMap);
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




			//정상 로그인.
			if( ssnPwChkCode.equals("UCK")  ){

				//임시 세션 값 삭제
				session.removeAttribute("ssnLoginSabun");
				session.removeAttribute("ssnLoginUserId");
				session.removeAttribute("ssnLoginEnterCd");
				session.removeAttribute("ssnLoginPassword");
				session.removeAttribute("ssnLoginLocaleCd");
				session.removeAttribute("ssnLoginLink");

				session.removeAttribute("ssnPwChkCode");
				session.removeAttribute("ssnRmnDate");
				session.removeAttribute("ssnPwChkLev");

				return new ModelAndView("redirect:"+goDoStr);
			} else if( ssnPwChkCode.equals("IPS") ) {

				// 비밀번호가 주민번호 뒷자리와 일치하는 경우 비밀번호 변경 화면으로 이동함.
				return new ModelAndView("redirect:/PwdChgForm.do");

			}
		}

		Log.DebugEnd();
		return new ModelAndView("redirect:/PwdChgForm.do");
	}

	/**
	 * 메인 로그인 처리, 세션 생성
	 *
	 * @param paramMap
	 * @param request
	 * @return ModelAndView
	 * @throws Exception
	 *
	 * 관리자가 사용자변경, 회사변경 했을 때에도 호출
	 */
	@RequestMapping(value="/loginUserVue.do", method=RequestMethod.POST )
	public ModelAndView loginUserVue(HttpSession session,
									 @RequestParam Map<String, Object> paramMap, HttpServletResponse response,
									 HttpServletRequest request) throws Exception {
		Log.DebugStart();

		Log.Debug("=========================)");
		Log.Debug("loginUser.do 처음 ="+ paramMap.toString());
		Log.Debug("=========================)");

		/**
		 * 사용자 정보 체크 여부 : ssnLoginUserId, ssnSabun 값이 없으면 잘못된 접근임.
		 */
		String ssnLoginUserId 	= StringUtil.stringValueOf(session.getAttribute("ssnLoginUserId"));
		String ssnAdmin 		= StringUtil.stringValueOf(session.getAttribute("ssnAdminGrpYn")); // 누가 이름 변경함 ..
		String ssnSabun 		= StringUtil.stringValueOf(session.getAttribute("ssnSabun"));

		ssnSabun = ssnSabun.equals("") ?  ssnLoginUserId : ssnSabun;

		String ssnEncodedKey 	= StringUtil.stringValueOf(session.getAttribute("ssnEncodedKey"));
		String ssnSso		 	= StringUtil.stringValueOf(session.getAttribute("ssnSso"));

		boolean bSso = false;

		/* sso 변수 세팅 시작  */

		if(ssnSso.equals("Y")){
			bSso = true;
		}

		Log.Debug(">>>>>>단계101");

		Log.Debug("◆◆ssnLoginUserId : 	"+ssnLoginUserId);
		Log.Debug("◆◆ssnLoginSabun : 	"+session.getAttribute("ssnLoginSabun"));
		Log.Debug("◆◆ssnLoginEnterCd : "+session.getAttribute("ssnLoginEnterCd"));
		Log.Debug("◆◆ssnLoginLocaleCd : "+session.getAttribute("ssnLoginLocaleCd"));
		Log.Debug("◆◆ssnSabun : 		"+ssnSabun);

		paramMap.put("loginSabun", 		session.getAttribute("ssnLoginSabun"));
		paramMap.put("loginUserId", 	session.getAttribute("ssnLoginUserId"));
		paramMap.put("loginEnterCd", 	session.getAttribute("ssnLoginEnterCd"));
		paramMap.put("loginPassword", 	session.getAttribute("ssnLoginPassword"));
		paramMap.put("localeCd", 		session.getAttribute("ssnLoginLocaleCd"));
		paramMap.put("link", 			session.getAttribute("ssnLoginLink"));

		// 비밀번호 마스킹 처리를 위한 선언
		MDC.put("PWD", (String) paramMap.get("loginPassword"));

		Log.Debug(">>>>>>단계1021"+ ssnLoginUserId);
		Log.Debug(">>>>>>단계1022"+ ssnSabun);
		Log.Debug(">>>>>>단계1023"+ paramMap.toString());

		if ( ssnSabun.length() == 0 ) {
			Log.Debug(">>>>>>단계103");
			Log.Debug("9999==>3");
			return new ModelAndView("redirect:/Info.do?code=999"); //잘못된 접근
		}

		//if ( session.getAttribute("ssnSabun") != null ) { //이미 로그인 되어 있음.
		if ( ssnEncodedKey.length() > 0  && ssnSabun.length() > 0 ) { //이미 로그인 되어 있음.
			Log.Debug(">>>>>>단계111_4");
			//관리자가 회사,사용자 변경 했을 때
			String chgSabun = StringUtil.stringValueOf(paramMap.get("chgSabun")); //관리자가 사용자 변경
			String chgEnterCd = StringUtil.stringValueOf(paramMap.get("chgEnterCd")); //변경 회사코드
			String confirmPwd = StringUtil.stringValueOf(paramMap.get("confirmPwd")); //비밀번호

			Log.Debug("◆◆ chgSabun : "+chgSabun + ", ssnAdmin : "+ssnAdmin+ ", chgEnterCd : "+chgEnterCd+ ", confirmPwd : "+confirmPwd);

			//관리자가 아니면
			if(!"Y".equals(ssnAdmin)){
				Log.Debug(">>>>>>단계111_3");
	    		return new ModelAndView("redirect:/MainVue.do"); //잘못된 접근
//				ModelAndView mv = new ModelAndView();
//				String url = request.getScheme() + "://" + request.getServerName() + ":3000";
//				mv.setViewName("redirect:" + url);
//				return mv;
			}
			//사용자 변경
			if( !( paramMap.get("chgSabun") == null || chgSabun.equals("") || paramMap.get("confirmPwd") == null || confirmPwd.equals("")) ){
				//if( (chgSabun + confirmPwd).length() >0 ){
				Log.Debug(">>>>>>단계111_4");
				Log.Debug(" ♥ chguser ♥ ");
				return chguser(session, paramMap, request);
			}
			//회사 변경
			if( !( paramMap.get("chgEnterCd") == null || chgEnterCd.equals("") || paramMap.get("confirmPwd") == null || confirmPwd.equals("")) ){
				//if( (chgEnterCd + confirmPwd).length() > 0 ){
				Log.Debug(">>>>>>단계111_5");
				Log.Debug(" ♥ chgCompany ♥ ");
				return chgCompany(session, paramMap, request);

			}

    		return new ModelAndView("redirect:/MainVue.do"); //잘못된 접근

//			ModelAndView mv = new ModelAndView();
//			String url = request.getScheme() + "://" + request.getServerName() + ":3000";
//			mv.setViewName("redirect:" + url);
//			return mv;
		}

		String ssnPwChkCode = "";
		String ssnPwChkLev = "";

		Log.Debug(">>>>>>0");

		if ( bSso ){
			//sso인 경우
			ssnPwChkCode = "UCK";
			Log.Debug(">>>>>>0_1");

		}
		else {
			/**
			 * 개인정보보호법동의
			 */
			List<?> pvAgreelist  = new ArrayList<Object>();
			paramMap.put("ssnSabun", session.getAttribute("ssnLoginSabun"));
			paramMap.put("ssnEnterCd", session.getAttribute("ssnLoginEnterCd"));
			pvAgreelist = privacyAgreementService.getPrivacyAgreementMaster(paramMap);
			if( pvAgreelist.size() > 0 ){
				//개인정보보호법동의가 필요함.
				Log.DebugEnd();
				return new ModelAndView("redirect:/Privacy.do");
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

		Log.Debug(">>>>>>1");

		if( ssnPwChkCode.equals("BLK")  ){
			//로그인 안함.
			Log.Debug(">>>>>>2");
		}else{
			Log.Debug(">>>>>>3");

			loginService.login(request, response, session, paramMap);

			//정상 로그인.
			if( ssnPwChkCode.equals("UCK")  ){

				//임시 세션 값 삭제
				session.removeAttribute("ssnLoginSabun");
				session.removeAttribute("ssnLoginUserId");
				session.removeAttribute("ssnLoginEnterCd");
				session.removeAttribute("ssnLoginPassword");
				session.removeAttribute("ssnLoginLocaleCd");
				session.removeAttribute("ssnLoginLink");

				session.removeAttribute("ssnPwChkCode");
				session.removeAttribute("ssnRmnDate");
				session.removeAttribute("ssnPwChkLev");

				ModelAndView mv = new ModelAndView();
				mv.setViewName("redirect:/MainVue.do");
				return mv;
			} else if( ssnPwChkCode.equals("IPS") ) {

				// 비밀번호가 주민번호 뒷자리와 일치하는 경우 비밀번호 변경 화면으로 이동함.
				return new ModelAndView("redirect:/PwdChgForm.do");

			}
		}

		Log.DebugEnd();
		return new ModelAndView("redirect:/PwdChgForm.do");
	}

	/**
	 * 메인 로그인 처리, 세션 생성
	 *
	 * @param paramMap
	 * @param request
	 * @return ModelAndView
	 * @throws Exception
	 */
	//@RequestMapping(value="/chgUser.do", method=RequestMethod.POST ) 사용안함

	public ModelAndView chguser(HttpSession session,
			@RequestParam Map<String, Object> paramMap,
			HttpServletRequest request) throws Exception {
		Log.DebugStart();
		Log.Debug("LoginController.chguser Start");

		ModelAndView mv = new ModelAndView();
		mv.setViewName("main/main/chgUserPopupRst"); //결과값을 보여주는 화면

		PrivateKey privateKey = (PrivateKey) session.getAttribute("_RSA_WEB_Key_");  //로그인전에 세션에 저장된 개인키를 가져온다.
		if( privateKey == null ){
			mv.addObject("isUser", "notExist");
			return mv;
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
    			mv.addObject("isUser", "notMatch");
    			return mv;
    		}
    	}else{
    		//알 수 없는 오류 - null이 나올 수가 없는데...
			mv.addObject("isUser", "notExist");
			return mv;
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
	    		return new ModelAndView("redirect:/Main.do"); //잘못된 접근
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
				paramMap.put("ssnLocaleCd",	session.getAttribute("ssnLocaleCd"));

				paramMap.put("chgSsnSabun", chguser.get("ssnSabun"));
				paramMap.put("chgSsnEnterCd", chguser.get("ssnEnterCd"));
				paramMap.put("chgSsnLocaleCd",	session.getAttribute("ssnLocaleCd"));

				List<?> athGrpList = loginService.getChgUserAuthGrpList(paramMap);
				Map<String, Object> athGrpMap = new HashMap<>();

				Set<String> sessionSet = chguser.keySet();
				Iterator<String> iterator = sessionSet.iterator();
				Log.Debug("┌────────────────── Create Session Start ────────────────────────");
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

				mv.addObject("isUser", "exist");

				//기본 언어 설정 차후 DB에서 조회된 사용자 언어로 변경 되어야 함
				session.setAttribute("language", "kr");
			}else{
				mv.addObject("isUser", "notExist");
			}
		}else{
			mv.addObject("isUser", "notExist");
		}
		Log.DebugEnd();
		return mv;
	}


	/**
	 * 회사 변경
	 * @param paramMap
	 * @param request
	 * @return ModelAndView
	 * @throws Exception
	 */
	//@RequestMapping(value="/chgCompany.do", method=RequestMethod.POST ) //사용안함
	public ModelAndView chgCompany(HttpSession session,
			@RequestParam Map<String, Object> paramMap,
			HttpServletRequest request) throws Exception {

		Log.DebugStart();
		Log.Debug("LoginController.chgCompany Start");

		ModelAndView mv = new ModelAndView();
		mv.setViewName("main/main/chgUserPopupRst"); //결과값을 보여주는 화면

		PrivateKey privateKey = (PrivateKey) session.getAttribute("_RSA_WEB_Key_");  //로그인전에 세션에 저장된 개인키를 가져온다.
		if( privateKey == null ){
			mv.addObject("isUser", "notExist");
			return mv;
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
    			mv.addObject("isUser", "notMatch");
    			return mv;
    		}
    	}else{
    		//알 수 없는 오류 - null이 나올 수가 없는데...
			mv.addObject("isUser", "notExist");
			return mv;
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
				paramMap.put("ssnLocaleCd",	session.getAttribute("ssnLocaleCd"));
				List<?> athGrpList = loginService.getAuthGrpList(paramMap);
				Map<String, Object> athGrpMap = new HashMap<>();

				Set<String> sessionSet = chguser.keySet();
				Iterator<String> iterator = sessionSet.iterator();
				Log.Debug("┌────────────────── Create Session Start ────────────────────────");
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

				mv.addObject("isUser", "exist");

				//기본 언어 설정 차후 DB에서 조회된 사용자 언어로 변경 되어야 함
				session.setAttribute("language", "kr");
			}else{
				mv.addObject("isUser", "notExist");
			}
		}else{
			mv.addObject("isUser", "notExist");
		}
		Log.Debug("LoginController.chgCompany End");
		Log.DebugEnd();
		return mv;
	}

	@RequestMapping(value="/logoutUser.do", method=RequestMethod.GET )
	public ModelAndView logoutUser(HttpServletRequest request) throws Exception {
		Log.DebugStart();
		HttpSession session = request.getSession(false);

		Log.Debug("logout=>>"+StringUtil.stringValueOf(session));
		String sessionStr =StringUtil.stringValueOf(session);
		Log.Debug("logout=>>"+sessionStr.length() + "==>>"+ sessionStr);

		if (session != null) { // 세션이 존재하면
			session.invalidate(); // 세션 무효화 (Spring Session이 DB에서 자동 삭제)
		}

		Log.DebugEnd();

		return new ModelAndView("redirect:/Login.do");
	}


	@RequestMapping(value="/EnablePage.do", method=RequestMethod.POST )
	public ModelAndView checkPwd(HttpSession session, HttpServletRequest request, @RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");

		String loginEnterCd = "";
		String loginUserId = "";


		if( "Y".equals(String.valueOf(session.getAttribute("ssnAdmin"))) ) {

			loginEnterCd = (String) session.getAttribute("ssnAdminEnterCd");
			loginUserId = (String) session.getAttribute("ssnAdminLoginUserId");
		}
		else{
			loginEnterCd = (String) session.getAttribute("ssnEnterCd");
			loginUserId = (String) session.getAttribute("ssnUserId");

		}





		String pwd = (String) paramMap.get("pwd");

		if(loginEnterCd == null || loginUserId == null) {
			session.invalidate();

			mv.setViewName("jsonView");
			mv.addObject("isUser", "sesOut");
			Log.DebugEnd();
			return mv;
		}


		PrivateKey privateKey = (PrivateKey) session.getAttribute("_RSA_WEB_Key_");  //로그인전에 세션에 저장된 개인키를 가져온다.
		if (privateKey == null)
		{
			mv.setViewName("jsonView");
			mv.addObject("isUser", "secFail");
			Log.DebugEnd();
			return mv;
		}

		String loginPassword = "";
		try {
			loginPassword = RSA.decryptRsa(privateKey, pwd);
		}
		catch(Exception e) {
			/*
			Enumeration se = session.getAttributeNames();
			while(se.hasMoreElements()){
				String getse = se.nextElement()+"";
				Log.Debug("##### session : "+getse+" : "+session.getAttribute(getse));
			}
			*/

			Log.Debug(e.getMessage());

		}


		paramMap.put("loginEnterCd", loginEnterCd);
		paramMap.put("loginUserId", loginUserId);
		paramMap.put("loginPassword", loginPassword);
		
		// 비밀번호 마스킹 처리를 위한 선언
		MDC.put("PWD", loginPassword);

		Map<String,String> loginTryCntMap = (Map<String, String>) loginService.loginTryCnt(paramMap);

		Log.Debug("=========================)");
		Log.Debug(paramMap.toString());
		Log.Debug("=========================)");

		if (loginTryCntMap.get("pswdClct").equals("Y")) {
			int loginFailCnt = Integer.parseInt(session.getAttribute("loginFailCnt") == null ? "0" : String.valueOf(session.getAttribute("loginFailCnt"))); // 로그인 실패 횟수
			int loginFailCntStd = Integer.parseInt(loginTryCntMap.get("loginFailCntStd") == null ? "0" : String.valueOf(loginTryCntMap.get("loginFailCntStd"))); // 로그인 실패 횟수
			loginFailCnt++;
			session.setAttribute("loginFailCnt", loginFailCnt);

//			Log.Debug("loginFailCnt >>>>>>>>>>>>>>>>>>>> " + loginFailCnt);
//			Log.Debug("loginFailCntStd >>>>>>>>>>>>>>>>>>>> " + loginFailCntStd);

			if (loginFailCnt >= loginFailCntStd) {
				mv.addObject("isUser", "cntOver");
				Log.DebugEnd();
				return mv;
			}

			mv.addObject("isUser", "notMatch");
			mv.addObject("loginFailCntStd", loginTryCntMap.get("loginFailCntStd"));
			mv.addObject("loginFailCnt", loginFailCnt);
			Log.DebugEnd();
			return mv;
		}

		session.setAttribute("loginFailCnt", 0);
		session.setAttribute("isLockMode", "N");
		mv.addObject("isUser", "exist");
		Log.DebugEnd();
		return mv;
	}


	@RequestMapping(value="/Lock.do", method=RequestMethod.GET )
	public ModelAndView viewLock(HttpSession session,
			@RequestParam Map<String, Object> paramMap, HttpServletResponse response, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView();

		Log.Debug("Session Chk Start Lock ==>>>>");
		String chkSabun =(String)session.getAttribute("ssnSabun");
		Log.Debug("Session Chk end Lock"+ chkSabun);

		if (null == chkSabun ) {
			return new ModelAndView( "redirect:/Login.do");
		}
		session.setAttribute("isLockMode", "Y");

		mv.setViewName("main/login/lock");
		Log.DebugEnd();
		return mv;
	}

	/**
	 * ID, PW를 체크해서 모바일 로그인
	 * @author kwook
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/MobileLogin.do", method=RequestMethod.POST )
	public ModelAndView mobileLogin(@RequestParam Map<String, Object> paramMap) throws Exception {

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");

		Map<String, String> loginTryCntMap = (Map<String, String>) loginService.loginTryCnt(paramMap);

		/**
		 * 해당 ID가 존재 하지 않음
		 */
		if (loginTryCntMap.get("idExst").equals("N")) {
			mv.addObject("isUser", "notExist");
			Log.DebugEnd();
			return mv;

		}
		/**
		 * ID가 잠김
		 */
		if (loginTryCntMap.get("rockingYn").equals("Y")) {
			mv.addObject("isUser", "rocking");
			Log.DebugEnd();
			return mv;
		}

		/**
		 * 로그인 실패 횟수 Over
		 */
		if (loginTryCntMap.get("loginFailCntYn").equals("Y")) {
			mv.addObject("isUser", "cntOver");
			Log.DebugEnd();
			return mv;
		}

		/**
		 * 비밀번호가 틀림
		 */
		if (loginTryCntMap.get("pswdClct").equals("Y")) {

			int loginFailCnt = Integer.parseInt(loginTryCntMap.get("loginFailCnt") == null ? "" : String.valueOf(loginTryCntMap.get("loginFailCnt"))); // 로그인 실패 횟수

			paramMap.put("loginFailCnt", loginFailCnt);
//			loginService.saveLoingFailCnt(paramMap);
			mv.addObject("isUser", "notMatch");
			mv.addObject("loginFailCntStd", loginTryCntMap.get("loginFailCntStd"));
			mv.addObject("loginFailCnt", loginFailCnt + 1);
			Log.DebugEnd();
			return mv;
		}

		Map<String,String> loginUserMap = (Map<String, String>) loginService.loginUser(paramMap);

  		/**
  		 * 사용자 정보가 없음
  		 */
  		if (loginUserMap == null || loginUserMap.size() == 0) {
            mv.addObject("isUser", "noLogin");
            mv.addObject("message", "사용자 없음");
    		Log.DebugEnd();
    		return mv;
  		} else {
  			paramMap.put("ssnEnterCd", loginUserMap.get("ssnEnterCd"));
  			paramMap.put("ssnSabun", loginUserMap.get("ssnSabun"));
  			//
  			List<?> athGrpList = loginService.getAuthGrpList(paramMap);
  			mv.addObject("authCode", athGrpList);
  			mv.addObject("accessToken", UUID.randomUUID());
  		}

		paramMap.put("ssnEnterCd", loginUserMap.get("ssnEnterCd"));
		paramMap.put("ssnSabun", loginUserMap.get("ssnSabun"));
		//
		List<?> athGrpList = loginService.getAuthGrpList(paramMap);
		mv.addObject("authCode", athGrpList);
		mv.addObject("accessToken", UUID.randomUUID());
  		mv.addObject("isUser", "exist");
  		mv.addObject("message", "exist");
  		mv.addObject("userData", loginUserMap);

		return mv;
	}

	/**
	 * 모바일에서 현재 접속한 사용자가 유효한지 확인
	 * @author kwook
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/MobileValidEmp.do", method=RequestMethod.POST )
	public ModelAndView mobileValidEmp(@RequestParam Map<String, Object> paramMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		Map<String,String> chguser = (Map<String, String>) loginService.chgUser(paramMap);

		if (chguser != null && chguser.size() > 0) {
				
			paramMap.put("ssnEnterCd", chguser.get("ssnEnterCd"));
  			paramMap.put("ssnSabun", chguser.get("ssnSabun"));

  			List<?> athGrpList = loginService.getAuthGrpList(paramMap);

  			mv.addObject("authCode", athGrpList);
			mv.addObject("isValid", true);
			mv.addObject("userData", chguser);
		} else {
			mv.addObject("isValid", false);
		}

		return mv;
	}


	//웹취약점 테스트 진행
	@RequestMapping(value="/LTmp.do", method=RequestMethod.POST )
	public ModelAndView tmpLogin(HttpSession session,
			@RequestParam Map<String, Object> paramMap, HttpServletResponse response, HttpServletRequest request) throws Exception {
		RSA rsa = RSA.getEncKey();
		
		if (rsa != null) {
			request.getSession().setAttribute("RSAModulus", rsa.getPublicKeyModulus());
			request.getSession().setAttribute("RSAExponent", rsa.getPublicKeyExponent());
			request.getSession().setAttribute("_RSA_WEB_Key_", rsa.getPrivateKey());
		}

		Log.DebugStart();
		paramMap.put("domain",	request.getServerName());
		paramMap.put("gCode",	"multiLang");
		paramMap.put("gNm",		"langYn");


		Log.Debug("paramMap " + paramMap);

		Map<?, ?> map = loginService.getLoadGrobal(paramMap);
		ModelAndView mv = new ModelAndView();

		Log.Debug("Session Chk Start >>>>>");
		String chkSabun =(String)session.getAttribute("ssnSabun");
		Log.Debug("Session Chk end >>>>>"+ chkSabun);

		if (null != chkSabun ) {
			Log.Debug(">>>>> 로그인 페이지로 갈때 남아 있는거  >>>>>"+ chkSabun);
			return new ModelAndView( "redirect:/Main.do");
		}
		mv.setViewName("main/login/loginTmp");
		mv.addObject("map", map);
		Log.DebugEnd();

		return mv;
	}

	/*
	 * 패스워드 변경 ( 로그인 전 세션 없이 비밀번호 변경 )
	 */
	@RequestMapping(value="/pwdChgForm.do", method=RequestMethod.POST )
	public ModelAndView pwdChgForm(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");

		if( session.getAttribute("ssnLoginSabun") == null && session.getAttribute("ssnSabun") == null ){
			Log.Debug("pwdChg() -- 잘못된 접근 입니다. ssnLoginUserId = null");
			mv.addObject("result", "fail");

			Log.DebugEnd();
			return mv;
		}

		if( session.getAttribute("ssnLoginSabun") != null){
			paramMap.put("ssnEnterCd", session.getAttribute("ssnLoginEnterCd"));
			paramMap.put("ssnSabun", session.getAttribute("ssnLoginSabun"));
		}else{
			paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
			paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));

		}

		try{

			//현재 비밀번호가 맞는지 확인
			List<?> pwdConLst = userMgrService.pwdConfirm(paramMap);
			Map<String, Object> pwdConMap = (Map<String, Object>)(pwdConLst.get(0));



            int pwdConCnt = Integer.parseInt(pwdConMap.get("cnt") == null ? "" : String.valueOf(pwdConMap.get("cnt"))); //현재 비밀번호 확인 여부
            Log.Debug("pwdChgForm() --  pwdConCnt : "+ pwdConCnt);

            if( pwdConCnt < 1 ){

    			mv.addObject("result", "notMatch");
    			Log.DebugEnd();
    			return mv;
            }

			//비밀번호 보안 체크
            Map<String, Object> pwdCheckMap = (Map<String, Object>)userMgrService.pwdCheck(paramMap);
            Log.Debug("pwdChgForm() --  pwdCheckMap : "+ pwdCheckMap);

			if( pwdCheckMap != null ){
				String pwdCheckResult = (String)pwdCheckMap.get("pwdCheck");
				if( pwdCheckResult != null && !pwdCheckResult.equals("") ){

					mv.addObject("result", pwdCheckResult );
	    			Log.DebugEnd();
	    			return mv;
				}
			}

        	//비밀번호 변경
			int result = userMgrService.pwdChfirm(paramMap);
			if (result > 0) {
				//다시 로그인 해야 하므로 세션 값을 지움.
				if( session.getAttribute("ssnLoginUserId") != null){
					session.invalidate();
				}

    			mv.addObject("result", "success");

			}else{

    			mv.addObject("result", "fail");
			}



		}catch(Exception e){
			Log.Debug("pwdChgForm() -- "+ e.getMessage());
			mv.addObject("result", "fail");
		}


		Log.DebugEnd();
		return mv;
	}


}

