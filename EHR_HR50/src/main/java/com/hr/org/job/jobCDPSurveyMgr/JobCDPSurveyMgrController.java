package com.hr.org.job.jobCDPSurveyMgr;
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
/**
 * 희망직무현황 Controller
 *
 * @author jy
 *
 */
@Controller
@RequestMapping(value="/JobCDPSurveyMgr.do", method=RequestMethod.POST )
public class JobCDPSurveyMgrController extends ComController {
	/**
	 * 희망직무현황 서비스
	 */
	@Inject
	@Named("JobCDPSurveyMgrService")
	private JobCDPSurveyMgrService jobCDPSurveyMgrService;
	
	/**
	 * 희망직무현황 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewJobCDPSurveyMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewJobCDPSurveyMgr() throws Exception {
		return "org/job/jobCDPSurveyMgr/jobCDPSurveyMgr";
	}
	
	/**
	 * 희망직무현황 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getJobCDPSurveyMgrList", method = RequestMethod.POST )
	public ModelAndView getJobCDPSurveyMgrList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}

}
