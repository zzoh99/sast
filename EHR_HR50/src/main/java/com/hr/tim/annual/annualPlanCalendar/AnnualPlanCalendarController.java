package com.hr.tim.annual.annualPlanCalendar;
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
 * 조직원연차계획현황 Controller
 *
 * @author EW
 *
 */
@Controller
@RequestMapping(value="/AnnualPlanCalendar.do", method=RequestMethod.POST )
public class AnnualPlanCalendarController extends ComController {
	/**
	 * 조직원연차계획현황 서비스
	 */
	@Inject
	@Named("AnnualPlanCalendarService")
	private AnnualPlanCalendarService annualPlanCalendarService;

	/**
	 * 조직원연차계획현황 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewAnnualPlanCalendar", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewAnnualPlanCalendar() throws Exception {
		return "tim/annual/annualPlanCalendar/annualPlanCalendar";
	}

	/**
	 * 조직원연차계획현황 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAnnualPlanCalendarList", method = RequestMethod.POST )
	public ModelAndView getAnnualPlanCalendarList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}

	/**
	 * 조직원연차계획현황 조직콤보 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAnnualPlanCalendarOrgList", method = RequestMethod.POST )
	public ModelAndView getAnnualPlanCalendarOrgList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}


}
