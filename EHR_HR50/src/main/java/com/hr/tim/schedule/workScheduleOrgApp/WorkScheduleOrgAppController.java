package com.hr.tim.schedule.workScheduleOrgApp;
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
 * 부서근무스케쥴신청 Controller
 *
 * @author JSG
 *
 */
@Controller
@RequestMapping(value="/WorkScheduleOrgApp.do", method=RequestMethod.POST )
public class WorkScheduleOrgAppController extends ComController {
	/**
	 * 부서근무스케쥴신청 서비스
	 */
	@Inject
	@Named("WorkScheduleOrgAppService")
	private WorkScheduleOrgAppService workScheduleOrgAppService;

	/**
	 * 부서근무스케쥴신청 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewWorkScheduleOrgApp", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewWorkScheduleOrgApp() throws Exception {
		return "tim/schedule/workScheduleOrgApp/workScheduleOrgApp";
	}
	


	/**
	 * 부서근무스케쥴신청 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getWorkScheduleOrgAppList", method = RequestMethod.POST )
	public ModelAndView getWorkScheduleOrgAppList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}
	
	
	/**
	 * 부서근무스케쥴신청 임시저장 삭제
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=deleteWorkScheduleOrgApp", method = RequestMethod.POST )
	public ModelAndView deleteWorkScheduleOrgApp(
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
			resultCnt =workScheduleOrgAppService.deleteWorkScheduleOrgApp(convertMap);
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
