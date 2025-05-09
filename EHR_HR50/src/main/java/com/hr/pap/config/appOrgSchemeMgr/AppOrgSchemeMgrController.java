package com.hr.pap.config.appOrgSchemeMgr;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.hr.common.com.ComController;
import com.hr.common.logger.Log;

/**
 * 평가조직관리 Controller
 * @author gjyoo
 *
 */
@Controller
@RequestMapping(value="/AppOrgSchemeMgr.do", method=RequestMethod.POST )
public class AppOrgSchemeMgrController extends ComController {

	
	/**
	 * 평가조직관리 View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewAppOrgSchemeMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewAppOrgSchemeMgr() throws Exception {
		return "pap/config/appOrgSchemeMgr/appOrgSchemeMgr";
	}
	
	/**
	 * 평가조직관리 > 팝업 View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewAppOrgCopyPop", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewAppOrgCopyPop() throws Exception {
		return "pap/config/appOrgSchemeMgr/appOrgCopyPop";
	}

	/**
	 * 평가조직관리 > 레이어 팝업 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewAppOrgCopyLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewAppOrgCopyLayer() throws Exception {
		return "pap/config/appOrgSchemeMgr/appOrgCopyLayer";
	}

	/**
	 * 평가조직관리 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAppOrgSchemeMgrList", method = RequestMethod.POST )
	public ModelAndView getAppOrgSchemeMgrList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}

	/**
	 * 평가조직관리 저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveAppOrgSchemeMgr", method = RequestMethod.POST )
	public ModelAndView saveAppOrgSchemeMgr(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return saveData(session, request, paramMap);
	}

	/**
	 * 평가조직관리 > 조직도복사 - 프로시저 호출
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=prcAppOrgSchemeCopy", method = RequestMethod.POST )
	public ModelAndView prcAppOrgSchemeCopy(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();  
		return execPrc(session, request, paramMap);
	}
	/**
	 * 평가일정관리에 평가배분유형 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAppOrgSchemeTypeInfo", method = RequestMethod.POST )
	public ModelAndView getAppOrgSchemeTypeInfo(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataMap(session, request, paramMap);
	}
}
