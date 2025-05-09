package com.hr.org.job.jobSchemeMgrBS;
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
 * JobSchemeMgrBS Controller
 *
 * @author EW
 *
 */
@Controller
@RequestMapping(value="/JobSchemeMgrBS.do", method=RequestMethod.POST )
public class JobSchemeMgrBSController extends ComController {
	/**
	 * JobSchemeMgrBS 서비스
	 */
	@Inject
	@Named("JobSchemeMgrBSService")
	private JobSchemeMgrBSService jobSchemeMgrBSMgrService;

	/**
	 * JobSchemeMgrBS View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewJobSchemeMgrBS", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewJobSchemeMgrBS() throws Exception {
		return "org/job/jobSchemeMgrBS/jobSchemeMgrBS";
	}
	
	/**
	 * JobSchemeMgrBS 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getJobSchemeMgrBSList", method = RequestMethod.POST )
	public ModelAndView getJobSchemeMgrBSList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}
	
	/**
	 * 직무분류표 저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveJobSchemeMgrBS", method = RequestMethod.POST )
	public ModelAndView saveJobSchemeMgrBS(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

		String message = "";
		int resultCnt = -1;
		try{
			resultCnt =jobSchemeMgrBSMgrService.saveJobSchemeMgrBS(convertMap);
			if(resultCnt > 0){ message="저장 되었습니다."; } else{ message="저장된 내용이 없습니다."; }
		}catch(Exception e){
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
