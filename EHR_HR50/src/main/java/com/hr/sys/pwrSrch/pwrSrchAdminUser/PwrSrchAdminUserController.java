package com.hr.sys.pwrSrch.pwrSrchAdminUser;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.hr.common.logger.Log;
import com.hr.common.security.SecurityMgrService;
import com.hr.common.util.ParamUtils;
import com.hr.common.util.QueryUtil;
 
/**
 * 조건검색
 * 
 * @author ParkMoohun
 */
@Controller
@RequestMapping(value="/PwrSrchAdminUser.do", method=RequestMethod.POST ) 
public class PwrSrchAdminUserController {

	@Inject
	@Named("PwrSrchAdminUserService")
	private PwrSrchAdminUserService pwrSrchAdminUserService;
	
	@Inject
	@Named("SecurityMgrService")
	private SecurityMgrService securityMgrService;
	

	/**
	 * 조건검색 화면
	 * 
	 * @param paramMap
	 * @param request
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewPwrSrchAdminUser", method = {RequestMethod.POST, RequestMethod.GET} )
	public ModelAndView viewPwrSrchAdminUser(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {

		Log.DebugStart();

		Map<String, Object> urlParam = new HashMap<String, Object>();
		String surl =paramMap.get("surl").toString();
		String skey = session.getAttribute("ssnEncodedKey").toString();

		urlParam = (Map<String, Object>) securityMgrService.getDecryptUrl( surl, skey  );

		ModelAndView mv = new ModelAndView();

		mv.setViewName("sys/pwrSrch/pwrSrchAdminUser/pwrSrchAdminUser");
		mv.addObject("result", urlParam);
		return mv;		
	}

	/**  
	 * 조건검색 상세 내용 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception`
	 */
	@RequestMapping(params="cmd=getPwrSrchAdminUserDetailDescMap", method = RequestMethod.POST )
	public ModelAndView getPwrSrchAdminUserDetailDescMap(HttpSession session,
			HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		
		Map result = pwrSrchAdminUserService.getPwrSrchAdminUserDetailDescMap(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", result);
		Log.DebugEnd();
		return mv;
	}
	
	/**  
	 * 조건검색 시트1 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPwrSrchAdminUserSht1List", method = RequestMethod.POST )
	public ModelAndView getPwrSrchAdminUserSht1List(HttpSession session,
			HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		paramMap = ParamUtils.converterParams(request);
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		
		List<?> result = pwrSrchAdminUserService.getPwrSrchAdminUserSht1List(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", result);
		Log.DebugEnd();
		return mv;
	}
	
	/**  
	 * 조건검색 시트2 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPwrSrchAdminUserSht2List", method = RequestMethod.POST )
	public ModelAndView getPwrSrchAdminUserSht2List(HttpSession session,
			HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		paramMap = ParamUtils.converterParams(request);
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		
		List<?> result = pwrSrchAdminUserService.getPwrSrchAdminUserSht2List(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", result);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 조건검색 저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=savePwrSrchAdminUser", method = RequestMethod.POST )
	public ModelAndView savePwrSrchAdminUser(HttpSession session,
			HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		convertMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		convertMap.put("ssnSabun", session.getAttribute("ssnSabun"));

		int result = pwrSrchAdminUserService.savePwrSrchAdminUser(convertMap);
		
		String message = "";
		if (result > 0) { 	message = "저장되었습니다."; } 
		else {			message = "저장 실퍠 하였습니다."; }
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("Code", result);
		resultMap.put("Message", message);
		
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Result", resultMap);

		Log.Debug("Result Message : " + mv);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 조건검색 화면
	 * 
	 * @param paramMap
	 * @param request
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=pwrSrchAdminUserPopup", method = RequestMethod.POST )
	public ModelAndView pwrSrchAdminUserPopup(HttpSession session,
			@RequestParam Map<String, Object> paramMap,
			HttpServletRequest request) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		
		String editFlag     = request.getParameter("_editFlag") == null ? "FALSE" : request.getParameter("_editFlag");
		String adminFlag     = request.getParameter("adminFlag") == "no" ? "FALSE" : request.getParameter("adminFlag");
		
		ModelAndView mv = new ModelAndView();
		mv.addObject("editFlag", editFlag);
		mv.addObject("adminFlag", adminFlag);
		mv.setViewName("common/popup/pwrSrchInputValuePopup");
		Log.DebugEnd();
		return mv;
	}
	
	/**
	 * 조건검색 저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=updatePwrSrchAdminUserSyntax", method = RequestMethod.POST )
	public ModelAndView updatePwrSrchAdminUserSyntax(HttpSession session,
			HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		// List result = sysPwrSchViewService.getPwrSch(paramMap);
		// 열로 된 데이터들을 Map 형태의 연관된 데이터 셋으로 만들기 위해
		// 같이 묶여질 param명을 ,구분자 포함하여 만든다.
		paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		paramMap.put("srchSeq", 	paramMap.get("srchSeq") );
		paramMap.put("adminSqlSyntax",	paramMap.get("adminSqlSyntax") );
		paramMap.put("conditionDesc",	paramMap.get("conditionDesc") );
		int result = pwrSrchAdminUserService.updatePwrSrchAdminUserSyntax(paramMap);
		String message = "";
		if (result > 0) { 	message = "저장되었습니다."; } 
		else {				message = "저장 실퍠 하였습니다."; }
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("message", message);
		Log.DebugEnd();
		return mv;
	}
	
	/**
	 * 조건검색 저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=testQuery", method = RequestMethod.POST )
	public void testQuery(HttpSession session,
			HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		String ssnEnterCd 	= session.getAttribute("ssnEnterCd").toString();
		String ssnSabun 	= session.getAttribute("ssnSabun").toString(); 
		String ssnSearchType	= session.getAttribute("ssnSearchType").toString();
		String ssnGrpCd		= session.getAttribute("ssnGrpCd").toString();
		String ssnBaseDate	= session.getAttribute("ssnBaseDate").toString();
		String result = pwrSrchAdminUserService.getQueryInfo(paramMap);
		result = result.replaceAll(":ssnBaseDate", 	"'"+ssnBaseDate+"'");
		result = result.replaceAll(":ssnEnterCd", 	"'"+ssnEnterCd+"'");
		result = result.replaceAll(":ssnSabun", 	"'"+ssnSabun+"'");
		result = result.replaceAll(":ssnGrpCd", 	"'"+ssnGrpCd+"'");
		result = result.replaceAll(":ssnBaseDate", 	"'"+ssnBaseDate+"'");
		
		paramMap.put("ssnEnterCd", 	ssnEnterCd);
		paramMap.put("ssnSabun", 	ssnSabun);
		paramMap.put("ssnSearchType", 	ssnSearchType);
		paramMap.put("ssnGrpCd", 	ssnGrpCd);
		paramMap.put("ssnBaseDate", 	ssnBaseDate);
		Log.Debug( "############################################\n"+QueryUtil.queryForceHandle(pwrSrchAdminUserService.getQueryInfo(paramMap),paramMap) );
		
		//Log.Debug("resultresultresultresult \n"+result);
		Log.DebugEnd();
	}
}