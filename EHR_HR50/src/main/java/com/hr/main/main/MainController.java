package com.hr.main.main;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.security.GeneralSecurityException;
import java.text.ParseException;
import java.util.*;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.gson.Gson;
import com.hr.api.common.util.JweToken;
import com.hr.common.security.SecurityMgrService;
import com.hr.common.util.CryptoUtil;
import com.nimbusds.jose.JOSEException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.servlet.ModelAndView;

import com.hr.common.logger.Log;
import com.hr.main.login.LoginService;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

/**
 * 메인 화면(Main)
 *
 * @author inchuli
 *
 */
@Controller
public class MainController {

	@Inject
	@Named("MainService")
	private MainService mainService;

	/*LoginService  */
	@Inject
	@Named("LoginService")
	private LoginService loginService;

	@Autowired
	private SecurityMgrService securityMgrService;

	@Value("${vue.front.baseUrl}")
	String frontUrl;

	/**
	 * Sub 화면
	 *
	 * @param paramMap
	 * @return String
	 * @throws Exception
	 */
//	@RequestMapping(params="cmd=viewSub", method = {RequestMethod.POST, RequestMethod.GET} )
	@RequestMapping(value = "/OldMain.do", method = RequestMethod.GET)
	public ModelAndView OldMain(
			HttpSession session,
			@RequestParam Map<String, Object> paramMap  ) throws Exception {
		Log.DebugStart();

		Log.Debug("ssnEnterCd : "+session.getAttribute("ssnEnterCd"));

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnLocaleCd",	session.getAttribute("ssnLocaleCd"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));
		paramMap.put("ssnGrpCd", session.getAttribute("ssnGrpCd"));
		paramMap.put("ssnEncodedKey", session.getAttribute("ssnEncodedKey"));


		List<?> mainMajorMenuList = null;
		Map<?, ?> getMainMajorMenuListCount2021 = null;
		List<?> getMainTFList = null;
		List<?> getMainMFList = null;
		List<?> getMainBFList = null;
		List<?> getHumanResourcesList = null;
		List<?> getNoticeMainList = null;
		List<?> getFaqMainList = null;
		Map<?, ?> getAppCountMap  = new HashMap<String, Object>();
		Map<?, ?> getAprCountMap  = new HashMap<String, Object>();
		Map<?, ?> getPayYmMap            = new HashMap<String, Object>();
		Map<?, ?> getVacationUsedMap     = new HashMap<String, Object>();
		Map<?, ?> getVacationSmmrUsedMap = new HashMap<String, Object>();
		Map<?, ?> getEduLrngTmMap        = new HashMap<String, Object>();

		ModelAndView mv = new ModelAndView();
		mv.setViewName("main/main/main5");

		if(session.getAttribute("ssnGrpCd").equals("99")) {
			// 임직원 공통 권한인 경우, maine_ss로 forward
			mv.setViewName("main/main/main_ess");
		} else if(session.getAttribute("ssnGrpCd").equals("11")) {
			// 대표이사 권한인 경우, main_ess_ceo로 forward
			mv.setViewName("main/main/main_ess_ceo");
		} else if(session.getAttribute("ssnGrpCd").equals("30")) {
			// 조직장 권한인 경우, main_ess_chief로 forward
			mv.setViewName("main/main/main_ess_chief");
		}

		//메인타입  : 메인바형(M) 위젯형(W)
		//String maintype = String.valueOf(session.getAttribute("maintype"));
		String maintype = "W";

		try {
			mainMajorMenuList             = mainService.getMainMajorMenuList(paramMap); // 좌측메뉴리스트
			getMainMajorMenuListCount2021 = mainService.getMainMajorMenuListCount2021(paramMap);// mainMenuCd 20 21 count
			// 메뉴바형인 경우 실행
			if( maintype == null || "".equals(maintype) || "M".equals(maintype) ) {
				getMainTFList                 = mainService.getMainTFList(paramMap);        // 3가지 main 박스 큰메뉴
				getMainMFList                 = mainService.getMainMFList(paramMap);        // 3가지 main 박스 큰메뉴
				getMainBFList                 = mainService.getMainBFList(paramMap);        // 3가지 main 박스 큰메뉴
				getHumanResourcesList         = mainService.getHumanResourcesList(paramMap);// 인사담당자조회
				getNoticeMainList             = mainService.getNoticeMainList(paramMap);    // 공지사항
				getFaqMainList                = mainService.getFaqMainList(paramMap);       // 자주사용하는질문
				getAppCountMap                = mainService.getAppCountMap(paramMap);       // 신청건수
				getAprCountMap                = mainService.getAprCountMap(paramMap);       // 결재건수
				getPayYmMap                   = mainService.getPayYmMap(paramMap);                   // 급여최신년월

				getVacationUsedMap            = mainService.getVacationUsedMap(paramMap);            // 휴가사용실적
				getVacationSmmrUsedMap        = mainService.getVacationSmmrUsedMap(paramMap);        // 하계휴가사용실적
				getEduLrngTmMap               = mainService.getEduLrngTmMap(paramMap);               // 학습시간
			}
		}catch(Exception e) {
			return mv;
		}

		mv.addObject("mainMajorMenuList",mainMajorMenuList);
		mv.addObject("getMainMajorMenuListCount2021",getMainMajorMenuListCount2021);
		mv.addObject("getMainTFList",getMainTFList);
		mv.addObject("getMainMFList",getMainMFList);
		mv.addObject("getMainBFList",getMainBFList);
		mv.addObject("getHumanResourcesList",getHumanResourcesList);
		mv.addObject("getNoticeMainList",getNoticeMainList);
		mv.addObject("getFaqMainList",getFaqMainList);
		mv.addObject("getAppCountMap",getAppCountMap);
		mv.addObject("getAprCountMap",getAprCountMap);
		mv.addObject("getPayYmMap",getPayYmMap);
		mv.addObject("getVacationUsedMap",getVacationUsedMap);
		mv.addObject("getVacationSmmrUsedMap",getVacationSmmrUsedMap);
		mv.addObject("getEduLrngTmMap",getEduLrngTmMap);
		return mv;
	}

	/**
	 * Vue Main 이동
	 * @return
	 */
	@RequestMapping(value="/Main.do", method = RequestMethod.GET)
	public ModelAndView viewMain(HttpSession session) {
		Log.DebugStart();
		ModelAndView mv = new ModelAndView();
		mv.setViewName("main/main/main");
		return mv;
	}

	@RequestMapping(value="/RedirectVue.do", method=RequestMethod.GET )
	public void redirectVue(HttpSession session, HttpServletResponse response) throws Exception {
		String token = "";
		String url = frontUrl + "/vue-app/vueMain";

		// 메인위젯에서 사용할 세션 목록
		String[] sessionKeys = {
			"ssnEnterCd", "ssnSabun", "ssnName", "ssnGrpCd", "ssnGrpNm",
			"ssnAdminYn", "ssnAdminEnterCd", "ssnAdminSabun", "ssnAdminLoginUserId",
			"ssnAdminName", "ssnLocaleCd", "ssnEncodedKey", "ssnJikweeNm",
			"ssnOrgCd", "ssnOrgNm", "theme"
		};

		Map<String, String> sessionData = new HashMap<>();
		for (String key : sessionKeys) {
			sessionData.put(key, session.getAttribute(key).toString());
		}

		ObjectMapper objectMapper = new ObjectMapper();
		String jsonString = objectMapper.writeValueAsString(sessionData);

		// 토큰 생성
		token = setJwtToken(sessionData.get("ssnEnterCd"), sessionData.get("ssnSabun"), jsonString);

		session.setAttribute("token", token);

		// 토큰 저장
		Map<String, Object> paramMap = new HashMap<>();
		paramMap.put("sessionToken", token);

		loginService.updateLoginToken(paramMap);

		Log.Debug("===== CREATE TOKEN =====");
		Log.Debug(token);

		response.sendRedirect(url + "?token=" + token);
	}

	private String setJwtToken(String enterCd, String sabun, String s) throws GeneralSecurityException, UnsupportedEncodingException, ParseException, JOSEException, JsonProcessingException {
		Map<String, Object> tokenMap = new HashMap<>();
		tokenMap.put("enterCd", enterCd);
		tokenMap.put("sabun", sabun);
		tokenMap.put("s", s);
		Log.Debug(tokenMap.toString());
		return JweToken.createJWT(tokenMap, 120);
	}

	/**
	 * 메뉴 목록 레이어 팝업
	 * @return
	 */
	@RequestMapping(value="/MenuListLayer.do", method=RequestMethod.POST )
	public String viewMenuListLayer() {
		return "main/main/menuListLayer";
	}


	/*	@RequestMapping(value="/Main.do", method=RequestMethod.POST )
	public String viewSub(
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return "main/main/main";
	}
*/	//modifyCode : 20170329(yukpan) - 다국어/개발자모드
	@RequestMapping(value="/DevMode.do", method=RequestMethod.POST )
	public ModelAndView viewSub2(
			HttpSession session,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		session.setAttribute("devMode", paramMap.get("devModeVal"));

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		Log.DebugEnd();
		return mv;
	}

	/**
	 * DevModeUrl 표기 여부를 컨트롤 할 Checkbox의 체크 상태 값을 세션에 저장
	 * 
	 * @param session
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/SetSessionChkDevModeUrl.do", method=RequestMethod.POST )
	public ModelAndView setSessionChkDevModeUrl(
			HttpSession session,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		session.setAttribute("chkDevModeUrl", paramMap.get("chkDevModeUrl"));
		
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 대분류 메뉴 조회
	 *
	 * @param session
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(value="/getMainMajorMenuList.do", method=RequestMethod.POST )
	public ModelAndView getSubMajorMenuList(
			HttpSession session,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnLocaleCd",	session.getAttribute("ssnLocaleCd"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));
		paramMap.put("ssnGrpCd", session.getAttribute("ssnGrpCd"));
		paramMap.put("ssnEncodedKey", session.getAttribute("ssnEncodedKey"));

		List<?> result = mainService.getMainMajorMenuList(paramMap);

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("result", result);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 대분류 메뉴 조회
	 *
	 * @param session
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(value="/getMainMajorMenuEncryptList.do", method=RequestMethod.POST )
	public ModelAndView getMainMajorMenuEncryptList(
			HttpSession session,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnLocaleCd",	session.getAttribute("ssnLocaleCd"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));
		paramMap.put("ssnGrpCd", session.getAttribute("ssnGrpCd"));
		paramMap.put("ssnEncodedKey", session.getAttribute("ssnEncodedKey"));

		List<Map<String, Object>> result = (List<Map<String, Object>>) mainService.getMainMajorMenuList(paramMap);

		// List to json 객체 생성
//		Gson gson = new Gson();
//		String jsonList = gson.toJson(result);

		// array to json 객체생성
		ArrayList<String> encryptList = new ArrayList<>();
		for(Map<String, Object> mp : result) {
			encryptList.add(mp.get("mainMenuCd").toString());
		}
		Gson gson = new Gson();
		String jsonList = gson.toJson(encryptList);

		String encryptKey = securityMgrService.getEncryptKey(session.getAttribute("ssnEnterCd").toString());
		Map encrypt = CryptoUtil.encryptCbc(encryptKey, jsonList);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("result", encrypt);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 메인 > 비밀번호 변경 레이어
	 * @param session
	 * @param params
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/ChangePw.do", method=RequestMethod.POST )
	public ModelAndView viewWorkdayApp(HttpSession session
			, @RequestParam Map<String, Object> params
			, HttpServletRequest request) throws Exception {

		ModelAndView mv = new ModelAndView();
		mv.setViewName("main/main/chgPwLayer");

		return mv;
	}


}