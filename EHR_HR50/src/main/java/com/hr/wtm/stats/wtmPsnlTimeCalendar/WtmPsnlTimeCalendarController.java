package com.hr.wtm.stats.wtmPsnlTimeCalendar;

import com.hr.common.com.ComController;
import com.hr.common.logger.Log;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.Map;

/**
 * 조직원근태현황 Controller
 *
 * @author EW
 *
 */
@Controller
@RequestMapping(value="/WtmPsnlTimeCalendar.do", method=RequestMethod.POST )
public class WtmPsnlTimeCalendarController extends ComController {
	/**
	 * 조직원근태현황 서비스
	 */
	@Inject
	@Named("WtmPsnlTimeCalendarService")
	private WtmPsnlTimeCalendarService wtmPsnlTimeCalendarService;

	/**
	 * 조직원근태현황 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewWtmPsnlTimeCalendar",method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewPsnlTimeCalendar() throws Exception {
		return "wtm/stats/wtmPsnlTimeCalendar/wtmPsnlTimeCalendar";
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
	@RequestMapping(params="cmd=getWtmPsnlTimeCalendarList", method = RequestMethod.POST )
	public ModelAndView getWtmPsnlTimeCalendarList(
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
	@RequestMapping(params="cmd=getWtmPsnlTimeCalendarOrgList", method = RequestMethod.POST )
	public ModelAndView getWtmPsnlTimeCalendarOrgList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}


}
