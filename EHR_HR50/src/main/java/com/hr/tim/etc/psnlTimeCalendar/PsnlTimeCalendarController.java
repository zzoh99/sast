package com.hr.tim.etc.psnlTimeCalendar;
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
 * 조직원근태현황 Controller
 *
 * @author EW
 *
 */
@Controller
@RequestMapping(value="/PsnlTimeCalendar.do", method=RequestMethod.POST )
public class PsnlTimeCalendarController extends ComController {
	/**
	 * 조직원근태현황 서비스
	 */
	@Inject
	@Named("PsnlTimeCalendarService")
	private PsnlTimeCalendarService psnlTimeCalendarService;

	/**
	 * 조직원근태현황 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewPsnlTimeCalendar", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewPsnlTimeCalendar() throws Exception {
		return "tim/etc/psnlTimeCalendar/psnlTimeCalendar";
	}

	/**
	 * 조직원근태현황 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPsnlTimeCalendarList", method = RequestMethod.POST )
	public ModelAndView getPsnlTimeCalendarList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}

	/**
	 * 조직원근태현황 조직콤보 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPsnlTimeCalendarOrgList", method = RequestMethod.POST )
	public ModelAndView getPsnlTimeCalendarOrgList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}


}
