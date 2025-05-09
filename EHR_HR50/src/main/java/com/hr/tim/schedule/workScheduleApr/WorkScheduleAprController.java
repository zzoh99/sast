package com.hr.tim.schedule.workScheduleApr;
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
 * 부서근무스케쥴승인 Controller
 *
 * @author EW
 *
 */
@Controller
@RequestMapping(value="/WorkScheduleApr.do", method=RequestMethod.POST )
public class WorkScheduleAprController extends ComController {
	/**
	 * 부서근무스케쥴승인 서비스
	 */
	@Inject
	@Named("WorkScheduleAprService")
	private WorkScheduleAprService workScheduleAprService;

	/**
	 * 부서근무스케쥴승인 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewWorkScheduleApr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewWorkScheduleApr() throws Exception {
		return "tim/schedule/workScheduleApr/workScheduleApr";
	}

	/**
	 * 부서근무스케쥴승인  조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getWorkScheduleAprList", method = RequestMethod.POST )
	public ModelAndView getWorkScheduleAprList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		return getDataList(session, request, paramMap);
	}
}
