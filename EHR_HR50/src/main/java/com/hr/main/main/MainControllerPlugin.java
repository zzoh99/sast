package com.hr.main.main;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.hr.common.com.ComController;
import com.hr.common.exception.HrException;
import com.hr.common.logger.Log;
import com.hr.common.security.SecurityMgrService;
import com.hr.common.util.RSA;
import com.hr.common.util.StringUtil;
import com.hr.main.login.LoginService;
import com.hr.sys.system.processMap.ProcessMapService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.ResourceUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.net.InetAddress;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 메인 화면(Main)
 *
 * @author inchuli
 *
 */
@Controller
@SuppressWarnings("unchecked")
public class MainControllerPlugin extends ComController {

	@Inject
	@Named("MainService")
	private MainService mainService;

	/*LoginService  */
	@Inject
	@Named("LoginService")
	private LoginService loginService;


	@Inject
	@Named("SecurityMgrService")
	private SecurityMgrService securityMgrService;


	@Autowired
	private ProcessMapService processMapService;

	/**
	 * 개인 권한 리스트 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */

	@RequestMapping(value="/getCollectAuthGroupList.do", method=RequestMethod.POST )
	public ModelAndView getCollectAuthGroupList(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		paramMap.put("ssnEncodedKey", 	session.getAttribute("ssnEncodedKey"));

		List<?> result = loginService.getAuthGrpList(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("result", result);
		Log.DebugEnd();
		return mv;
	}


	@RequestMapping(value="/ChangeSession.do", method=RequestMethod.POST )
	public ModelAndView setChangeGrpCd(
			HttpSession session,
			@RequestParam Map<String, Object> paramMap ) throws Exception {


		paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));


		Map<String, Object> urlParam = new HashMap<String, Object>();
		String surl =paramMap.get("rurl").toString();
		String skey = session.getAttribute("ssnEncodedKey").toString();

		String subGrpCd = null;
		String subGrpNm = null;
		urlParam = (Map<String, Object>) securityMgrService.getDecryptUrl( surl, skey  );

		subGrpCd = urlParam.get("subGrpCd").toString();
		subGrpNm = urlParam.get("subGrpNm").toString();


		paramMap.put("subGrpCd", 	subGrpCd);

		Log.Debug("urlParam==>"+urlParam);
		Log.Debug("surl==>"+surl);
		Log.Debug("skey==>"+skey);

		Log.Debug("subGrpNm==>"+subGrpCd);
		Log.Debug("subGrpNm==>"+subGrpNm);



		Map<?, ?> map = mainService.getSelectMap_TSYS313(paramMap);

		String rs = "";
		if( map != null ){
			session.removeAttribute("ssnGrpCd"); 		session.setAttribute("ssnGrpCd", subGrpCd);
			session.removeAttribute("ssnGrpNm"); 		session.setAttribute("ssnGrpNm", subGrpNm);
			session.removeAttribute("ssnDataRwType"); 	session.setAttribute("ssnDataRwType", map.get("dataRwType"));
			session.removeAttribute("ssnSearchType"); 	session.setAttribute("ssnSearchType", map.get("searchType"));

			session.removeAttribute("ssnErrorAccYn"); 	session.setAttribute("ssnErrorAccYn", map.get("errorAccYn"));
			session.removeAttribute("ssnErrorAdminYn"); 	session.setAttribute("ssnErrorAdminYn", map.get("errorAdminYn"));
			
			session.removeAttribute("ssnAdminYn"); 		session.setAttribute("ssnAdminYn", map.get("adminYn"));
			session.removeAttribute("ssnEnterAllYn"); 	session.setAttribute("ssnEnterAllYn", map.get("enterAllYn"));
			session.removeAttribute("ssnPreSrchYn"); 	session.setAttribute("ssnPreSrchYn", map.get("preSrchYn"));
			session.removeAttribute("ssnRetSrchYn"); 	session.setAttribute("ssnRetSrchYn", map.get("retSrchYn"));
			session.removeAttribute("ssnResSrchYn"); 	session.setAttribute("ssnResSrchYn", map.get("resSrchYn"));

			rs = "yes";
		}else{

			rs = "no";
		}

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("success", rs);
		Log.Debug("MainController.setChangeGrpCd >>> "+session.getAttribute("ssnGrpCdg"));
		return mv;
		//return "main/main/main";
	}

	/**
	 * 개인 권한 리스트 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
/*  MainControllerPlugin 이동
	@RequestMapping(value="/getCollectAuthGroupList.do", method=RequestMethod.POST )
	public ModelAndView getCollectAuthGroupList(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.Debug("MainController.getCollectAuthGroupList Start");
		paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		List<?> result = loginService.getAuthGrpList(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("result", result);
		Log.Debug("MainController.getCollectAuthGroupList End");
		return mv;
	}
*/
	/*
	 * Session 변경
	 */
/*
	@RequestMapping(params="cmd=viewAthGrpMenuMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewAthGrpMenuMgr() throws Exception {
		return "sys/security/athGrpMenuMgr/athGrpMenuMgr";
	}
*/
/*
	MainControllerPlugin 이동
	@RequestMapping(value="/ChangeSession.do", method=RequestMethod.POST )
	public ModelAndView setChangeGrpCd(
			HttpSession session,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		session.removeAttribute("ssnGrpCd"); 		session.setAttribute("ssnGrpCd", paramMap.get("subGrpCd"));
		session.removeAttribute("ssnGrpNm"); 		session.setAttribute("ssnGrpNm", paramMap.get("subGrpNm"));
		session.removeAttribute("ssnDataRwType"); 	session.setAttribute("ssnDataRwType", paramMap.get("subDataRwType"));
		session.removeAttribute("ssnSearchType"); 	session.setAttribute("ssnSearchType", paramMap.get("subSearchType"));

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("success", "yes");
		Log.Debug("MainController.setChangeGrpCd >>> "+session.getAttribute("ssnGrpCdg"));
		return mv;
		//return "main/main/main";
	}
*/
	/**
	 * 개인 신청 결재 경로 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(value="/saveWidget.do", method=RequestMethod.POST )
	public ModelAndView saveWidget(HttpSession session,
			HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		String ssnEnterCd = session.getAttribute("ssnEnterCd").toString();
		String ssnSabun   = session.getAttribute("ssnSabun").toString();
		String ssnGrpCd   = session.getAttribute("ssnGrpCd").toString();

		paramMap.put("ssnEnterCd", ssnEnterCd);
		paramMap.put("ssnSabun",   ssnSabun);
		paramMap.put("ssnGrpCd",   ssnGrpCd);

		String sWidgetType = paramMap.get("widgetType").toString();
		String widgetIds[] = null;

		widgetIds = paramMap.get("widgetIds") != null && !"".equals(paramMap.get("widgetIds")) ? ( (String)paramMap.get("widgetIds")).split(",") : null;

		List<Map<String, Object>> parserList = new ArrayList<>();
		Map<String, Object> parserMap = null;

		if ( widgetIds != null && !"".equals(widgetIds)){

			if ( widgetIds.length > 0 ){

				for ( int i=0; i< widgetIds.length; i++ ){

					String[] val = widgetIds[i].split("\\|");

					parserMap = new HashMap<>();
					Log.Debug(val[1]+"_"+(i+1) );
					parserMap.put("tabId", val[0]);
					parserMap.put("seq", val[1]);
					parserList.add(parserMap);
				}
			}
		}

		paramMap.put("widgetType", sWidgetType);
		paramMap.put("insertRows",parserList);
		String message = "";
		int cnt = 0;
		try{ cnt = mainService.saveWidget(paramMap);
			if (cnt > 0) {
				message="저장되었습니다.";

				// 저장 완료 후 widget type session 처리
				session.removeAttribute("ssnWidgetType");
				session.setAttribute("ssnWidgetType", sWidgetType);
			} else { message="저장된 내용이 없습니다."; }
		}catch(Exception e){ cnt=-1; message="저장 실패하였습니다."; }
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("cnt", cnt);
		mv.addObject("Message", message);
		Log.DebugEnd();
		return mv;
	}



	/**
	 *  Schedule Day Map
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(value="/getScheduleDay.do", method=RequestMethod.POST )
	public ModelAndView getScheduleDay(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));
		paramMap.put("ssnAdminGrpYn",session.getAttribute("ssnAdminGrpYn"));
		paramMap.put("ssnOrgCd",session.getAttribute("ssnOrgCd"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list =  mainService.tsys007SelectScheduleMap(paramMap);
		}catch(Exception e){
			Message="위젯2를 불러 오지 못했습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		Log.Debug("OrgAppmtMgrController.getOrgAppmtMgrOrgList End");
		return mv;

	}


	/**
	 *  Schedule Day Calendar Map
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(value="/getMainCalendarMap.do", method=RequestMethod.POST )
	public ModelAndView getMainCalendarMap(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));
		paramMap.put("ssnAdminGrpYn",session.getAttribute("ssnAdminGrpYn"));
		paramMap.put("ssnOrgCd",session.getAttribute("ssnOrgCd"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list =  mainService.getMainCalendarMap(paramMap);
		}catch(Exception e){
			Message="위젯2를 불러 오지 못했습니다."+ e.toString();
		}

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		//mv.addObject("list1", list1);
		mv.addObject("list", list);
		//mv.addObject("list3", list3);
		mv.addObject("Message", Message);
		Log.Debug("MainController.getMainCalendarMap End");
		return mv;

	}

	/**
	 *  Schedule Day Calendar Map
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(value="/getMainCalendarMap2.do", method=RequestMethod.POST )
	public ModelAndView getMainCalendarMap2(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));
		
		Log.Debug("MAIN CALENDAR MAP2 PARAM: {}", paramMap);

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list =  mainService.getMainCalendarMap2(paramMap);
		}catch(Exception e){
			Message="위젯2를 불러 오지 못했습니다."+ e.toString();
		}

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("list", list);
		mv.addObject("Message", Message);
		Log.Debug("MainController.getMainCalendarMap End");
		return mv;
	}
	
	/**
	 *  Schedule Day Calendar Map
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(value="/getMainCalendarMap3.do", method=RequestMethod.POST )
	public ModelAndView getMainCalendarMap3(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));
		
		Log.Debug("MAIN CALENDAR MAP3 PARAM: {}", paramMap);

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list =  mainService.getMainCalendarMap3(paramMap);
		}catch(Exception e){
			Message="위젯2를 불러 오지 못했습니다."+ e.toString();
		}

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("list", list);
		mv.addObject("Message", Message);
		Log.Debug("MainController.getMainCalendarMap End");
		return mv;

	}


	/**
	 * 암호화 리턴값
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(value="/getDecryp.do", method=RequestMethod.POST )
	public ModelAndView getDecryp(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {

		//////////
		Map<String, Object> urlParam = new HashMap<String, Object>();
		String encryptStr =paramMap.get("murl").toString();
		String skey = session.getAttribute("ssnEncodedKey").toString();

		urlParam = (Map<String, Object>) securityMgrService.getDecryptUrl( encryptStr, skey  );


		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("result", urlParam);
		Log.DebugEnd();
		return mv;
	}


	/**
	 * Sub 화면
	 *
	 * @param paramMap
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(value="/chgUesrPopup.do", method=RequestMethod.POST )
	public String chgUesrPopup( HttpServletRequest request, @RequestParam Map<String, Object> paramMap, HttpSession session, HttpServletResponse response ) throws Exception {
		Log.Debug("MainController.chgUesr");

		//비밀번호 암호화
/*		RSA rsa = RSA.getEncKey();
		request.setAttribute("RSAModulus", rsa.getPublicKeyModulus());
		request.setAttribute("RSAExponent", rsa.getPublicKeyExponent());
		request.getSession().setAttribute("_RSA_WEB_Key_", rsa.getPrivateKey());*/

	  	//관리자 기능 사용 여부
		String ssnAdmin = (String)session.getAttribute("ssnAdmin");
		String ssnAdminFncYn = (String)session.getAttribute("ssnAdminFncYn");
	  	if( ssnAdmin == null || ssnAdminFncYn == null || !ssnAdmin.equals("Y" )|| !ssnAdminFncYn.equals("Y" )) {
	  		//권한 없음 잘못된 접근
	  		response.sendRedirect("/Info.do?code=994"); //잘못된 접근
	  		return "";
	  	}else{
	  		return "main/main/chgUserPopup";
	  	}
	}

	/**
	 * Sub 화면 - 사용자 변경 로그인 Layer
	 *
	 * @param paramMap
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(value="/chgUserLayer.do", method=RequestMethod.POST )
	public String chgUserLayer( HttpServletRequest request, @RequestParam Map<String, Object> paramMap, HttpSession session, HttpServletResponse response ) throws Exception {
		Log.Debug("MainController.chgUserLayer");

		//비밀번호 암호화
/*		RSA rsa = RSA.getEncKey();
		request.setAttribute("RSAModulus", rsa.getPublicKeyModulus());
		request.setAttribute("RSAExponent", rsa.getPublicKeyExponent());
		request.getSession().setAttribute("_RSA_WEB_Key_", rsa.getPrivateKey());*/

		//관리자 기능 사용 여부
		String ssnAdmin = (String)session.getAttribute("ssnAdmin");
		String ssnAdminFncYn = (String)session.getAttribute("ssnAdminFncYn");
		if( ssnAdmin == null || ssnAdminFncYn == null || !ssnAdmin.equals("Y" )|| !ssnAdminFncYn.equals("Y" )) {
			//권한 없음 잘못된 접근
			response.sendRedirect("/Info.do?code=994"); //잘못된 접근
			return "";
		}else{
			return "main/main/chgUserLayer";
		}
	}

	/**
	 * Sub 화면
	 *
	 * @param paramMap
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(value="/chgCompanyPopup.do", method=RequestMethod.POST )
	public ModelAndView chgCompanyPopup(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.Debug("MainController.chgCompanyPopup");

		//비밀번호 암호화
		RSA rsa = RSA.getEncKey();
		if (rsa != null) {
			request.setAttribute("RSAModulus", rsa.getPublicKeyModulus());
			request.setAttribute("RSAExponent", rsa.getPublicKeyExponent());
			request.getSession().setAttribute("_RSA_WEB_Key_", rsa.getPrivateKey());
		}

		ModelAndView mv = new ModelAndView();
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try {
			list =  mainService.tsys399SelectList(paramMap);
		} catch(Exception e){
			Message="회사 리스트를 조회 하지 못하였습니다!";
		}
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		mv.setViewName("main/main/chgCompanyPopup");
		return mv;
	}

	/**
	 * 법인전환 레이어
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/chgCompanyLayer.do", method=RequestMethod.POST )
	public ModelAndView chgCompanyLayer(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.Debug("MainController.chgCompanyLayer");

		//비밀번호 암호화
		RSA rsa = RSA.getEncKey();
		if (rsa != null) {
			request.setAttribute("RSAModulus", rsa.getPublicKeyModulus());
			request.setAttribute("RSAExponent", rsa.getPublicKeyExponent());
			request.getSession().setAttribute("_RSA_WEB_Key_", rsa.getPrivateKey());
		}

		ModelAndView mv = new ModelAndView();
		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list =  mainService.tsys399SelectList(paramMap);
		}catch(Exception e){
			Message="회사 리스트를 조회 하지 못하였습니다!";
		}
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		mv.setViewName("main/main/chgCompanyLayer");
		return mv;
	}

	@RequestMapping(value="/viewAlertInfo.do", method=RequestMethod.POST )
	public ModelAndView viewAlertInfo(HttpSession session, HttpServletRequest request) throws Exception {
		ModelAndView mav = new ModelAndView("/common/include/alertInfo");

		return mav;
	}
	@RequestMapping(value="/viewSearchUser.do", method=RequestMethod.POST )
	public ModelAndView viewSearchUser(HttpSession session, HttpServletRequest request) throws Exception {
		ModelAndView mav = new ModelAndView("/common/include/searchUser");

		return mav;
	}
	@RequestMapping(value="/viewSearchMenu.do", method=RequestMethod.POST )
	public ModelAndView viewSearchMenu(HttpSession session, HttpServletRequest request) throws Exception {
		ModelAndView mav = new ModelAndView("/common/include/searchMenu");

		return mav;
	}

	@RequestMapping(value="/viewAlertPanelLayer.do", method=RequestMethod.POST )
	public ModelAndView viewAlertPanelLayer(HttpSession session, HttpServletRequest request) throws Exception {
		ModelAndView mav = new ModelAndView("/common/include/alertPanelLayer");

		return mav;
	}
	
	/**
	 * 개인별 알림 조회
	 * 2020.06.09
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */

	@RequestMapping(value="/getPanalAlertList.do", method=RequestMethod.POST )
	public ModelAndView getPanalAlertList(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		List<?> result = mainService.getPanalAlertList(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("result", result);
		Log.DebugEnd();
		return mv;
	}
	/**
	 * 개인 권한 회사 리스트 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(value="/getCompanyAuthList.do", method=RequestMethod.POST )
	public ModelAndView getCompanyAuthList(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		
		List<?> result = mainService.tsys399SelectList(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("result", result);
		Log.DebugEnd();
		return mv;
	}

	

	/**
	 * Sub 화면
	 *
	 * @param paramMap
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(value="/getWidgetList.do", method=RequestMethod.POST )
	public ModelAndView getWidgetList( HttpSession session,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		paramMap.put("ssnGrpCd", session.getAttribute("ssnGrpCd"));
		paramMap.put("ssnLocaleCd",	session.getAttribute("ssnLocaleCd"));

		List<?> list = new ArrayList<>();
		String Message = "";
		try{
			list = mainService.getWidgetList(paramMap);
		}catch(Exception e){
			Message="개인 위젯 리스트를 조회 하지 못하였습니다!";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}

	/**
	 *  메인메뉴의 최상단 프로그램 정보 조회
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(value="/getMenuPrgMap.do", method=RequestMethod.POST )
	public ModelAndView getMenuPrgMap( HttpSession session,
									   @RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		paramMap.put("ssnGrpCd", session.getAttribute("ssnGrpCd"));
		paramMap.put("ssnLocaleCd",	session.getAttribute("ssnLocaleCd"));

		Map<?, ?> map = new HashMap<>();
		String Message = "";
		try{
			map = mainService.getMenuPrgMap(paramMap);
		}catch(Exception e){
			Message="프로그램 정보를 조회 하지 못하였습니다!";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", map);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * Widjet Default List
	 *
	 * @param session
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(value="/getWidgetDefaultList.do", method=RequestMethod.POST )
	public ModelAndView getWidgetDefaultList( HttpSession session,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		paramMap.put("ssnGrpCd", session.getAttribute("ssnGrpCd"));
		paramMap.put("ssnLocaleCd",	session.getAttribute("ssnLocaleCd"));

		List<?> list = new ArrayList<>();
		String Message = "";
		try{
			list = mainService.getWidgetDefaultList(paramMap);
		}catch(Exception e){
			Message="기본 위젯 리스트를 조회 하지 못하였습니다!";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}


	/**
	 * 개인 위젯 타입 가져오기
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(value="/getWidgetType.do", method=RequestMethod.POST )
	public ModelAndView getWidgetType(HttpSession session,
			HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		String ssnEnterCd = session.getAttribute("ssnEnterCd").toString();
		String ssnSabun   = session.getAttribute("ssnSabun").toString();
		String ssnGrpCd   = session.getAttribute("ssnGrpCd").toString();

		paramMap.put("ssnEnterCd", ssnEnterCd);
		paramMap.put("ssnSabun",   ssnSabun);
		paramMap.put("ssnGrpCd",   ssnGrpCd);

		Map<?, ?> map  = new HashMap<String, Object>();
		String Message = "";

		try{
			map =  mainService.getWidgetType(paramMap);
		}catch(Exception e){
			Message="위젯타입을 가져 오지 못했습니다."+ e.toString();
		}

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", map);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}

	@RequestMapping(value="/getWidgetToHtml.do", method=RequestMethod.GET )
	public String getWidget(@RequestParam Map<String, Object> paramMap) throws Exception {
		return paramMap.get("url") != null ? paramMap.get("url").toString():"";
	}

	@RequestMapping(value="/widjetPopup.do", method=RequestMethod.POST )
	public String widjetPopup(@RequestParam Map<String, Object> paramMap) throws Exception {
		return "main/main/widget_popup";
	}
	
	@RequestMapping(value="/getListBox0List.do", method=RequestMethod.POST )
	public ModelAndView getListBox0List(HttpSession session,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		paramMap.put("ssnLocaleCd",	session.getAttribute("ssnLocaleCd"));
		List<?> list = new ArrayList<>();
		String Message = "";
		try{
			list = mainService.getListBox0List(paramMap);
		}catch(Exception e){
			Message="위젯1을 불러 오지 못했습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}

	@RequestMapping(value="/getListBox0ListCnt.do", method=RequestMethod.POST )
	public ModelAndView getListBox0ListCnt(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));
		paramMap.put("ssnGrpCd", 	session.getAttribute("ssnGrpCd"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list =  mainService.getListBox0ListCnt(paramMap);
		}catch(Exception e){
			Message="위젯1를 불러 오지 못했습니다."+ e.toString();
		}

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		//mv.addObject("list1", list1);
		mv.addObject("list", list);
		//mv.addObject("list3", list3);
		mv.addObject("Message", Message);
		Log.Debug("MainController.getMainCalendarMap End");
		return mv;

	}

	@RequestMapping(value="/getListBox0List2.do", method=RequestMethod.POST )
	public ModelAndView getListBox0List2(HttpSession session,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		List<?> list = new ArrayList<Object>();
		String Message = "";
		try{
			list = mainService.getListBox0List2(paramMap);
		}catch(Exception e){
			Message="위젯1을 불러 오지 못했습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}

	@RequestMapping(value="/getListBox1List.do", method=RequestMethod.POST )
	public ModelAndView getListBox1List(HttpSession session,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		List<?> list = new ArrayList<>();
		String Message = "";
		try{
			list = mainService.getListBox1List(paramMap);
		}catch(Exception e){
			Message="위젯2를 불러 오지 못했습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}

	@RequestMapping(value="/getListBox2List.do", method=RequestMethod.POST )
	public ModelAndView getListBox2ListR(HttpSession session,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		paramMap.put("ssnLocaleCd",	session.getAttribute("ssnLocaleCd"));
		paramMap.put("ssnGrpCd", 	session.getAttribute("ssnGrpCd"));

		Map<String, Object> map = new HashMap<String, Object>();

		List<?> list = new ArrayList<Object>();
		String Message = "";

		try{
			list = mainService.getListBox2List(paramMap,"L");

			Map<?, ?> cnt = mainService.getListBox2Cnt(paramMap,"L");
			map.put("list", list);
			if(cnt != null) {
				map.put("cnt", cnt.get("cnt"));
			}
		}catch(Exception e){
			Message="위젯2를 불러 오지 못했습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("map", map);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}

	@RequestMapping(value="/getListBox19Info.do", method=RequestMethod.POST )
	public ModelAndView getListBox19Info(HttpSession session
									   , Map<String, Object> param) throws Exception {
		Log.DebugStart();
		param.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
		param.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		
		List<?> list = null;
		String message = "";
		
		try {
			list = mainService.getListBox19Info(param);
		} catch (Exception e) {
			message = "위젯19를 불러오지 못했습니다.";
		}
		
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", message);
		Log.DebugEnd();
		return mv;
	}

	@RequestMapping(value="/getListBox3List.do", method=RequestMethod.POST )
	public ModelAndView getListBox3List(HttpSession session,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		List<?> list = new ArrayList<>();
		String Message = "";
		try{
			list = mainService.getListBox3List(paramMap);
		}catch(Exception e){
			Message="위젯3을 불러 오지 못했습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}



	@RequestMapping(value="/getListBox4List.do", method=RequestMethod.POST )
	public ModelAndView getListBox4List(HttpSession session,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnGrpCd", 	session.getAttribute("ssnGrpCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		paramMap.put("ssnLocaleCd",	session.getAttribute("ssnLocaleCd"));
		List<?> list = new ArrayList<>();
		String Message = "";
		try{
			list = mainService.getListBox4List(paramMap);
		}catch(Exception e){
			Message="위젯4을 불러 오지 못했습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}

	@RequestMapping(value="/getListBox5List.do", method=RequestMethod.POST )
	public ModelAndView getListBox5List(HttpSession session,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		paramMap.put("ssnLocaleCd",	session.getAttribute("ssnLocaleCd"));

		List<?> list = new ArrayList<>();
		String Message = "";
		try{
			list = mainService.getListBox5List(paramMap);
		}catch(Exception e){
			Message="위젯2를 불러 오지 못했습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}
	
	@RequestMapping(value="/getListBox5TotalList.do", method=RequestMethod.POST )
	public ModelAndView getListBox5TotalList(HttpSession session, @RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		paramMap.put("ssnLocaleCd",	session.getAttribute("ssnLocaleCd"));
		
		List<?> list = new ArrayList<>();
		String Message = "";
		
		try {
			list = mainService.getListBox5TotalList(paramMap);
		} catch (Exception e) {
			Message="위젯5 월별 정보를 불러오지 못했습니다.";
		}
		
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}
	
	@RequestMapping(value="/getListBox5MonthList.do", method=RequestMethod.POST )
	public ModelAndView getListBox5MonthList(HttpSession session, @RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		paramMap.put("ssnLocaleCd",	session.getAttribute("ssnLocaleCd"));

		List<?> list = new ArrayList<>();
		String Message = "";
		
		try {
			list = mainService.getListBox5MonthList(paramMap);
		} catch (Exception e) {
			Message="위젯5 월별 정보를 불러오지 못했습니다.";
		}
		
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}

	@RequestMapping(value="/getListBox6List.do", method=RequestMethod.POST )
	public ModelAndView getListBox6List(HttpSession session,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		List<?> list = new ArrayList<Object>();
		String Message = "";
		try{
			list = mainService.getListBox6List(paramMap);
		}catch(Exception e){
			Message="위젯1을 불러 오지 못했습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}

	@RequestMapping(value="/getListBox6List2.do", method=RequestMethod.POST )
	public ModelAndView getListBox6List2(HttpSession session,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		List<?> list = new ArrayList<Object>();
		String Message = "";
		try{
			list = mainService.getListBox6List2(paramMap);
		}catch(Exception e){
			Message="위젯1을 불러 오지 못했습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}

	@RequestMapping(value="/getListBox6ListCnt.do", method=RequestMethod.POST )
	public ModelAndView getListBox6ListCnt(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));
		paramMap.put("ssnGrpCd", 	session.getAttribute("ssnGrpCd"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list =  mainService.getListBox6ListCnt(paramMap);
		}catch(Exception e){
			Message="위젯2를 불러 오지 못했습니다."+ e.toString();
		}

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		//mv.addObject("list1", list1);
		mv.addObject("list", list);
		//mv.addObject("list3", list3);
		mv.addObject("Message", Message);
		Log.Debug("MainController.getMainCalendarMap End");
		return mv;

	}


	@RequestMapping(value="/getListBox7List.do", method=RequestMethod.POST )
	public ModelAndView getListBox7List(HttpSession session,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		List<?> list = new ArrayList<Object>();
		String Message = "";
		try{
			list = mainService.getListBox7List(paramMap);
		}catch(Exception e){
			Message="위젯7을 불러 오지 못했습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}


	@RequestMapping(value="/getListBox8List.do", method=RequestMethod.POST )
	public ModelAndView getListBox8List(HttpSession session,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		List<?> list = new ArrayList<>();
		String Message = "";
		try{
			list = mainService.getListBox8List(paramMap);
		}catch(Exception e){
			Message="위젯2를 불러 오지 못했습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}

	@RequestMapping(value="/getListBox8List2.do", method=RequestMethod.POST )
	public ModelAndView getListBox8List2(HttpSession session,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		List<?> list = new ArrayList<>();
		String Message = "";
		try{
			list = mainService.getListBox8List2(paramMap);
		}catch(Exception e){
			Message="위젯2를 불러 오지 못했습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}

	@RequestMapping(value="/getListBox8ListCnt.do", method=RequestMethod.POST )
	public ModelAndView getListBox8ListCnt(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));
		paramMap.put("ssnGrpCd", 	session.getAttribute("ssnGrpCd"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list =  mainService.getListBox8ListCnt(paramMap);
		}catch(Exception e){
			Message="위젯1를 불러 오지 못했습니다."+ e.toString();
		}

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		//mv.addObject("list1", list1);
		mv.addObject("list", list);
		//mv.addObject("list3", list3);
		mv.addObject("Message", Message);
		Log.Debug("MainController.getMainCalendarMap End");
		return mv;

	}

	@RequestMapping(value="/getListBox9List.do", method=RequestMethod.POST )
	public ModelAndView getListBox9List(HttpSession session,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		List<?> list = new ArrayList<>();
		String Message = "";
		try{
			list = mainService.getListBox9List(paramMap);
		}catch(Exception e){
			Message="위젯2를 불러 오지 못했습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}

	@RequestMapping(value="/getListBox9ListCnt.do", method=RequestMethod.POST )
	public ModelAndView getListBox9ListCnt(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));
		paramMap.put("ssnGrpCd", 	session.getAttribute("ssnGrpCd"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list =  mainService.getListBox9ListCnt(paramMap);
		}catch(Exception e){
			Message="위젯2를 불러 오지 못했습니다."+ e.toString();
		}

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		//mv.addObject("list1", list1);
		mv.addObject("list", list);
		//mv.addObject("list3", list3);
		mv.addObject("Message", Message);
		Log.Debug("MainController.getMainCalendarMap End");
		return mv;

	}


	@RequestMapping(value="/getListBox10List.do", method=RequestMethod.POST )
	public ModelAndView getListBox10List(HttpSession session,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));

		List<?> list = new ArrayList<Object>();
		String Message = "";
		try{
			list = mainService.getListBox10List(paramMap);
		}catch(Exception e){
			Message="위젯1을 불러 오지 못했습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}

	@RequestMapping(value="/getListBox10ListCnt.do", method=RequestMethod.POST )
	public ModelAndView getListBox10ListCnt(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));
		paramMap.put("ssnGrpCd", 	session.getAttribute("ssnGrpCd"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list =  mainService.getListBox10ListCnt(paramMap);
		}catch(Exception e){
			Message="위젯1를 불러 오지 못했습니다."+ e.toString();
		}

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		//mv.addObject("list1", list1);
		mv.addObject("list", list);
		//mv.addObject("list3", list3);
		mv.addObject("Message", Message);
		Log.Debug("MainController.getMainCalendarMap End");
		return mv;

	}


	@RequestMapping(value="/getListBox12List.do", method=RequestMethod.POST )
	public ModelAndView getListBox12List(HttpSession session,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		List<?> list = new ArrayList<Object>();
		String Message = "";
		try{
			list = mainService.getListBox12List(paramMap);
		}catch(Exception e){
			Message="위젯12을 불러 오지 못했습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}

	@RequestMapping(value="/getListBox13List.do", method=RequestMethod.POST )
	public ModelAndView getListBox13List(HttpSession session,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		List<?> list = new ArrayList<Object>();
		String Message = "";
		try{
			list = mainService.getListBox13List(paramMap);
		}catch(Exception e){
			Message="위젯13을 불러 오지 못했습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}

	@RequestMapping(value="/getListBox14List.do", method=RequestMethod.POST )
	public ModelAndView getListBox14List(HttpSession session,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		List<?> list = new ArrayList<Object>();
		String Message = "";
		try{
			list = mainService.getListBox14List(paramMap);
		}catch(Exception e){
			Message="위젯14을 불러 오지 못했습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}

	@RequestMapping(value="/getListBox15List.do", method=RequestMethod.POST )
	public ModelAndView getListBox15List(HttpSession session,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		paramMap.put("ssnLocaleCd",	session.getAttribute("ssnLocaleCd"));

		List<?> list = new ArrayList<Object>();

		String Message = "";
		try{
			list = mainService.getListBox15List(paramMap);
		}catch(Exception e){
			Message="위젯15을 불러 오지 못했습니다.";
		}
		Log.Debug("LIST : " + list);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}

	@RequestMapping(value="/getListBox15ListCnt.do", method=RequestMethod.POST )
	public ModelAndView getListBox15ListCnt(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));
		paramMap.put("ssnGrpCd", 	session.getAttribute("ssnGrpCd"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list =  mainService.getListBox15ListCnt(paramMap);
		}catch(Exception e){
			Message="위젯1를 불러 오지 못했습니다."+ e.toString();
		}

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		//mv.addObject("list1", list1);
		mv.addObject("list", list);
		//mv.addObject("list3", list3);
		mv.addObject("Message", Message);
		Log.Debug("MainController.getMainCalendarMap End");
		return mv;

	}

	@RequestMapping(value="/getListBox16Cnt.do", method=RequestMethod.POST )
	public ModelAndView getListBox16Cnt(HttpSession session,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.Debug("MainController.mainService");
		paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		paramMap.put("ssnGrpCd", 	session.getAttribute("ssnGrpCd"));

		List<?> list = new ArrayList<>();
		String Message = "";
		try{
			list = mainService.getListBox16Cnt(paramMap);
		}catch(Exception e){
			Message="위젯1을 불러 오지 못했습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		Log.Debug("MainController.mainService End");
		return mv;
	}

	@RequestMapping(value="/getListBox16List.do", method=RequestMethod.POST )
	public ModelAndView getListBox16List(HttpSession session,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.Debug("MainController.mainService");
		paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		List<?> list = new ArrayList<>();
		String Message = "";
		try{
			list = mainService.getListBox16List(paramMap);
		}catch(Exception e){
			Message="위젯1을 불러 오지 못했습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		Log.Debug("MainController.mainService End");
		return mv;
	}

	@RequestMapping(value="/getListBox17List.do", method=RequestMethod.POST )
	public ModelAndView getListBox17List(HttpSession session,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.Debug("MainController.mainService");
		paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		List<?> list = new ArrayList<>();
		String Message = "";
		try{
			list = mainService.getListBox17List(paramMap);
		}catch(Exception e){
			Message="위젯1을 불러 오지 못했습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		Log.Debug("MainController.mainService End");
		return mv;
	}

	@RequestMapping(value="/getListBox18List.do", method=RequestMethod.POST )
	public ModelAndView getListBox18List(HttpSession session,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.Debug("MainController.mainService");
		paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		List<?> list = new ArrayList<>();
		String Message = "";
		try{
			list = mainService.getListBox18List(paramMap);
		}catch(Exception e){
			Message="위젯1을 불러 오지 못했습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		Log.Debug("MainController.mainService End");
		return mv;
	}

	@RequestMapping(value="/getListBox2CntL.do", method=RequestMethod.POST )
	public ModelAndView getListBox2CntL(HttpSession session,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.Debug("MainController.mainService");
		paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		paramMap.put("ssnGrpCd", 	session.getAttribute("ssnGrpCd"));
		List<?> list = new ArrayList<>();
		String Message = "";
		try{
			list = mainService.getListBox2CntL(paramMap);
		}catch(Exception e){
			Message="위젯1을 불러 오지 못했습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		Log.Debug("MainController.mainService End");
		return mv;
	}

	@RequestMapping(value="/getListBox2CntR.do", method=RequestMethod.POST )
	public ModelAndView getListBox2CntR(HttpSession session,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.Debug("MainController.mainService");
		paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		paramMap.put("ssnGrpCd", 	session.getAttribute("ssnGrpCd"));
		List<?> list = new ArrayList<>();
		String Message = "";
		try{
			list = mainService.getListBox2CntR(paramMap);
		}catch(Exception e){
			Message="위젯1을 불러 오지 못했습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		Log.Debug("MainController.mainService End");
		return mv;
	}

	@RequestMapping(value="/getListBox4Cnt.do", method=RequestMethod.POST )
	public ModelAndView getListBox4Cnt(HttpSession session,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.Debug("MainController.mainService");
		paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		paramMap.put("ssnGrpCd", 	session.getAttribute("ssnGrpCd"));
		List<?> list = new ArrayList<>();
		String Message = "";
		try{
			list = mainService.getListBox4Cnt(paramMap);
		}catch(Exception e){
			Message="위젯1을 불러 오지 못했습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		Log.Debug("MainController.mainService End");
		return mv;
	}

	@RequestMapping(value="/getListBox19List.do", method=RequestMethod.POST )
	public ModelAndView getListBox19List(HttpSession session,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		paramMap.put("ssnLocaleCd",	session.getAttribute("ssnLocaleCd"));

		Map<String, Object> map = new HashMap<String, Object>();

		List<?> list = new ArrayList<Object>();
		String Message = "";

		try{
			list = mainService.getListBox2List(paramMap,"R");

			Map<?, ?> cnt = mainService.getListBox2Cnt(paramMap,"R");

			map.put("list", list);
			if(cnt != null) {
				map.put("cnt", cnt.get("cnt"));
			}
		}catch(Exception e){
			Message="위젯19를 불러 오지 못했습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Map", map);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}
	
	/**
	 * 출근/퇴근 -- 2019.12.26 
	 * @param session
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/getListBox23List.do", method=RequestMethod.POST )
	public ModelAndView getListBox23List(HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		paramMap.put("ssnLocaleCd",	session.getAttribute("ssnLocaleCd"));
		
		//String clientIp = InetAddress.getLocalHost().getHostAddress();
		String clientIp = StringUtil.getClientIP(request);
		Log.Debug("IP : " + clientIp );
		paramMap.put("ip", clientIp);

		//Map<String, Object> map = new HashMap<String, Object>();

		List<?> list = new ArrayList<Object>();
		String Message = "";

		try{
			list = mainService.getListBox23List(paramMap);

		}catch(Exception e){
			Message="위젯23를 불러 오지 못했습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Map", list);
		mv.addObject("IPAddr", clientIp);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}


	/**
	 * 출근/퇴근 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(value="/saveListBox23List.do", method=RequestMethod.POST )
	public ModelAndView saveListBox19List(HttpSession session,
			HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		String ssnEnterCd = session.getAttribute("ssnEnterCd").toString();
		String ssnSabun   = session.getAttribute("ssnSabun").toString();

		paramMap.put("ssnEnterCd", ssnEnterCd);
		paramMap.put("ssnSabun",   ssnSabun);

		Map<String, Object> resultMap = new HashMap<String, Object>();
		try{ 

			Log.Debug("IP : "+InetAddress.getLocalHost().getHostAddress());
			paramMap.put("ip", InetAddress.getLocalHost().getHostAddress());
			
			Map<?, ?> map  = mainService.prcListBox23List(paramMap);

			if(map != null) {
				Log.Debug("obj : "+map);
				
				if (map.get("sqlCode") != null) {
					resultMap.put("Code", map.get("sqlCode").toString());
				}
				if (map.get("sqlErrm") != null) {
					resultMap.put("Message", map.get("sqlErrm").toString());
				}
			}
		}catch(Exception e) {	
			resultMap.put("Code", "-999");
			resultMap.put("Message", "출/퇴근 처리 시 오류가 발생했습니다.");
		}

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Result", resultMap);
		
		Log.DebugEnd();
		return mv;
	}

	
	/**
	 * 출근/퇴근 시간 조회  
	 * @param session
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/getListBox23ListStdTime.do", method=RequestMethod.POST )
	public ModelAndView getListBox23ListStdTime(HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataMap(session, request, paramMap);
	}
	/**
	 * 출근/퇴근 주간 출퇴근 list 조회  
	 * @param session
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/getListBox23ListWeekList.do", method=RequestMethod.POST )
	public ModelAndView getListBox23ListWeekList(HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}
	


	/**
	 * 주근무현황 -- 2020.09.04
	 * @param session
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/getListBox24List.do", method=RequestMethod.POST )
	public ModelAndView getListBox24List(HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		paramMap.put("ssnLocaleCd",	session.getAttribute("ssnLocaleCd"));
		
		//String clientIp = InetAddress.getLocalHost().getHostAddress();
		String clientIp = StringUtil.getClientIP(request);
		Log.Debug("IP : " + clientIp );
		paramMap.put("ip", clientIp);

		//Map<String, Object> map = new HashMap<String, Object>();

		List<?> list = new ArrayList<Object>();
		String Message = "";

		try{
			list = mainService.getListBox24List(paramMap);

		}catch(Exception e){
			Message="위젯23를 불러 오지 못했습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("IPAddr", clientIp);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}
	
	@RequestMapping(value="/getListBox25List.do", method=RequestMethod.POST )
	public ModelAndView getListBox25List(HttpSession session,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		paramMap.put("ssnLocaleCd",	session.getAttribute("ssnLocaleCd"));

		List<?> list = new ArrayList<>();
		String Message = "";
		try{
			list = mainService.getListBox25List(paramMap);
		}catch(Exception e){
			Message="위젯2를 불러 오지 못했습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}
	
	// 직급대비 급여 상/하위
	@RequestMapping(value="/getListBox701List.do", method=RequestMethod.POST )
	public ModelAndView getListBox701List(HttpSession session,
			@RequestParam Map<String, Object> paramMap,@RequestParam(value = "jikwee", required = false, defaultValue = "") String jikwee) throws Exception{ 
		
		Map<String, Object> param = new HashMap<>();
		param.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		param.put("ssnSabun", session.getAttribute("ssnSabun"));
		param.put("ssnLocaleCd", session.getAttribute("ssnLocaleCd"));
		
		Map<String, Object> salaryRank = new HashMap<>();
		Map<String, Object> data = new HashMap<>();
		String Message = "";
		
		try{
			salaryRank.put("companyJikweeList", mainService.getCompanyJikweeList(param));
			
			// 파라미터가 없을 때 첫번쨰 직급 세팅
			if (jikwee.equals("")) {
				List<Map<String, String>> companyJikweeList = (List<Map<String, String>>) salaryRank.get("companyJikweeList");
				Map<String, String> firstJikweeInfo = companyJikweeList.get(0);
				jikwee = firstJikweeInfo.get("jikweeCd");
			}
			
			param.put("jikwee", jikwee);
			
			salaryRank.put("dataTop", mainService.getSalaryTop(param));
			salaryRank.put("dataBottom", mainService.getSalaryBottom(param));
			salaryRank.put("enterCd", session.getAttribute("ssnEnterCd"));
			
			data.put("salaryRank", salaryRank);
		}catch(Exception e){
			Message="위젯701를 불러 오지 못했습니다.";
		}
		
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("data", data);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		
		return mv;
	}
	
	// 급여 인상 Top 10
	@RequestMapping(value="/getListBox702List.do", method=RequestMethod.POST )
	public ModelAndView getListBox702List(HttpSession session,
			@RequestParam Map<String, Object> paramMap) throws Exception{ 
		
		Map<String, Object> param = new HashMap<>();
		param.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		param.put("ssnSabun", session.getAttribute("ssnSabun"));
		param.put("ssnLocaleCd", session.getAttribute("ssnLocaleCd"));
		
		Map<String, Object> salaryIncrease = new HashMap<>();
		Map<String, Object> data = new HashMap<>();
		String Message = "";
		
		try{
			salaryIncrease.put("data", mainService.getSalaryIncrease(param));
			salaryIncrease.put("enterCd", session.getAttribute("ssnEnterCd"));

			data.put("salaryIncrease", salaryIncrease);
		}catch(Exception e){
			Message="위젯702를 불러 오지 못했습니다.";
		}
		
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("data", data);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		
		return mv;
	}
	
	// 급여 아웃라이어
	@RequestMapping(value="/getListBox703List.do", method=RequestMethod.POST )
	public ModelAndView getListBox703List(HttpSession session,
			@RequestParam Map<String, Object> paramMap) throws Exception{ 
		
		Map<String, Object> param = new HashMap<>();
		param.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		param.put("ssnSabun", session.getAttribute("ssnSabun"));
		param.put("ssnLocaleCd", session.getAttribute("ssnLocaleCd"));
		
		Map<String, Object> salaryOutlier = new HashMap<>();
		Map<String, Object> data = new HashMap<>();
		String Message = "";

		try{

			//salaryOutlier.put("data", mainService.getSalaryOutlier(param));
			salaryOutlier.put("data", new ObjectMapper().readValue(ResourceUtils.getFile(ResourceUtils.CLASSPATH_URL_PREFIX + "/json" + "/listBox703.json"), List.class));

			
			data.put("salaryOutlier", salaryOutlier);
		}catch(Exception e){
			e.printStackTrace();
			Message="위젯703를 불러 오지 못했습니다.";
		}
		
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("data", data);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		
		return mv;
	}
	
	// 연간 총급여 인상
	@RequestMapping(value="/getListBox704List.do", method=RequestMethod.POST )
	public ModelAndView getListBox704List(HttpSession session,
			@RequestParam Map<String, Object> paramMap, @RequestParam(value = "option", required= false, defaultValue = "year") String option) throws Exception{ 
		
		Map<String, Object> param = new HashMap<>();
		param.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		param.put("ssnSabun", session.getAttribute("ssnSabun"));
		param.put("ssnLocaleCd", session.getAttribute("ssnLocaleCd"));
		param.put("option", option);
		
		Map<String, Object> salaryIncreaseData = new HashMap<>();
		Map<String, Object> data = new HashMap<>();
		String Message = "";
		
		try{
			/*목데이터*/
			salaryIncreaseData.put("year4", "1,600");
			salaryIncreaseData.put("gapRate", "100 증가");
			salaryIncreaseData.put("maxRate", 20);
			salaryIncreaseData.put("minRate", 30);
			salaryIncreaseData.put("maxGapRate", "2 증가");
			salaryIncreaseData.put("minGapRate", "3 증가");
			
			if ("month".equals(option)) {
				salaryIncreaseData.put("mon1", 100);
				salaryIncreaseData.put("mon2", 110);
				salaryIncreaseData.put("mon3", 120);
				salaryIncreaseData.put("mon4", 130);
				salaryIncreaseData.put("mon5", 140);
				salaryIncreaseData.put("mon6", 20);
				salaryIncreaseData.put("mon7", 160);
				salaryIncreaseData.put("mon8", 170);
				salaryIncreaseData.put("mon9", 180);
				salaryIncreaseData.put("mon10", 190);
				salaryIncreaseData.put("mon11", 200);
				salaryIncreaseData.put("mon12", 80);
			} else if ("year".equals(option)) {
				salaryIncreaseData.put("year1", 200);
				salaryIncreaseData.put("year2", 400);
				salaryIncreaseData.put("year3", 800);
			} else if ("quarter".equals(option)) {
				salaryIncreaseData.put("quarter1", 330);
				salaryIncreaseData.put("quarter2", 290);
				salaryIncreaseData.put("quarter3", 510);
				salaryIncreaseData.put("quarter4", 470);
			}
			
			data.put("salaryIncreaseData", salaryIncreaseData);
		}catch(Exception e){
			Message="위젯704를 불러 오지 못했습니다.";
		}
		
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("data", data);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		
		return mv;
	}
	
	// 퇴직금 지급
	@RequestMapping(value="/getListBox705List.do", method=RequestMethod.POST )
	public ModelAndView getListBox705List(HttpSession session,
			@RequestParam Map<String, Object> paramMap, @RequestParam(value = "option", required= false, defaultValue = "year") String option) throws Exception{ 
		
		Map<String, Object> param = new HashMap<>();
		param.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		param.put("ssnSabun", session.getAttribute("ssnSabun"));
		param.put("ssnLocaleCd", session.getAttribute("ssnLocaleCd"));
		param.put("option", option);
		
		Map<String, Object> severancePayData = new HashMap<>();
		Map<String, Object> data = new HashMap<>();
		String Message = "";
		
		try{
			/*목데이터*/
			severancePayData.put("year4", "2,200");
			severancePayData.put("gapRate", "100 증가");
			severancePayData.put("maxRate", 30);
			severancePayData.put("minRate", 40);
			severancePayData.put("maxGapRate", "2 증가");
			severancePayData.put("minGapRate", "3 증가");
			
			if ("month".equals(option)) {
				severancePayData.put("mon1", 150);
				severancePayData.put("mon2", 160);
				severancePayData.put("mon3", 170);
				severancePayData.put("mon4", 180);
				severancePayData.put("mon5", 190);
				severancePayData.put("mon6", 70);
				severancePayData.put("mon7", 210);
				severancePayData.put("mon8", 220);
				severancePayData.put("mon9", 230);
				severancePayData.put("mon10", 240);
				severancePayData.put("mon11", 250);
				severancePayData.put("mon12", 130);
			} else if ("year".equals(option)) {
				severancePayData.put("year1", 2000);
				severancePayData.put("year2", 500);
				severancePayData.put("year3", 1100);
			} else if ("quarter".equals(option)) {
				severancePayData.put("quarter1", 330);
				severancePayData.put("quarter2", 290);
				severancePayData.put("quarter3", 510);
				severancePayData.put("quarter4", 470);
			}
			
			data.put("severancePayData", severancePayData);
		}catch(Exception e){
			Message="위젯705를 불러 오지 못했습니다.";
		}
		
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("data", data);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		
		return mv;
	}
	
	// 전사 월간 급여
	@RequestMapping(value="/getListBox706List.do", method=RequestMethod.POST )
	public ModelAndView getListBox706List(HttpSession session,
			@RequestParam Map<String, Object> paramMap, @RequestParam(value = "option", required= false, defaultValue = "month") String option) throws Exception{ 
		
		Map<String, Object> param = new HashMap<>();
		param.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		param.put("ssnSabun", session.getAttribute("ssnSabun"));
		param.put("ssnLocaleCd", session.getAttribute("ssnLocaleCd"));
		param.put("option", option);
		
		Map<String, Object> monthlyPayData = new HashMap<>();
		Map<String, Object> data = new HashMap<>();
		String Message = "";
		
		try{
			/*목데이터*/
			monthlyPayData.put("year4", "3,000");
			monthlyPayData.put("gapRate", "100 증가");
			monthlyPayData.put("maxRate", 30);
			monthlyPayData.put("minRate", 40);
			monthlyPayData.put("maxGapRate", "2 증가");
			monthlyPayData.put("minGapRate", "3 증가");
			
			if ("month".equals(option)) {
				monthlyPayData.put("mon1", 250);
				monthlyPayData.put("mon2", 260);
				monthlyPayData.put("mon3", 270);
				monthlyPayData.put("mon4", 280);
				monthlyPayData.put("mon5", 290);
				monthlyPayData.put("mon6", 170);
				monthlyPayData.put("mon7", 310);
				monthlyPayData.put("mon8", 220);
				monthlyPayData.put("mon9", 230);
				monthlyPayData.put("mon10", 340);
				monthlyPayData.put("mon11", 350);
				monthlyPayData.put("mon12", 230);
			} else if ("year".equals(option)) {
				monthlyPayData.put("year1", "1,500");
				monthlyPayData.put("year2", "1,500");
				monthlyPayData.put("year3", "1,500");
			} else if ("quarter".equals(option)) {
				monthlyPayData.put("quarter1", 330);
				monthlyPayData.put("quarter2", 290);
				monthlyPayData.put("quarter3", 510);
				monthlyPayData.put("quarter4", 470);
			}
			
			data.put("monthlyPayData", monthlyPayData);
		}catch(Exception e){
			Message="위젯706를 불러 오지 못했습니다.";
		}
		
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("data", data);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		
		return mv;
	}
	
	// 전사 연봉 평균
	@RequestMapping(value="/getListBox707List.do", method=RequestMethod.POST )
	public ModelAndView getListBox707List(HttpSession session,
			@RequestParam Map<String, Object> paramMap, @RequestParam(value = "option", required= false, defaultValue = "position") String option) throws Exception{ 
		
		Map<String, Object> param = new HashMap<>();
		param.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		param.put("ssnSabun", session.getAttribute("ssnSabun"));
		param.put("ssnLocaleCd", session.getAttribute("ssnLocaleCd"));
		param.put("option", option);
		
		List<Map<String, Object>> averageData = new ArrayList<>();
		Map<String, Object> averageSalary = new HashMap<>();
		Map<String, Object> data = new HashMap<>();
		String Message = "";
		
		try{
			/*목데이터*/
			averageSalary.put("average", "5.55");
			averageSalary.put("gapRate", "100 증가");
			averageSalary.put("maxRate", 10);
			averageSalary.put("minRate", 3);
			averageSalary.put("maxGapRate", "2 증가");
			averageSalary.put("minGapRate", "3 증가");
			
			if ("gender".equals(option)) {
				Map<String, Object> data0 = new HashMap<>();
		        data0.put("averageNm", "남");
		        data0.put("averageNum", 7);
		        averageData.add(data0);

		        Map<String, Object> data1 = new HashMap<>();
		        data1.put("averageNm", "여");
		        data1.put("averageNum", 7);
		        averageData.add(data1);
			} else if ("position".equals(option)) {
				Map<String, Object> data0 = new HashMap<>();
		        data0.put("averageNm", "사원");
		        data0.put("averageNum", 4);
		        averageData.add(data0);

		        Map<String, Object> data1 = new HashMap<>();
		        data1.put("averageNm", "차장");
		        data1.put("averageNum", 7);
		        averageData.add(data1);

		        Map<String, Object> data2 = new HashMap<>();
		        data2.put("averageNm", "부장");
		        data2.put("averageNum", 10);
		        averageData.add(data2);

		        Map<String, Object> data3 = new HashMap<>();
		        data3.put("averageNm", "임원");
		        data3.put("averageNum", 12);
		        averageData.add(data3);
			} else if ("tenure".equals(option)) {
				Map<String, Object> data0 = new HashMap<>();
		        data0.put("averageNm", "1년차");
		        data0.put("averageNum", 4);
		        averageData.add(data0);

		        Map<String, Object> data1 = new HashMap<>();
		        data1.put("averageNm", "3년차");
		        data1.put("averageNum", 7);
		        averageData.add(data1);

		        Map<String, Object> data2 = new HashMap<>();
		        data2.put("averageNm", "4년차");
		        data2.put("averageNum", 10);
		        averageData.add(data2);
			}
	
			data.put("averageData", averageData);
			data.put("averageSalary", averageSalary);
		}catch(Exception e){
			Message="위젯707를 불러 오지 못했습니다.";
		}
		
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("data", data);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		
		return mv;
	}

	// 위젯708(예상퇴직금 조회)
	@RequestMapping(value="/getListBox708Map.do", method=RequestMethod.POST )
	public ModelAndView getListBox708Map(HttpSession session,
										  @RequestParam Map<String, Object> paramMap, @RequestParam(value = "option", required= false, defaultValue = "position") String option) throws Exception{

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));
		paramMap.put("ssnLocaleCd", session.getAttribute("ssnLocaleCd"));
		paramMap.put("sabun", session.getAttribute("ssnSabun"));

        Map<String, Object> prcMap = (Map<String, Object>) mainService.prcP_CPN_SEP_SIMULATION(paramMap);
        Log.Debug("map[" + prcMap + "] sqlcode[" + prcMap.get("sqlcode") + "] sqlerrm[" + prcMap.get("sqlerrm") + "]");

        Map<String, Object> resultMap = new HashMap<String, Object>();
        resultMap.put("Code", "0");

        if (prcMap.get("sqlcode") != null && !"OK".equals(prcMap.get("sqlcode").toString())) {
            resultMap.put("Code", prcMap.get("sqlcode").toString());
            if (prcMap.get("sqlerrm") != null) {
                resultMap.put("Message", prcMap.get("sqlerrm").toString());
            } else {
                resultMap.put("Message", "예상퇴직금 조회 오류입니다.");
            }
        }
        
        Map<String, Object> map = new HashMap<>();
        String Message = "";
        
        try{
            map = (Map<String, Object>) mainService.getListBox708Map(paramMap);
        }catch(Exception e){
            Message="위젯708를 불러 오지 못했습니다.";
        }
		
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("data", map);
		mv.addObject("Message", Message);
		Log.DebugEnd();

		return mv;
	}
	
	// 위젯709(4대보험조회)
    @RequestMapping(value="/getListBox709List.do", method=RequestMethod.POST )
    public ModelAndView getListBox709List(HttpSession session,
                                          @RequestParam Map<String, Object> paramMap, @RequestParam(value = "option", required= false, defaultValue = "position") String option) throws Exception{

        paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
        paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));
        paramMap.put("ssnLocaleCd", session.getAttribute("ssnLocaleCd"));
        paramMap.put("sabun", session.getAttribute("ssnSabun"));
        
        List<?> list  = new ArrayList<Object>();
        String Message = "";
        
        try{
            
            if (option.equals("pen")) {
                list =  mainService.getListBox709PenList(paramMap);
                
            }else if (option.equals("healthIns")) {
                list = mainService.getListBox709HealthInsList(paramMap);
                
            }else if (option.equals("empIns")) {
                list = mainService.getListBox709EmpInsList(paramMap);
            }
            
        }catch(Exception e){
            Message="위젯709를 불러 오지 못했습니다.";
        }
        
        ModelAndView mv = new ModelAndView();
        mv.setViewName("jsonView");
        mv.addObject("data", list);
        mv.addObject("Message", Message);
        Log.DebugEnd();

        return mv;
    }
    
	// 입/퇴사 추이
	@RequestMapping(value="/getListBox201List.do", method=RequestMethod.POST )
	public ModelAndView getListBox201List(HttpSession session,
			@RequestParam Map<String, Object> paramMap) throws Exception{ 
		
		Map<String, Object> param = new HashMap<>();
		param.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		param.put("ssnSabun", session.getAttribute("ssnSabun"));
		param.put("ssnLocaleCd", session.getAttribute("ssnLocaleCd"));
		
		Map<String, Object> yearlyEnterExitTrend = new HashMap<>();
		Map<String, Object> data = new HashMap<>();
		String Message = "";
		
		try{
			yearlyEnterExitTrend.put("data", mainService.getYearlyEnterExitTrend(param));
			yearlyEnterExitTrend.put("monthlyData", mainService.getMonthlyEnterExitTrend(param));
			
			data.put("yearlyEnterExitTrend", yearlyEnterExitTrend);
		}catch(Exception e){
			Message="위젯201를 불러 오지 못했습니다.";
		}
		
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("data", data);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		
		return mv;
	}
	
	// 3개년 채용 인원
	@RequestMapping(value="/getListBox202List.do", method=RequestMethod.POST )
	public ModelAndView getListBox202List(HttpSession session,
			@RequestParam Map<String, Object> paramMap) throws Exception{ 
		
		Map<String, Object> param = new HashMap<>();
		param.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		param.put("ssnSabun", session.getAttribute("ssnSabun"));
		param.put("ssnLocaleCd", session.getAttribute("ssnLocaleCd"));
		
		Map<String, Object> companyYearlyTrendsValues = new HashMap<>();
		Map<String, Object> data = new HashMap<>();
		String Message = "";
		
		try{
			companyYearlyTrendsValues.put("data", mainService.getCompanyYearlyTrendsValues(param));
			
			data.put("companyYearlyTrendsValues", companyYearlyTrendsValues);
		}catch(Exception e){
			Message="위젯202를 불러 오지 못했습니다.";
		}
		
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("data", data);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		
		return mv;
	}

	// 3개년 채용 지수
	@RequestMapping(value="/getListBox203List.do", method=RequestMethod.POST )
	public ModelAndView getListBox203List(HttpSession session,
			@RequestParam Map<String, Object> paramMap) throws Exception{
		
		Map<String, Object> param = new HashMap<>();
		param.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		param.put("ssnSabun", session.getAttribute("ssnSabun"));
		param.put("ssnLocaleCd", session.getAttribute("ssnLocaleCd"));
		
		Map<String, Object> companyYearlyTrendsValues = new HashMap<>();
		Map<String, Object> data = new HashMap<>();
		String Message = "";
		
		try{
//			companyYearlyTrendsValues.put("data", mainService.getCompanyYearlyTrendsValues(param));
			
			/**
			 * 목데이터
			 * 	[
	                {
	                    "year": "2023",
	                    "remainCnt": 8, // 잔류자
	                    "rate": 100,	// 성공률
	                    "cnt": 8,		// 입사자
	                    "gapRate": 0	// 작년 대비
	                },
	                {
	                    "year": "2022",
	                    "remainCnt": 2,
	                    "rate": 100,
	                    "cnt": 2,
	                    "gapRate": 6
	                },
	                ...
            	]
			 */
			List<Map<String, Object>> mockDataList = new ArrayList<>();

			Map<String, Object> yearMap0 = new HashMap<>();

			yearMap0.put("year", "2024");
			// 채용 성공률 = 잔류자/입사자
			yearMap0.put("rate", 95);  // 채용 성공률
			yearMap0.put("remainCnt", 10);  // 잔류자
			// 선발률 = 합격자/총 지원자
			yearMap0.put("selectionCnt", 50);  // 합격자
			yearMap0.put("totalCnt", 100);  // 총 지원자
			// 수용률 = 최종 입사자/합격자
			yearMap0.put("acceptanceCnt", 10);  // 최종 입사자
			// 안정도 = 1년 이상 근속자/최종 입사자
			yearMap0.put("stabilityCnt", 0);  // 1년 이상 근속자
			// 기초율 = 직무수행 성공자/총 지원자
			yearMap0.put("successBaseCnt", 5);  // 직무수행 성공자

			mockDataList.add(yearMap0);
			
			Map<String, Object> yearMap1 = new HashMap<>();
			
			yearMap1.put("year", "2023");
			// 채용 성공률 = 잔류자/입사자
			yearMap1.put("rate", 70);  // 채용 성공률
			yearMap1.put("remainCnt", 12);  // 잔류자
			// 선발률 = 합격자/총 지원자
			yearMap1.put("selectionCnt", 45);  // 합격자
			yearMap1.put("totalCnt", 90);  // 총 지원자
			// 수용률 = 최종 입사자/합격자
			yearMap1.put("acceptanceCnt", 35);  // 최종 입사자
			// 안정도 = 1년 이상 근속자/최종 입사자
			yearMap1.put("stabilityCnt", 23);  // 1년 이상 근속자
			// 기초율 = 직무수행 성공자/총 지원자
			yearMap1.put("successBaseCnt", 17);  // 직무수행 성공자
			
			mockDataList.add(yearMap1);
			
			Map<String, Object> yearMap2 = new HashMap<>();
			
			yearMap2.put("year", "2022");
			// 채용 성공률 = 잔류자/입사자
			yearMap2.put("rate", 75); // 채용 성공률
			yearMap2.put("remainCnt", 20); // 잔류자
			// 선발률 = 합격자/총 지원자
			yearMap2.put("selectionCnt", 50); // 합격자
			yearMap2.put("totalCnt", 85); // 총 지원자
			// 수용률 = 최종 입사자/합격자
			yearMap2.put("acceptanceCnt", 40); // 최종 입사자
			// 안정도 = 1년 이상 근속자/최종 입사자
			yearMap2.put("stabilityCnt", 19); // 1년 이상 근속자
			// 기초율 = 직무수행 성공자/총 지원자
			yearMap2.put("successBaseCnt", 23); // 직무수행 성공자
			
			mockDataList.add(yearMap2);

			companyYearlyTrendsValues.put("data", mockDataList);
			/** */
			
			data.put("companyYearlyTrendsValues", companyYearlyTrendsValues);			
		}catch(Exception e){
			Message = "위젯203를 불러 오지 못했습니다.";
		}
		
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("data", data);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		
		return mv;
	}
	
	// 퇴사율 위젯 
	@RequestMapping(value="/getListBox204List.do", method=RequestMethod.POST )
	public ModelAndView getListBox204List(HttpSession session,
			@RequestParam Map<String, Object> paramMap) throws Exception{ 
		
		Map<String, Object> param = new HashMap<>();
		param.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		param.put("ssnSabun", session.getAttribute("ssnSabun"));
		param.put("ssnLocaleCd", session.getAttribute("ssnLocaleCd"));
		
		Map<String, Object> leave = new HashMap<>();
		Map<String, Object> data = new HashMap<>();
		String Message = "";
		
		try{
			leave.put("data", mainService.getYearlyEnterExitTrend(param));
			
			data.put("leave", leave);
		}catch(Exception e){
			Message="위젯204를 불러 오지 못했습니다.";
		}
		
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("data", data);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		
		return mv;
	}
	
	
	
	// 승진 후보자 목록 위젯 
	@RequestMapping(value="/getListBox205List.do", method=RequestMethod.POST )
	public ModelAndView getListBox205List(HttpSession session,
			@RequestParam Map<String, Object> paramMap, @RequestParam(value = "option", required= false, defaultValue = "all") String option) throws Exception{ 
		
		Map<String, Object> param = new HashMap<>();
		param.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		param.put("ssnSabun", session.getAttribute("ssnSabun"));
		param.put("ssnLocaleCd", session.getAttribute("ssnLocaleCd"));
		param.put("option", option);
		
		Map<String, Object> data = new HashMap<>();
		Map<String, Object> candidate = new HashMap<>();
		String Message = "";
		
		try{
			candidate.put("data", mainService.getJikweeList(param));
			candidate.put("dataList", mainService.getCandidate(param));
			candidate.put("enterCd", session.getAttribute("ssnEnterCd"));

			data.put("candidate", candidate);
		}catch(Exception e){
			Message="위젯205를 불러 오지 못했습니다.";
		}
		
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("data", data);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		
		return mv;
	}
	
	/*
	 * 전사 인원 추이 TODO 쿼리 적용 후 목데이터 수정 
	 */
	@RequestMapping(value="/getListBox206List.do", method=RequestMethod.POST )
	public ModelAndView getListBox206List(HttpSession session,
			@RequestParam Map<String, Object> paramMap, @RequestParam(value = "option", required= false, defaultValue = "year") String option) throws Exception{ 
		
		Map<String, Object> param = new HashMap<>();
		param.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		param.put("ssnSabun", session.getAttribute("ssnSabun"));
		param.put("ssnLocaleCd", session.getAttribute("ssnLocaleCd"));
		
		Map<String, Object> personnelTrend = new HashMap<>();
		Map<String, Object> data = new HashMap<>();
		String Message = "";
		
		try{
			/*목데이터*/
			personnelTrend.put("cnt", "1,111");
			personnelTrend.put("goal", "2,222");
			personnelTrend.put("rate", 50);
			
			if ("month".equals(option) || "quarter".equals(option)) {
				personnelTrend.put("mon1Cnt", 111);
				personnelTrend.put("mon2Cnt", 112);
				personnelTrend.put("mon3Cnt", 113);
				personnelTrend.put("mon4Cnt", 114);
				personnelTrend.put("mon5Cnt", 115);
				personnelTrend.put("mon6Cnt", 116);
				personnelTrend.put("mon7Cnt", 117);
				personnelTrend.put("mon8Cnt", 118);
				personnelTrend.put("mon9Cnt", 119);
				personnelTrend.put("mon10Cnt", 37);
				personnelTrend.put("mon11Cnt", 38);
				personnelTrend.put("mon12Cnt", 39);
			}

			if ("year".equals(option)) {
				personnelTrend.put("year1Cnt", 200);
				personnelTrend.put("year2Cnt", 400);
				personnelTrend.put("year3Cnt", 500);
				personnelTrend.put("year4Cnt", "1,111");
			}
			
			data.put("personnelTrend", personnelTrend);
		}catch(Exception e){
			Message = "위젯206를 불러 오지 못했습니다.";
		}
		
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("data", data);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		
		return mv;
	}
	
	/*
	 * 채용 현황 TODO 쿼리 적용 후 목데이터 수정 
	 */
	@RequestMapping(value="/getListBox207List.do", method=RequestMethod.POST )
	public ModelAndView getListBox207List(HttpSession session,
			@RequestParam Map<String, Object> paramMap) throws Exception{ 
		
		Map<String, Object> param = new HashMap<>();
		param.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		param.put("ssnSabun", session.getAttribute("ssnSabun"));
		param.put("ssnLocaleCd", session.getAttribute("ssnLocaleCd"));
		
		Map<String, Object> recruitmentStatus = new HashMap<>();
		Map<String, Object> data = new HashMap<>();
		String Message = "";
	
		try{
			/*목데이터*/
			recruitmentStatus.put("appsCnt", 888);
			recruitmentStatus.put("appsGapRate", 20);
			recruitmentStatus.put("winnersCnt", 50);
			recruitmentStatus.put("winnersGapRate", 30);
			recruitmentStatus.put("newHiresCnt", 45);
			recruitmentStatus.put("newHiresGapRate", 40);
			
			data.put("recruitmentStatus", recruitmentStatus);
		}catch(Exception e){
			Message="위젯207를 불러 오지 못했습니다.";
		}
		
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("data", data);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		
		return mv;
	}
	
	/*
	 * 핵심인재 현황 TODO 쿼리 적용 후 목데이터 수정 
	 */
	@RequestMapping(value="/getListBox208List.do", method=RequestMethod.POST )
	public ModelAndView getListBox208List(HttpSession session,
			@RequestParam Map<String, Object> paramMap, @RequestParam(value = "option", required= false, defaultValue = "all") String option) throws Exception{ 
		
		Map<String, Object> param = new HashMap<>();
		param.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		param.put("ssnSabun", session.getAttribute("ssnSabun"));
		param.put("ssnLocaleCd", session.getAttribute("ssnLocaleCd"));
		param.put("option", option);
		
		List<Map<String, Object>> coreStatus = new ArrayList<>();
		Map<String, Object> data = new HashMap<>();
		String Message = "";
	    
		try{
			/* 목데이터 */
			for (int i = 0; i < 10; i++) {
			    Map<String, Object> newData = new HashMap<>();
			    newData.put("name", "이름" + i);
			    newData.put("orgNm", "조직" + i);
			    newData.put("sabun", "사번" + i);
			
			    if ("team".equals(option) || "all".equals(option)) {
			        newData.put("jikweeNm", "팀" + i);
			    } else if (option.equals("head")) {
			        newData.put("jikweeNm", "본부" + i);
			    }
			
			    coreStatus.add(newData);
			}
			
			if ("all".equals(option)) {
			    for (int i = 0; i < 10; i++) {
			        Map<String, Object> newData = new HashMap<>();
			        newData.put("name", "이름" + i);
			        newData.put("jikweeNm", "본부" + i);
			        newData.put("orgNm", "조직" + i);
			        newData.put("sabun", "사번" + i);
			
			        coreStatus.add(newData);
			    }
			}
			 
			data.put("enterCd", session.getAttribute("ssnEnterCd"));
			data.put("coreStatus", coreStatus);
		}catch(Exception e){
			Message="위젯208를 불러 오지 못했습니다.";
		}
		
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("data", data);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		
		return mv;
	}
	
	/*
	 * 복직 예정자 현황
	 */
	@RequestMapping(value="/getListBox209List.do", method=RequestMethod.POST )
	public ModelAndView getListBox209List(HttpSession session,
			@RequestParam Map<String, Object> paramMap, @RequestParam(value = "option", required= false, defaultValue = "all") String option) throws Exception{ 
		
		Map<String, Object> param = new HashMap<>();
		param.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		param.put("ssnSabun", session.getAttribute("ssnSabun"));
		param.put("ssnLocaleCd", session.getAttribute("ssnLocaleCd"));
		param.put("option", option);

		Map<String, Object> overseaDeployment = new HashMap<>();
		Map<String, Object> data = new HashMap<>();
		String Message = "";
	    
		try{
			overseaDeployment.put("data", mainService.getOverseaDeployment(param));
			data.put("overseaDeployment", overseaDeployment);
		}catch(Exception e){
			Message="위젯209를 불러 오지 못했습니다.";
		}
		
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("data", data);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		
		return mv;
	}
	
	/*
	 * 면수습 예정자 현황
	 */
	@RequestMapping(value="/getListBox210List.do", method=RequestMethod.POST )
	public ModelAndView getListBox210List(HttpSession session,
			@RequestParam Map<String, Object> paramMap) throws Exception{ 
		
		Map<String, Object> param = new HashMap<>();
		param.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		param.put("ssnLocaleCd", session.getAttribute("ssnLocaleCd"));

		Map<String, Object> probationStatus = new HashMap<>();
		Map<String, Object> data = new HashMap<>();

		String Message = "";

		try{
			probationStatus.put("data", mainService.getProbationStatus(param));
			data.put("probationStatus", probationStatus);

		}catch(Exception e){
			Message="위젯210를 불러 오지 못했습니다.";
		}
		
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("data", data);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		
		return mv;
	}
	
	/**
	 * 항목별 퇴사 비율
	 * Mock 데이터 작업
	 */
	@RequestMapping(value="/getListBox211List.do", method=RequestMethod.POST )
	public ModelAndView getListBox211List(HttpSession session, @RequestParam Map<String, Object> paramMap) throws Exception{    
	    Map<String, Object> param = new HashMap<>();
	    param.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
	    param.put("ssnSabun", session.getAttribute("ssnSabun"));
	    param.put("ssnLocaleCd", session.getAttribute("ssnLocaleCd"));
	    
	    Map<String, Object> leaveInfo = new HashMap<>();
	    Map<String, Object> data = new HashMap<>();
	    String Message = "";
	    
	    try {
//	    	leaveInfo.put("data", mainService.getLeaveInfo(param));
	    	
	    	/**
	    	 * 목데이터
			 [
			  {
			    "year": "2023",
			    "labels": ["1년 미만", "1년~3년", "3년~6년", "6년~10년", "10년 이상"],
			    "leaveCnts": [12, 28, 27, 23, 10]
			  },
			  {
			    "year": "2022",
			    "labels": ["1년 미만", "1년~3년", "3년~6년", "6년~10년", "10년 이상"],
			    "leaveCnts": [22, 38, 37, 33, 20]
			  }
			 ]
			 */
	    	List<Map<String, Object>> mapList = new ArrayList<>();
	    	
	    	Map<String, Object> yearMap1 = new HashMap<>();
	    	yearMap1.put("year", "2023");
	    	
	    	List<String> labels = new ArrayList<String>();
	    	labels.add("1년 미만");
	    	labels.add("1년~3년");
	    	labels.add("3년~6년");
	    	labels.add("6년~10년");
	    	labels.add("10년 이상");
	    	yearMap1.put("labels", labels);
	    	
	    	List<Integer> leaveCnts = new ArrayList<Integer>();
	    	leaveCnts.add(12);
	    	leaveCnts.add(28);
	    	leaveCnts.add(27);
	    	leaveCnts.add(23);
	    	leaveCnts.add(10);
	    	yearMap1.put("leaveCnts", leaveCnts);
	    	
	    	mapList.add(yearMap1);
	    	
	    	Map<String, Object> yearMap2 = new HashMap<>();
	    	yearMap2.put("year", "2022");
	    	yearMap2.put("labels", labels);
	    	
	    	List<Integer> leaveCnts2 = new ArrayList<Integer>();
	    	leaveCnts2.add(22);
	    	leaveCnts2.add(38);
	    	leaveCnts2.add(37);
	    	leaveCnts2.add(33);
	    	leaveCnts2.add(20);
	    	yearMap2.put("leaveCnts", leaveCnts2);
	    	
	    	mapList.add(yearMap2);
	      
//	      	Map<String, Object> yearMap2 = new HashMap<>();
//	      	yearMap2.put("year", "2022");
//	      	yearMap2.put("1년 미만", "22");
//	      	yearMap2.put("1년~3년", "38");
//	      	yearMap2.put("3년~6년", "37");
//	      	yearMap2.put("6년~10년", "33");
//	      	yearMap1.put("10년 이상", "20");
//	      	mapList.add(yearMap2);
	      
	    	leaveInfo.put("data", mapList);
	    	data.put("leaveInfo", leaveInfo);
	      
	    } catch(Exception e){
	      Message = "위젯211를 불러 오지 못했습니다.";
	    }
	    
	    ModelAndView mv = new ModelAndView();
	    mv.setViewName("jsonView");
	    mv.addObject("data", data);
	    mv.addObject("Message", Message);
	    Log.DebugEnd();
	    
	    return mv;
	}

	// 시간외 근무 사용현황
	@RequestMapping(value="/getListBox801List.do", method=RequestMethod.POST )
	public ModelAndView getListBox801List(HttpSession session,
			@RequestParam Map<String, Object> paramMap) throws Exception{ 
		
		Map<String, Object> param = new HashMap<>();
		param.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		param.put("ssnSabun", session.getAttribute("ssnSabun"));
		param.put("ssnLocaleCd", session.getAttribute("ssnLocaleCd"));
		
		Map<String, Object> overTimeUse = new HashMap<>();
		Map<String, Object> data = new HashMap<>();
		String Message = "";
	
		try{
			overTimeUse.put("data", mainService.getListOverTime(param));			
	
			data.put("overTimeUse", overTimeUse);
		}catch(Exception e){
			Message="위젯801를 불러 오지 못했습니다.";
		}
		
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("data", data);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		
		return mv;
	}
	
	// 연차 보상 비용 현황
	@RequestMapping(value="/getListBox802List.do", method=RequestMethod.POST )
	public ModelAndView getListBox802List(HttpSession session,
			@RequestParam Map<String, Object> paramMap) throws Exception{ 
		
		Map<String, Object> param = new HashMap<>();
		param.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		param.put("ssnSabun", session.getAttribute("ssnSabun"));
		param.put("ssnLocaleCd", session.getAttribute("ssnLocaleCd"));
		
		Map<String, Object> vacationLeaveCost = new HashMap<>();
		Map<String, Object> data = new HashMap<>();
		String Message = "";
	
		try{
			vacationLeaveCost.put("data", mainService.getVacationLeaveCost(param));			
	
			data.put("vacationLeaveCost", vacationLeaveCost);
		}catch(Exception e){
			Message="위젯802를 불러 오지 못했습니다.";
		}
		
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("data", data);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		
		return mv;
	}

	// 전사 근태 현황
	@RequestMapping(value="/getListBox803List.do", method=RequestMethod.POST )
	public ModelAndView getListBox803List(HttpSession session,
			@RequestParam Map<String, Object> paramMap) throws Exception{ 
		
		Map<String, Object> param = new HashMap<>();
		param.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		param.put("ssnSabun", session.getAttribute("ssnSabun"));
		param.put("ssnLocaleCd", session.getAttribute("ssnLocaleCd"));
		
		Map<String, Object> attendanceStatus = new HashMap<>();
		Map<String, Object> data = new HashMap<>();
		String Message = "";
	
		try{
			attendanceStatus.put("data", mainService.getAttendanceCnt(param));
			attendanceStatus.put("dataAllCnt", mainService.getAttendanceAllCnt(param));
			attendanceStatus.put("dataAllList", mainService.getAttendanceAllInfo(param));
			attendanceStatus.put("enterCd", session.getAttribute("ssnEnterCd"));

			data.put("attendanceStatus", attendanceStatus);
		}catch(Exception e){
			Message="위젯803를 불러 오지 못했습니다.";
		}
		
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("data", data);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		
		return mv;
	}
	
	/*
	 * 채용 현황 TODO 쿼리 적용 후 목데이터 수정 
	 */
	@RequestMapping(value="/getListBox804List.do", method=RequestMethod.POST )
	public ModelAndView getListBox804List(HttpSession session,
			@RequestParam Map<String, Object> paramMap) throws Exception{ 
		
		Map<String, Object> param = new HashMap<>();
		param.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		param.put("ssnSabun", session.getAttribute("ssnSabun"));
		param.put("ssnLocaleCd", session.getAttribute("ssnLocaleCd"));
		
		List<Map<String, Object>> userRank = new ArrayList<>();
		List<Map<String, Object>> orgRank = new ArrayList<>();
		Map<String, Object> data = new HashMap<>();
		String Message = "";
	
		try{
			/*목데이터*/
			for (int i = 0; i < 3; i++) {
		        Map<String, Object> newData = new HashMap<>();
		        newData.put("name", "이름" + i);
		        newData.put("orgNm", "조직" + i);
		        newData.put("sabun", "사번" + i);
		        newData.put("rank", (i+1));
		
		        userRank.add(newData);
		    }

			for (int i = 0; i < 3; i++) {
		        Map<String, Object> newData = new HashMap<>();
		        newData.put("orgNm", "조직" + i);
		        newData.put("time", "12시간 " + (i+30)+ "분");
		        newData.put("rank", (i+1));
		
		        orgRank.add(newData);
		    }
			
			data.put("enterCd", session.getAttribute("ssnEnterCd"));
			data.put("userRank", userRank);
			data.put("orgRank", orgRank);
		}catch(Exception e){
			Message="위젯804를 불러 오지 못했습니다.";
		}
		
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("data", data);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		
		return mv;
	}
	
	/*
	 * 간주 근로자 현황  TODO 쿼리 적용 후 목데이터 수정 
	 */
	@RequestMapping(value="/getListBox805List.do", method=RequestMethod.POST )
	public ModelAndView getListBox805List(HttpSession session,
			@RequestParam Map<String, Object> paramMap) throws Exception{ 
		
		Map<String, Object> param = new HashMap<>();
		param.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		param.put("ssnSabun", session.getAttribute("ssnSabun"));
		param.put("ssnLocaleCd", session.getAttribute("ssnLocaleCd"));
		
		List<Map<String, Object>> deemedWorkerData = new ArrayList<>();
		Map<String, Object> data = new HashMap<>();
		String Message = "";
	
		try{
			/* 목데이터 */
			for (int i = 0; i < 30; i++) {
			    Map<String, Object> newData = new HashMap<>();
			    
			    newData.put("name", "이름" + i);
			    newData.put("jikweeNm", "팀" + i);
			    newData.put("orgNm", "조직" + i);
			    newData.put("sabun", "사번" + i);

			    deemedWorkerData.add(newData);
			}

			data.put("enterCd", session.getAttribute("ssnEnterCd"));
			data.put("deemedWorkerData", deemedWorkerData);
		}catch(Exception e){
			Message="위젯805를 불러 오지 못했습니다.";
		}
		
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("data", data);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		
		return mv;
	}


	// 위젯812(부서근무현황)
	@RequestMapping(value="/getListBox807OrgList.do", method=RequestMethod.POST )
	public ModelAndView getListBox807OrgList(
			HttpSession session,
			@RequestParam Map<String, Object> paramMap) throws Exception {

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));
		paramMap.put("ssnLocaleCd", session.getAttribute("ssnLocaleCd"));
		paramMap.put("sabun", session.getAttribute("ssnSabun"));
		paramMap.put("ssnOrgCd", session.getAttribute("ssnOrgCd"));

		List<Map<String, Object>> list  = new ArrayList<>();

		String Message = "";

		try {
			list = mainService.getListBox807OrgList(paramMap);
		} catch(Exception e) {
			Message = "위젯807 조직 리스트를 불러 오지 못했습니다.";
			Log.Error(Message + " => " + e.getLocalizedMessage());
		}

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("data", list);
		mv.addObject("Message", Message);
		Log.DebugEnd();

		return mv;
	}
	
	/*
	 * 부서 근태 현황  TODO 쿼리 적용 후 목데이터 수정 
	 */
	@RequestMapping(value="/getListBox807List.do", method=RequestMethod.POST )
	public ModelAndView getListBox807List(HttpSession session,
			@RequestParam Map<String, Object> paramMap, @RequestParam(value = "option", required= false, defaultValue = "") String option) throws Exception {
		
		Map<String, Object> param = new HashMap<>();
		param.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		param.put("ssnSabun", session.getAttribute("ssnSabun"));
		param.put("ssnLocaleCd", session.getAttribute("ssnLocaleCd"));
		
		List<Map<String, Object>> teamWorkStatus = new ArrayList<>();
		Map<String, Object> data = new HashMap<>();
		String Message = "";
		String type = "";
	
		try {

			String searchOrgCd = (String) paramMap.get("searchOrgCd");
			if (searchOrgCd == null || searchOrgCd.isEmpty())
				throw new HrException("조회하려는 조직코드가 없습니다.");

			/* 목데이터 */
			for (int i = 0; i < 30; i++) {
				if (i < 10) {
					type = "재택근무";
				} else if (i > 9 && 20 > i) {
					type = "배우자출산";
				} else if (i > 19) {
					type = "연차";
				}

				Map<String, Object> newData = new HashMap<>();

				newData.put("name", "이름" + i);
				newData.put("jikweeNm", "팀장" + i);
				newData.put("orgNm", "sales0");
				newData.put("sabun", "사번" + i);
				newData.put("type", type);

				teamWorkStatus.add(newData);
			}

			data.put("enterCd", session.getAttribute("ssnEnterCd"));
			data.put("teamWorkStatus", teamWorkStatus);
		} catch (HrException e) {
			Message = e.getLocalizedMessage();
		} catch (Exception e) {
			Message="위젯807를 불러 오지 못했습니다.";
			Log.Error(Message + " => " + e.getLocalizedMessage());
		}
		
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("data", data);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		
		return mv;
	}
	
	/*
	 * 교대근무조 현황(직책자)  TODO 쿼리 적용 후 목데이터 수정 
	 */
	@RequestMapping(value="/getListBox808List.do", method=RequestMethod.POST )
	public ModelAndView getListBox808List(HttpSession session,
			@RequestParam Map<String, Object> paramMap, @RequestParam(value = "option", required= false, defaultValue = "") String option) throws Exception{ 
		
		Map<String, Object> param = new HashMap<>();
		param.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		param.put("ssnSabun", session.getAttribute("ssnSabun"));
		param.put("ssnLocaleCd", session.getAttribute("ssnLocaleCd"));

		List<Map<String, Object>> teamData = new ArrayList<>();
		List<Map<String, Object>> shiftWorkData = new ArrayList<>();
		Map<String, Object> data = new HashMap<>();
		String Message = "";

		try{
			/* 목데이터 */
			for (int i = 0; i < 3; i++) {
				Map<String, Object> newTeamData = new HashMap<>();
				
				newTeamData.put("orgCd", "b000"+i);
				newTeamData.put("orgNm", "sales"+i);
				
				teamData.add(newTeamData);
			}
			
			if (option.equals("") && !teamData.isEmpty()) {
			    Map<String, Object> firstTeam = teamData.get(0);

			    if (firstTeam.containsKey("orgCd")) {
			    	option = (String) firstTeam.get("orgCd");
			    }
			}

			if (option.equals("b0000")) {
				for (int i = 0; i < 7; i++) {
					Map<String, Object> newData = new HashMap<>();
					
					newData.put("shift", i+1);
					newData.put("sTime", "0"+ i +":00");
					newData.put("eTime", "0"+ (i+1) +":00");
					newData.put("shifrCnt", i);
					
					shiftWorkData.add(newData);
				}	
			}
			
			if (option.equals("b0001")) {
				for (int i = 0; i < 7; i++) {
					Map<String, Object> newData = new HashMap<>();
					
					newData.put("shift", i+1);
					newData.put("sTime", "0"+ (i+1) +":00");
					newData.put("eTime", "0"+ (i+2) +":00");
					newData.put("shifrCnt", i);
					
					shiftWorkData.add(newData);
				}	
			}
			
			if (option.equals("b0002")) {
				for (int i = 0; i < 7; i++) {
					Map<String, Object> newData = new HashMap<>();
					
					newData.put("shift", i+1);
					newData.put("sTime", "0"+ (i+3) +":00");
					newData.put("eTime", "0"+ (i+4) +":00");
					newData.put("shifrCnt", i);
					
					shiftWorkData.add(newData);
				}	
			}

			data.put("teamData", teamData);
			data.put("shiftWorkData", shiftWorkData);
		}catch(Exception e){
			Message="위젯808를 불러 오지 못했습니다.";
		}
		
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("data", data);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		
		return mv;
	}
	
	/*
	 * 탄력근로제 현황(직책자)  TODO 쿼리 적용 후 목데이터 수정 
	 */
	@RequestMapping(value="/getListBox809List.do", method=RequestMethod.POST )
	public ModelAndView getListBox809List(HttpSession session,
			@RequestParam Map<String, Object> paramMap, @RequestParam(value = "option", required= false, defaultValue = "") String option) throws Exception{ 
		
		Map<String, Object> param = new HashMap<>();
		param.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		param.put("ssnSabun", session.getAttribute("ssnSabun"));
		param.put("ssnLocaleCd", session.getAttribute("ssnLocaleCd"));
		
		List<Map<String, Object>> teamData = new ArrayList<>();
		List<Map<String, Object>> flexibleWorkData = new ArrayList<>();
		Map<String, Object> data = new HashMap<>();
		String Message = "";
	
		try{
			/* 목데이터 */
			for (int i = 0; i < 3; i++) {
				Map<String, Object> newTeamData = new HashMap<>();
				
				newTeamData.put("orgCd", "b000"+i);
				newTeamData.put("orgNm", "sales"+i);
				
				teamData.add(newTeamData);
			}
			
			if (option.equals("") && !teamData.isEmpty()) {
			    Map<String, Object> firstTeam = teamData.get(0);

			    if (firstTeam.containsKey("orgCd")) {
			    	option = (String) firstTeam.get("orgCd");
			    }
			}
			
			if (option.equals("b0000")) {
				for (int i = 0; i < 7; i++) {
					Map<String, Object> newData = new HashMap<>();
					
					newData.put("shift", i+1);
					newData.put("sTime", "0"+ i +":00");
					newData.put("eTime", "0"+ (i+1) +":00");
					newData.put("shifrCnt", i);
					
					flexibleWorkData.add(newData);
				}	
			}
			
			if (option.equals("b0001")) {
				for (int i = 0; i < 7; i++) {
					Map<String, Object> newData = new HashMap<>();
					
					newData.put("shift", i+1);
					newData.put("sTime", "0"+ (i+1) +":00");
					newData.put("eTime", "0"+ (i+2) +":00");
					newData.put("shifrCnt", i);
					
					flexibleWorkData.add(newData);
				}	
			}
			
			if (option.equals("b0002")) {
				for (int i = 0; i < 7; i++) {
					Map<String, Object> newData = new HashMap<>();
					
					newData.put("shift", i+1);
					newData.put("sTime", "0"+ (i+3) +":00");
					newData.put("eTime", "0"+ (i+4) +":00");
					newData.put("shifrCnt", i);
					
					flexibleWorkData.add(newData);
				}	
			}
	
			data.put("teamData", teamData);
			data.put("flexibleWorkData", flexibleWorkData);
		}catch(Exception e){
			Message="위젯809를 불러 오지 못했습니다.";
		}
		
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("data", data);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		
		return mv;
	}

	// 위젯810(휴가사용현황)
	@RequestMapping(value="/getListBox810Map.do", method=RequestMethod.POST )
	public ModelAndView getListBox810Map(HttpSession session,
										  @RequestParam Map<String, Object> paramMap, @RequestParam(value = "option", required= false, defaultValue = "position") String option) throws Exception{

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));
		paramMap.put("ssnLocaleCd", session.getAttribute("ssnLocaleCd"));
		paramMap.put("sabun", session.getAttribute("ssnSabun"));

        Map<String, Object> map = new HashMap<>();
        String Message = "";
        
        try{
            map = (Map<String, Object>) mainService.getListBox810Map(paramMap);
        }catch(Exception e){
            Message="위젯810를 불러 오지 못했습니다.";
        }
		
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("data", map);
		mv.addObject("Message", Message);
		Log.DebugEnd();

		return mv;
	}
	
	// 위젯811(휴가소진율)
	@RequestMapping(value="/getListBox811List.do", method=RequestMethod.POST )
	public ModelAndView getListBox811List(HttpSession session,
											 @RequestParam Map<String, Object> paramMap, @RequestParam(value = "option", required= false, defaultValue = "position") String option) throws Exception{

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));
		paramMap.put("ssnLocaleCd", session.getAttribute("ssnLocaleCd"));
		paramMap.put("sabun", session.getAttribute("ssnSabun"));
		paramMap.put("orgCd", session.getAttribute("ssnOrgCd"));

        List<?> list =new ArrayList<>();
        String Message = "";
        
        try{
        	list =  mainService.getListBox811List(paramMap);
        }catch(Exception e){
            Message="위젯811를 불러 오지 못했습니다.";
        }
		
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("data", list);
		mv.addObject("Message", Message);
		Log.DebugEnd();

		return mv;
	}
	
	
	// 위젯812(부서근무현황)
	@RequestMapping(value="/getListBox812OrgList.do", method=RequestMethod.POST )
	public ModelAndView getListBox812OrgList(HttpSession session,
											 @RequestParam Map<String, Object> paramMap, @RequestParam(value = "option", required= false, defaultValue = "position") String option) throws Exception{

        paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
        paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));
        paramMap.put("ssnLocaleCd", session.getAttribute("ssnLocaleCd"));
        paramMap.put("sabun", session.getAttribute("ssnSabun"));
        paramMap.put("ssnOrgCd", session.getAttribute("ssnOrgCd"));
        
        List<?> list  = new ArrayList<Object>();
        
        String Message = "";
        
        try{
        	list = mainService.getListBox812OrgList(paramMap);
        }catch(Exception e){
            Message="위젯812 조직 리스트를 불러 오지 못했습니다.";
        }

        ModelAndView mv = new ModelAndView();
        mv.setViewName("jsonView");
        mv.addObject("data", list);
        mv.addObject("Message", Message);
        Log.DebugEnd();

        return mv;
    }
	
	// 위젯812(부서근무현황)
	@RequestMapping(value="/getListBox812List.do", method=RequestMethod.POST )
	public ModelAndView getListBox812List(HttpSession session,
											 @RequestParam Map<String, Object> paramMap, @RequestParam(value = "option", required= false, defaultValue = "position") String option) throws Exception{

        paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
        paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));
        paramMap.put("ssnLocaleCd", session.getAttribute("ssnLocaleCd"));
        paramMap.put("sabun", session.getAttribute("ssnSabun"));
        paramMap.put("ssnOrgCd", session.getAttribute("ssnOrgCd"));
        
        
        Map<String, Object> data = new HashMap<>();
        List<?> list =new ArrayList<>();
        
        String Message = "";
        
        try{
        	list =  mainService.getListBox812List(paramMap);
        }catch(Exception e){
            Message="위젯812를 불러 오지 못했습니다.";
        }
 
        data.put("enterCd", session.getAttribute("ssnEnterCd"));
        data.put("teamWorkStatus", list);
        
        ModelAndView mv = new ModelAndView();
        mv.setViewName("jsonView");
        mv.addObject("data", data);
        mv.addObject("Message", Message);
        Log.DebugEnd();

        return mv;
    }
		
    // 조직장 근태 현황
    @RequestMapping(value="/getListBox813List.do", method=RequestMethod.POST )
    public ModelAndView getListBox813List(HttpSession session,
            @RequestParam Map<String, Object> paramMap) throws Exception{ 
        
        Map<String, Object> param = new HashMap<>();
        param.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
        param.put("ssnSabun", session.getAttribute("ssnSabun"));
        param.put("ssnLocaleCd", session.getAttribute("ssnLocaleCd"));
        
        Map<String, Object> attendanceStatus = new HashMap<>();
        Map<String, Object> data = new HashMap<>();
        String Message = "";
    
        try{
            attendanceStatus.put("data", mainService.getAttendanceLeaderRate(param));
            attendanceStatus.put("dataCnt", mainService.getAttendanceLeaderCnt(param));
            attendanceStatus.put("dataList", mainService.getAttendanceLeaderInfo(param));
            attendanceStatus.put("enterCd", session.getAttribute("ssnEnterCd"));

            data.put("attendanceStatus", attendanceStatus);
        }catch(Exception e){
            Message="위젯813를 불러 오지 못했습니다.";
        }
        
        ModelAndView mv = new ModelAndView();
        mv.setViewName("jsonView");
        mv.addObject("data", data);
        mv.addObject("Message", Message);
        Log.DebugEnd();
        
        return mv;
    }
    
    /*
     * 육아기 단축 근로자 현황  TODO 쿼리 적용 후 목데이터 수정 
     */
    @RequestMapping(value="/getListBox814List.do", method=RequestMethod.POST )
    public ModelAndView getListBox814List(HttpSession session,
            @RequestParam Map<String, Object> paramMap) throws Exception{ 
        
        Map<String, Object> param = new HashMap<>();
        param.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
        param.put("ssnSabun", session.getAttribute("ssnSabun"));
        param.put("ssnLocaleCd", session.getAttribute("ssnLocaleCd"));
        
        List<Map<String, Object>> deemedWorkerData = new ArrayList<>();
        Map<String, Object> data = new HashMap<>();
        String Message = "";
    
        try{
            /* 목데이터 */
            for (int i = 0; i < 30; i++) {
                Map<String, Object> newData = new HashMap<>();
                
                newData.put("name", "이름" + i);
                newData.put("jikweeNm", "팀" + i);
                newData.put("orgNm", "조직" + i);
                newData.put("sabun", "사번" + i);

                deemedWorkerData.add(newData);
            }

            data.put("enterCd", session.getAttribute("ssnEnterCd"));
            data.put("deemedWorkerData", deemedWorkerData);
        }catch(Exception e){
            Message="위젯814를 불러 오지 못했습니다.";
        }
        
        ModelAndView mv = new ModelAndView();
        mv.setViewName("jsonView");
        mv.addObject("data", data);
        mv.addObject("Message", Message);
        Log.DebugEnd();
        
        return mv;
    }
	/**
	 * 프로세스맵 리스트
	 * @param session
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/Plugin.do", params = "cmd=getProcessMapList")
	public ModelAndView getProcessMapList(HttpSession session,  HttpServletRequest request,
										@RequestParam(required = true) String mainMenuCd) throws Exception{
		Log.DebugStart();
		ModelAndView mv = new ModelAndView();
		Map<String,Object> processList = new HashMap();

		try{
			processList = processMapService.getProcessList(session,mainMenuCd);
			mv.addObject("status","SUCCESS");
		}catch(Exception e){
			Log.Debug(e.getMessage());
			Log.Debug(e.getStackTrace().toString());
			mv.addObject("status","FAIL");
		}

		mv.setViewName("jsonView");
		mv.addObject("procMapList", processList.get("procMapList"));

		Log.DebugEnd();
		return mv;
	}

	/**
	 * ESS MAIN 결재 정보 조회
	 * @param session
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/getMainEssAppl.do", method=RequestMethod.POST )
	public ModelAndView getMainEssAppl(HttpSession session,
										@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		Map<?, ?> map = null;
		String Message = "";
		try{
			map = mainService.getMainEssAppl(paramMap);
		}catch(Exception e){
			Message="getMainEssAppl 을 불러 오지 못했습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", map);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * ESS MAIN 근무 정보 조회
	 * @param session
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/getMainEssWorkTime.do", method=RequestMethod.POST )
	public ModelAndView getMainEssWorkTime(HttpSession session,
									   @RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		Map<?, ?> map = null;
		String Message = "";
		try{
			map = mainService.getMainEssWorkTime(paramMap);
		}catch(Exception e){
			Message="getMainEssWorkTime 을 불러 오지 못했습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", map);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 출근/퇴근 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(value="/prcMainEssWorkTime.do", method=RequestMethod.POST )
	public ModelAndView prcMainEssWorkTime(HttpSession session,
										  HttpServletRequest request,
										  @RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));
		paramMap.put("ip", InetAddress.getLocalHost().getHostAddress());

		String Message = "";
		Map<?, ?> map = null;
		Map<String, Object> resultMap = new HashMap<String, Object>();
		try{

			Log.Debug("IP : "+InetAddress.getLocalHost().getHostAddress());
			paramMap.put("ip", InetAddress.getLocalHost().getHostAddress());

			map = mainService.prcMainEssWorkTime(paramMap);

			Log.Debug("obj : "+map);

			if (map.get("sqlCode") != null) {
				resultMap.put("Code", map.get("sqlCode").toString());
			}
			if (map.get("sqlErrm") != null) {
				resultMap.put("Message", map.get("sqlErrm").toString());
			}
		}catch(Exception e) {
			resultMap.put("Code", "-999");
			resultMap.put("Message", "출/퇴근 처리 시 오류가 발생했습니다.");
		}

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", resultMap);

		Log.DebugEnd();
		return mv;
	}
	/**
	 * ESS MAIN 동료일정 조회
	 * @param session
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/getMainEssPsnlTime.do", method=RequestMethod.POST )
	public ModelAndView getMainEssPsnlTime(HttpSession session,
										   @RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		paramMap.put("ssnOrgCd", 	session.getAttribute("ssnOrgCd"));
		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = mainService.getMainEssPsnlTime(paramMap);
		}catch(Exception e){
			Message="getMainEssPsnlTime 을 불러 오지 못했습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}


	/**
	 * ESS MAIN 연간일정 조회
	 * @param session
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/getMainEssAnnualPlan.do", method=RequestMethod.POST )
	public ModelAndView getMainEssAnnualPlan(HttpSession session,
										   @RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		paramMap.put("ssnOrgCd", 	session.getAttribute("ssnOrgCd"));
		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = mainService.getMainEssAnnualPlan(paramMap);
		}catch(Exception e){
			Message="getMainEssAnnualPlan 을 불러 오지 못했습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * ESS MAIN 북마크 설정
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(value="/saveMainEssBookmark.do", method=RequestMethod.POST )
	public ModelAndView saveMainEssBookmark(HttpSession session,
										   HttpServletRequest request,
										   @RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));
		paramMap.put("ssnGrgCd", 	session.getAttribute("ssnGrgCd"));

		String message = "";
		int resultCnt = -1;
		try{
			resultCnt = mainService.saveMainEssBookmark(paramMap);
			if(resultCnt > 0){
				message="저장 되었습니다.";
			} else{
				message="저장된 내용이 없습니다.";
			}
		}catch(Exception e) {
			resultCnt = -1;
			message="저장에 실패하였습니다.";
		}

		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("Code", resultCnt);
		resultMap.put("Message", message);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Result", resultMap);
		Log.DebugEnd();
		return mv;
	}

    /**
     * 교육이수현황
     */
    @RequestMapping(value="/getListBox501List.do", method=RequestMethod.POST )
    public ModelAndView getListBox501List(HttpSession session,
                                          @RequestParam Map<String, Object> paramMap) {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));
		paramMap.put("ssnLocaleCd", session.getAttribute("ssnLocaleCd"));

		Map<?, ?> data = new HashMap<>();
        String Message = "";

        try{
			data = mainService.getListBox501EduInfo(paramMap);
        }catch(Exception e){
            Message="위젯501를 불러 오지 못했습니다.";
        }

        ModelAndView mv = new ModelAndView();
        mv.setViewName("jsonView");
        mv.addObject("data", data);
        mv.addObject("Message", Message);
        Log.DebugEnd();

        return mv;
    }

    /**
     * 교육이수시간
     */
    @RequestMapping(value="/getListBox502List.do", method=RequestMethod.POST )
    public ModelAndView getListBox502List(HttpSession session,
                                          @RequestParam Map<String, Object> paramMap) {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));
		paramMap.put("ssnLocaleCd", session.getAttribute("ssnLocaleCd"));

		Map<?, ?> data = new HashMap<>();
        String Message = "";

        try{
			data = mainService.getListBox502EduInfo(paramMap);
        }catch(Exception e){
            Message="위젯502를 불러 오지 못했습니다.";
        }

        ModelAndView mv = new ModelAndView();
        mv.setViewName("jsonView");
        mv.addObject("data", data);
        mv.addObject("Message", Message);
        Log.DebugEnd();

        return mv;
    }

    /**
     * 교육이수건수
     */
    @RequestMapping(value="/getListBox503List.do", method=RequestMethod.POST )
    public ModelAndView getListBox503List(HttpSession session,
                                          @RequestParam Map<String, Object> paramMap) {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));
		paramMap.put("ssnLocaleCd", session.getAttribute("ssnLocaleCd"));

		Map<?, ?> data = new HashMap<>();
		String Message = "";

		try{
			data = mainService.getListBox503EduInfo(paramMap);
		}catch(Exception e){
			Message="위젯503를 불러 오지 못했습니다.";
		}

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("data", data);
		mv.addObject("Message", Message);
		Log.DebugEnd();

        return mv;
    }

    /**
     * 교육이수시간순위
     */
    @RequestMapping(value="/getListBox504List.do", method=RequestMethod.POST )
    public ModelAndView getListBox504List(HttpSession session,
                                          @RequestParam Map<String, Object> paramMap) {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));
		paramMap.put("ssnLocaleCd", session.getAttribute("ssnLocaleCd"));

		Map<String, Object> data = new HashMap<>();
        String Message = "";

        try{
            data.put("userRank", mainService.getListBox504EduUserList(paramMap));
            data.put("orgRank", mainService.getListBox504EduOrgList(paramMap));
        }catch(Exception e){
            Message="위젯504를 불러 오지 못했습니다.";
        }

        ModelAndView mv = new ModelAndView();
        mv.setViewName("jsonView");
        mv.addObject("data", data);
        mv.addObject("Message", Message);
        Log.DebugEnd();

        return mv;
    }

	/**
	 * ESS MAIN CEO 인원현황 조회
	 * @param session
	 * @param paramMap
	 * @return
	 * @throws Exception
	*/
	@RequestMapping(value="/getMainEssCeoEmpCnt.do", method=RequestMethod.POST )
	public ModelAndView getMainEssCeoEmpCnt(HttpSession session,
										   @RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = mainService.getMainEssCeoEmpCnt(paramMap);
		}catch(Exception e){
			Message="getMainEssCeoEmpCnt 을 불러 오지 못했습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * ESS MAIN CEO 퇴직현황 조회
	 */
	@RequestMapping(value="/getMainEssCeoRetireInfo.do", method=RequestMethod.POST )
	public ModelAndView getMainEssCeoRetireInfo(HttpSession session,
										  @RequestParam Map<String, Object> paramMap) {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));
		paramMap.put("ssnLocaleCd", session.getAttribute("ssnLocaleCd"));

		Map<?, ?> data = new HashMap<>();
		String Message = "";

		try{
			data = mainService.getMainEssCeoRetireInfo(paramMap);
		}catch(Exception e){
			Message="getMainEssCeoRetireInfo 을 불러 오지 못했습니다.";
		}

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", data);
		mv.addObject("Message", Message);
		Log.DebugEnd();

		return mv;
	}

	/**
	 * ESS MAIN CEO 신규입사자 조회
	 * @param session
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/getMainEssCeoNewEmployee.do", method=RequestMethod.POST )
	public ModelAndView getMainEssCeoNewEmployee(HttpSession session,
											@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = mainService.getMainEssCeoNewEmployee(paramMap);
		}catch(Exception e){
			Message="getMainEssCeoNewEmployee 을 불러 오지 못했습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * ESS MAIN CEO 핵심인재 조회
	 * @param session
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/getMainEssCeoCoreEmployee.do", method=RequestMethod.POST )
	public ModelAndView getMainEssCeoCoreEmployee(HttpSession session,
												 @RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = mainService.getMainEssCeoCoreEmployee(paramMap);
		}catch(Exception e){
			Message="getMainEssCeoCoreEmployee 을 불러 오지 못했습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * ESS MAIN CEO 인원현황 차트(연령별) 조회
	 * @param session
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/getMainEssCeoPsnlStatus1.do", method=RequestMethod.POST )
	public ModelAndView getMainEssCeoPsnlStatus1(HttpSession session,
												 @RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = mainService.getMainEssCeoPsnlStatus1(paramMap);
		}catch(Exception e){
			Message="getMainEssCeoPsnlStatus1 을 불러 오지 못했습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * ESS MAIN CEO 인원현황 차트(근무지별) 조회
	 * @param session
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/getMainEssCeoPsnlStatus2.do", method=RequestMethod.POST )
	public ModelAndView getMainEssCeoPsnlStatus2(HttpSession session,
												 @RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = mainService.getMainEssCeoPsnlStatus2(paramMap);
		}catch(Exception e){
			Message="getMainEssCeoPsnlStatus2 을 불러 오지 못했습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * ESS MAIN CEO 인원현황 차트(직군별) 조회
	 * @param session
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/getMainEssCeoPsnlStatus3.do", method=RequestMethod.POST )
	public ModelAndView getMainEssCeoPsnlStatus3(HttpSession session,
												 @RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = mainService.getMainEssCeoPsnlStatus3(paramMap);
		}catch(Exception e){
			Message="getMainEssCeoPsnlStatus3 을 불러 오지 못했습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * ESS MAIN CEO 인원현황 차트(평가별) 조회
	 * @param session
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/getMainEssCeoPsnlStatus4.do", method=RequestMethod.POST )
	public ModelAndView getMainEssCeoPsnlStatus4(HttpSession session,
												 @RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = mainService.getMainEssCeoPsnlStatus4(paramMap);
		}catch(Exception e){
			Message="getMainEssCeoPsnlStatus4 을 불러 오지 못했습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * ESS MAIN CEO 임원현황 조회
	 * @param session
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/getMainEssCeoExecMemList.do", method=RequestMethod.POST )
	public ModelAndView getMainEssCeoExecMemList(HttpSession session,
												 @RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = mainService.getMainEssCeoExecMemList(paramMap);
		}catch(Exception e){
			Message="getMainEssCeoExecMemList 을 불러 오지 못했습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * ESS MAIN CEO 팀장현황 조회
	 * @param session
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/getMainEssCeoLeaderMemList.do", method=RequestMethod.POST )
	public ModelAndView getMainEssCeoLeaderMemList(HttpSession session,
												 @RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = mainService.getMainEssCeoLeaderMemList(paramMap);
		}catch(Exception e){
			Message="getMainEssCeoLeaderMemList 을 불러 오지 못했습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * ESS MAIN CEO 전직원 조회
	 * @param session
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/getMainEssCeoAllMemList.do", method=RequestMethod.POST )
	public ModelAndView getMainEssCeoAllMemList(HttpSession session,
												 @RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = mainService.getMainEssCeoAllMemList(paramMap);
		}catch(Exception e){
			Message="getMainEssCeoAllMemList 을 불러 오지 못했습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * ESS MAIN CEO 지각자 조회
	 * @param session
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/getMainEssCeoLateMemList.do", method=RequestMethod.POST )
	public ModelAndView getMainEssCeoLateMemList(HttpSession session,
												 @RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = mainService.getMainEssCeoLateMemList(paramMap);
		}catch(Exception e){
			Message="getMainEssCeoLateMemList 을 불러 오지 못했습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * ESS MAIN CHIEF 팀원 연차 현황 조회
	 * @param session
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/getMainEssChiefVacationList.do", method=RequestMethod.POST )
	public ModelAndView getMainEssChiefVacationList(HttpSession session,
												 @RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		paramMap.put("ssnOrgCd", 	session.getAttribute("ssnOrgCd"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = mainService.getMainEssChiefVacationList(paramMap);
		}catch(Exception e){
			Message="getMainEssChiefVacationList 을 불러 오지 못했습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * ESS MAIN CHIEF 연차 현황 차트 조회
	 * @param session
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/getMainEssChiefVacationChart.do", method=RequestMethod.POST )
	public ModelAndView getMainEssChiefVacationChart(HttpSession session,
													@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		paramMap.put("ssnOrgCd", 	session.getAttribute("ssnOrgCd"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = mainService.getMainEssChiefVacationChart(paramMap);
		}catch(Exception e){
			Message="getMainEssChiefVacationChart 을 불러 오지 못했습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * ESS MAIN CHIEF 초과근무 현황 차트 조회
	 * @param session
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/getMainEssChiefOtChart.do", method=RequestMethod.POST )
	public ModelAndView getMainEssChiefOtChart(HttpSession session,
													 @RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		paramMap.put("ssnOrgCd", 	session.getAttribute("ssnOrgCd"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = mainService.getMainEssChiefOtChart(paramMap);
		}catch(Exception e){
			Message="getMainEssChiefOtChart 을 불러 오지 못했습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * ESS MAIN CHIEF 팀 교육현황 현황 차트 조회
	 * @param session
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/getMainEssChiefEduChart.do", method=RequestMethod.POST )
	public ModelAndView getMainEssChiefEduChart(HttpSession session,
											   @RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		paramMap.put("ssnOrgCd", 	session.getAttribute("ssnOrgCd"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = mainService.getMainEssChiefEduChart(paramMap);
		}catch(Exception e){
			Message="getMainEssChiefEduChart 을 불러 오지 못했습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * ESS MAIN CHIEF 결재현황 조회
	 * @param session
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/getMainEssChiefApplList.do", method=RequestMethod.POST )
	public ModelAndView getMainEssChiefApplList(HttpSession session,
												@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		paramMap.put("ssnOrgCd", 	session.getAttribute("ssnOrgCd"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = mainService.getMainEssChiefApplList(paramMap);
		}catch(Exception e){
			Message="getMainEssChiefApplList 을 불러 오지 못했습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * ESS MAIN CHIEF 팀원 근무 정보 조회
	 * @param session
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/getMainEssChiefWorkEmp.do", method=RequestMethod.POST )
	public ModelAndView getMainEssChiefWorkEmp(HttpSession session,
										   @RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		paramMap.put("ssnOrgCd", 	session.getAttribute("ssnOrgCd"));

		Map<?, ?> map = null;
		String Message = "";
		try{
			map = mainService.getMainEssChiefWorkEmp(paramMap);
		}catch(Exception e){
			Message="getMainEssChiefWorkEmp 을 불러 오지 못했습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", map);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}
	
	@RequestMapping(value="/list09.do", params = "cmd=viewList901Layer")
	public String viewList901Layer() {
		return "/main/main/widgets/09/list901Layer";
	}
	@RequestMapping(value="/list09.do", params = "cmd=viewList902Layer")
	public String viewList902Layer() {
		return "/main/main/widgets/09/list902Layer";
	}
	@RequestMapping(value="/list09.do", params = "cmd=viewList903Layer")
	public String viewList903Layer() {
		return "/main/main/widgets/09/list903Layer";
	}
	@RequestMapping(value="/list09.do", params = "cmd=viewList904Layer")
	public String viewList904Layer() { return "/main/main/widgets/09/list904Layer"; }
	@RequestMapping(value="/list09.do", params = "cmd=viewList905Layer")
	public String viewList905Layer() {
		return "/main/main/widgets/09/list905Layer";
	}
	@RequestMapping(value="/list09.do", params = "cmd=viewList906Layer")
	public String viewList906Layer() {
		return "/main/main/widgets/09/list906Layer";
	}

	/* PSNM용 복리후생 위젯 상세 */
	@RequestMapping(value="/list09.do", params = "cmd=viewRed01")
	public String viewRed01() {
		return "/main/main/widgets/09/psnm/red_01";
	}
	
	@RequestMapping(value="/list09.do", params = "cmd=viewRed02")
	public String viewRed02() {
		return "/main/main/widgets/09/psnm/red_02";
	}
	
	@RequestMapping(value="/list09.do", params = "cmd=viewRed03")
	public String viewRed03() {
		return "/main/main/widgets/09/psnm/red_03";
	}
	
	@RequestMapping(value="/list09.do", params = "cmd=viewRed04")
	public String viewRed04() {
		return "/main/main/widgets/09/psnm/red_04";
	}
	
	@RequestMapping(value="/list09.do", params = "cmd=viewRed05")
	public String viewRed05() {
		return "/main/main/widgets/09/psnm/red_05";
	}
	
	@RequestMapping(value="/list09.do", params = "cmd=viewRed06")
	public String viewRed06() {
		return "/main/main/widgets/09/psnm/red_06";
	}
	
	@RequestMapping(value="/list09.do", params = "cmd=viewRed07")
	public String viewRed07() {
		return "/main/main/widgets/09/psnm/red_07";
	}
	
	@RequestMapping(value="/list09.do", params = "cmd=viewRed08")
	public String viewRed08() {
		return "/main/main/widgets/09/psnm/red_08";
	}
	
	@RequestMapping(value="/list09.do", params = "cmd=viewRed09")
	public String viewRed09() {
		return "/main/main/widgets/09/psnm/red_09";
	}
	
	@RequestMapping(value="/list09.do", params = "cmd=viewBlue01")
	public String viewBlue01() {
		return "/main/main/widgets/09/psnm/blue_01";
	}
	
	@RequestMapping(value="/list09.do", params = "cmd=viewBlue02")
	public String viewBlue02() {
		return "/main/main/widgets/09/psnm/blue_02";
	}
	
	@RequestMapping(value="/list09.do", params = "cmd=viewBlue03")
	public String viewBlue03() {
		return "/main/main/widgets/09/psnm/blue_03";
	}
	
	@RequestMapping(value="/list09.do", params = "cmd=viewBlue04")
	public String viewBlue04() {
		return "/main/main/widgets/09/psnm/blue_04";
	}
	
	@RequestMapping(value="/list09.do", params = "cmd=viewBlue05")
	public String viewBlue05() {
		return "/main/main/widgets/09/psnm/blue_05";
	}
	
	@RequestMapping(value="/list09.do", params = "cmd=viewBlue06")
	public String viewBlue06() {
		return "/main/main/widgets/09/psnm/blue_06";
	}
	
	@RequestMapping(value="/list09.do", params = "cmd=viewBlue07")
	public String viewBlue07() {
		return "/main/main/widgets/09/psnm/blue_07";
	}
	
	@RequestMapping(value="/list09.do", params = "cmd=viewBlue08")
	public String viewBlue08() {
		return "/main/main/widgets/09/psnm/blue_08";
	}
	
	@RequestMapping(value="/list09.do", params = "cmd=viewYellow01")
	public String viewYellow01() {
		return "/main/main/widgets/09/psnm/yellow_01";
	}
	
	@RequestMapping(value="/list09.do", params = "cmd=viewYellow02")
	public String viewYellow02() {
		return "/main/main/widgets/09/psnm/yellow_02";
	}
	
	@RequestMapping(value="/list09.do", params = "cmd=viewYellow03")
	public String viewYellow03() {
		return "/main/main/widgets/09/psnm/yellow_03";
	}
	
	@RequestMapping(value="/list09.do", params = "cmd=viewYellow04")
	public String viewYellow04() {
		return "/main/main/widgets/09/psnm/yellow_04";
	}
	
	@RequestMapping(value="/list09.do", params = "cmd=viewYellow05")
	public String viewYellow05() {
		return "/main/main/widgets/09/psnm/yellow_05";
	}
	
	@RequestMapping(value="/list09.do", params = "cmd=viewYellow06")
	public String viewYellow06() {
		return "/main/main/widgets/09/psnm/yellow_06";
	}
	
	@RequestMapping(value="/list09.do", params = "cmd=viewYellow07")
	public String viewYellow07() {
		return "/main/main/widgets/09/psnm/yellow_07";
	}
	
	@RequestMapping(value="/list09.do", params = "cmd=viewYellow08")
	public String viewYellow08() {
		return "/main/main/widgets/09/psnm/yellow_08";
	}
	
	@RequestMapping(value="/list09.do", params = "cmd=viewOlive01")
	public String viewOlive01() {
		return "/main/main/widgets/09/psnm/olive_01";
	}
	
	@RequestMapping(value="/list09.do", params = "cmd=viewOlive02")
	public String viewOlive02() {
		return "/main/main/widgets/09/psnm/olive_02";
	}
	
	@RequestMapping(value="/list09.do", params = "cmd=viewOlive03")
	public String viewOlive03() {
		return "/main/main/widgets/09/psnm/olive_03";
	}
	
	@RequestMapping(value="/list09.do", params = "cmd=viewOlive04")
	public String viewOlive04() {
		return "/main/main/widgets/09/psnm/olive_04";
	}
	
	@RequestMapping(value="/list09.do", params = "cmd=viewOlive05")
	public String viewOlive05() {
		return "/main/main/widgets/09/psnm/olive_05";
	}
	
	
	@RequestMapping(value="/list09.do", params = "cmd=viewOlive06")
	public String viewOlive06() {
		return "/main/main/widgets/09/psnm/olive_06";
	}




	@RequestMapping(value="/viewHelpLayer.do")
	public String viewHelpLayer() {
		return "/common/include/helpLayer";
	}
}