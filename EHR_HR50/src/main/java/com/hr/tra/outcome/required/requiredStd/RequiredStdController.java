package com.hr.tra.outcome.required.requiredStd;
import java.util.ArrayList;
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

import com.hr.common.code.CommonCodeService;
import com.hr.common.com.ComController;
import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;

/**
 * 필수교육과정기준관리 Controller 
 * 
 * @author 이름
 *
 */
@Controller
@RequestMapping(value="/RequiredStd.do", method=RequestMethod.POST )
public class RequiredStdController extends ComController {
	/**
	 * 필수교육과정기준관리 서비스
	 */
	@Inject
	@Named("RequiredStdService")
	private RequiredStdService requiredStdService;	
	
	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;
	
	
	/**
	 * 필수교육과정기준관리 View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewRequiredStd", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewRequiredStd() throws Exception {
		return "tra/outcome/required/requiredStd/requiredStd";
	}
	
	/**
	 * 필수교육과정기준관리 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getRequiredStdList", method = RequestMethod.POST )
	public ModelAndView getRequiredStdList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}
	
	
	/**
	 * 필수교육과정기준관리 저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveRequiredStd", method = RequestMethod.POST )
	public ModelAndView saveRequiredStd(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();  
		
		return saveData(session, request, paramMap);
	}


	/**
	 * 필수교육과정기준관리 - 전년도 복사
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveRequiredStdYear", method = RequestMethod.POST )
	public ModelAndView saveRequiredStdYear(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();
		String message = "";
		int resultCnt = -1;
		try{
			resultCnt = requiredStdService.saveRequiredStdYear(paramMap);
			if(resultCnt > 0){ message="정상 처리되었습니다."; } else{ message="처리된 내용이 없습니다."; }
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
	/**
	 * 필수교육과정기준관리 - 회차생성 프로시저 호출
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=prcRequiredStdEvt", method = RequestMethod.POST )
	public ModelAndView prcRequiredStdEvt(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();  
		return execPrc(session, request, paramMap);
	}
}
