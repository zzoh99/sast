package com.hr.org.job.jobDivReportAppDet;
import java.util.HashMap;
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
 * 직무분장보고 상세 Controller
 *
 * @author jy
 *
 */
@Controller
@RequestMapping({"JobDivReportApp.do", "/JobDivReportAppDet.do"})
public class JobDivReportAppDetController extends ComController {
	/**
	 * 직무분장보고 상세 서비스
	 */
	@Inject
	@Named("JobDivReportAppDetService")
	private JobDivReportAppDetService jobDivReportAppDetService;
	
	/**
	 * 직무분장보고 상세 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewJobDivReportAppDet", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewJobDivReportAppDet() throws Exception {
		return "org/job/jobDivReportAppDet/jobDivReportAppDet";
	}

	/**
	 * 직무분장보고 상세 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getJobDivReportAppDetList", method = RequestMethod.POST )
	public ModelAndView getJobDivReportAppDetList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}
	
	/**
	 * 직무분장보고 상세 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMaphrt
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getJobDivReportAppDetList2", method = RequestMethod.POST )
	public ModelAndView getJobDivReportAppDetList2(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}
	
	/**
	 * 직무분장보고 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveJobDivReportAppDet", method = RequestMethod.POST )
	public ModelAndView saveJobDivReportAppDet(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		Log.Info(paramMap.toString());
		
		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

		String message = "";
		int resultCnt = -1;
		try{
			resultCnt = jobDivReportAppDetService.saveJobDivReportAppDet(paramMap,convertMap);
			if(resultCnt > 0){ message="저장 되었습니다."; } else{ message="저장된 내용이 없습니다."; }
		}catch(Exception e){
			Log.Debug(e.getMessage());
			resultCnt = -1; message="저장에 실패하였습니다.";
		}

		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("Code", resultCnt);
		resultMap.put("Message", message);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Result", resultMap);
		Log.DebugEnd();
		return mv;
	}

}
