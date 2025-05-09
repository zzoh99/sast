package com.hr.hrm.retire.retireInterview;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import com.hr.common.security.SecurityMgrService;
import com.hr.common.util.CryptoUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;

/**
 * 퇴직면담 Controller
 *
 * @author bckim
 *
 */
@Controller
@RequestMapping(value="/RetireInterview.do", method=RequestMethod.POST )
public class RetireInterviewController {

	/**
	 * 퇴직면담 서비스
	 */
	@Inject
	@Named("RetireInterviewService")
	private RetireInterviewService retireInterviewService;

	@Autowired
	private SecurityMgrService securityMgrService;

	/**
	 * 2차퇴직면담 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewRetireInterview", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewRetireInterview() throws Exception {
		return "hrm/retire/retireInterview/retireInterview";
	}
	
	/**
	 * 3차퇴직면담 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewRetireInterview2", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewRetireInterview2() throws Exception {
		return "hrm/retire/retireInterview/retireInterview2";
	}
	
	/**
	 * 퇴직면담 대상자 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getRetireInterviewList", method = RequestMethod.POST )
	public ModelAndView getRetireInterviewList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", 		session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",   		session.getAttribute("ssnSabun"));
		paramMap.put("ssnSearchType", 	session.getAttribute("ssnSearchType"));
		paramMap.put("ssnGrpCd", 		session.getAttribute("ssnGrpCd"));
		

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = retireInterviewService.getRetireInterviewList(paramMap);
		}catch(Exception e){
			Message="조회에 실패 하였습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}
	
	/**
	 * 퇴직면담 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getRetireRecodeList", method = RequestMethod.POST )
	public ModelAndView getRetireRecodeList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		String ssnEnterCd = String.valueOf(session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnEnterCd", 		ssnEnterCd);
		paramMap.put("ssnSabun",   		session.getAttribute("ssnSabun"));

		if (paramMap.containsKey("schApplSeq")) {
			String encryptKey = securityMgrService.getEncryptKey(ssnEnterCd);
			paramMap.put("schApplSeq", CryptoUtil.decrypt(encryptKey, paramMap.get("schApplSeq")+""));
		}

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = retireInterviewService.getRetireRecodeList(paramMap);
		}catch(Exception e){
			Message="조회에 실패 하였습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}
	
	/**
	 *  퇴직면담  저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveRetireInterview", method = RequestMethod.POST )
	public ModelAndView saveRetireInterview(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

		String message = "";
		int resultCnt = -1;
		try{
			resultCnt = retireInterviewService.saveRetireInterview(convertMap);
			if(resultCnt > 0){ message="저장되었습니다."; } else{ message="저장된 내용이 없습니다."; }
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
