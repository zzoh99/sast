package com.hr.tra.yearEduPlan.yearEduOrgAppDet;

import java.util.ArrayList;
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

import com.hr.common.com.ComController;
import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;

/**
 * YearEduOrgAppDet Controller
 */
@Controller
@RequestMapping({"/YearEduOrgApp.do","/YearEduOrgAppDet.do"})
public class YearEduOrgAppDetController extends ComController {

	/**
	 * YearEduOrgAppDet 서비스
	 */
	@Inject
	@Named("YearEduOrgAppDetService")
	private YearEduOrgAppDetService yearEduOrgAppDetService;

	/**
	 * YearEduOrgAppDet View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewYearEduOrgAppDet", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewYearEduOrgAppDet() throws Exception {
		return "tra/yearEduPlan/yearEduOrgAppDet/yearEduOrgAppDet";
	}
	
	/**
	 * YearEduOrgAppDet 단건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getYearEduOrgAppDetMap", method = RequestMethod.POST )
	public ModelAndView getYearEduOrgAppDetMap(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataMap(session, request, paramMap);
	}

	/**
	 * YearEduOrgAppDet 중복 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getYearEduOrgAppDetDupChk", method = RequestMethod.POST )
	public ModelAndView getYearEduOrgAppDetDupChk(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataMap(session, request, paramMap);
	}
	
	/**
	 * 부서명 본부명 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getYearEduOrgAppDetOrgMap", method = RequestMethod.POST )
	public ModelAndView getYearEduOrgAppDetOrgMap(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataMap(session, request, paramMap);
	}
	
	/**
	 * 시트 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getYearEduOrgAppDetaAppInfo", method = RequestMethod.POST )
	public ModelAndView getYearEduOrgAppDetaAppInfo(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}
	

	/**
	 * YearEduOrgAppDet 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveYearEduOrgAppDet", method = RequestMethod.POST )
	public ModelAndView saveYearEduOrgAppDet(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return saveData(session, request, paramMap);
	}
	
}
