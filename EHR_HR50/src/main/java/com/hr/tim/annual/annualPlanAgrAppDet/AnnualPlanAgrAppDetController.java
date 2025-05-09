package com.hr.tim.annual.annualPlanAgrAppDet;
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
 * 휴가계획신청 세부내역 Controller
 *
 * @author
 *
 */
@Controller
@RequestMapping({"/AnnualPlanAgrAppDet.do", "/AnnualPlanAgrApp.do"})
public class AnnualPlanAgrAppDetController  extends ComController {

	/**
	 * 휴가계획신청 세부내역 서비스
	 */
	@Inject
	@Named("AnnualPlanAgrAppDetService")
	private AnnualPlanAgrAppDetService annualPlanAgrAppDetService;


	/**
	 * 연차촉진 세부내역 View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewAnnualPlanAgrAppDet", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewAnnualPlanAgrStd() throws Exception {
		return "tim/annual/annualPlanAgrAppDet/annualPlanAgrAppDet";
	}
	

	/**
	 * 연차촉진 세부내역 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAnnualPlanAgrAppDetMap", method = RequestMethod.POST )
	public ModelAndView getAnnualPlanAgrAppDetMap(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataMap(session, request, paramMap);
	}
	

	/**
	 * 연차촉진 세부내역 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAnnualPlanAgrAppDetList", method = RequestMethod.POST )
	public ModelAndView getAnnualPlanAgrAppDetList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}


	/**
	 * 연차촉진 세부내역 휴일 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAnnualPlanAgrAppDetHolidayCnt", method = RequestMethod.POST )
	public ModelAndView getAnnualPlanAgrAppDetHolidayCnt(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataMap(session, request, paramMap);
	}
	
	
	
	
	/**
	 * 휴가계획신청팝업 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveAnnualPlanAgrAppDet", method = RequestMethod.POST )
	public ModelAndView saveAnnualPlanAgrAppDet(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();
		return saveData(session, request, paramMap);
	}

}