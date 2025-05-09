package com.hr.common.popup.jobDivReportMgrPopup;
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
import com.hr.org.job.jobDivReportMgr.JobDivReportMgrService;
/**
 * 직무분장표 Controller
 *
 * @author jy
 *
 */
@Controller
@RequestMapping(value="/JobDivReportMgrPopup.do", method=RequestMethod.POST )
public class JobDivReportMgrPopupController extends ComController {
	/**
	 * 직무분장표 서비스
	 */
	@Inject
	@Named("JobDivReportMgrService")
	private JobDivReportMgrService jobDivReportMgrService;

	/**
	 * 직무분장표 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewJobDivReportMgrLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewJobDivReportMgr() throws Exception {
		return "org/job/jobDivReportMgrLayer/jobDivReportMgrLayer";
	}
	
	/**
	 * 조직도 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getJobDivReportMgrList", method = RequestMethod.POST )
	public ModelAndView getJobDivReportMgrList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}

}
