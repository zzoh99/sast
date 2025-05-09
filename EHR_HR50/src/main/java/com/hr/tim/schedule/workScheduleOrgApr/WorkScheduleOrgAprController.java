package com.hr.tim.schedule.workScheduleOrgApr;
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
@RequestMapping(value="/WorkScheduleOrgApr.do", method=RequestMethod.POST )
public class WorkScheduleOrgAprController extends ComController {
	/**
	 * 부서근무스케쥴승인 서비스
	 */
	@Inject
	@Named("WorkScheduleOrgAprService")
	private WorkScheduleOrgAprService workScheduleOrgAprService;

	/**
	 * 부서근무스케쥴승인 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewWorkScheduleOrgApr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewWorkScheduleOrgApr() throws Exception {
		return "tim/schedule/workScheduleOrgApr/workScheduleOrgApr";
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
	@RequestMapping(params="cmd=getWorkScheduleOrgAprList", method = RequestMethod.POST )
	public ModelAndView getWorkScheduleOrgAprList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		return getDataList(session, request, paramMap);
	}
}
