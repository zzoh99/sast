package com.hr.tra.yearEduPlan.yearEduApp;

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
import com.hr.common.util.SessionUtil;

/**
 * 연간교육계획작성 Controller
 */
@Controller
@RequestMapping(value="/YearEduApp.do", method=RequestMethod.POST )
public class YearEduAppController extends ComController {
	/**
	 * 연간교육계획작성 서비스
	 */
	@Inject
	@Named("YearEduAppService")
	private YearEduAppService yearEduAppService;

	/**
	 * 연간교육계획작성 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewYearEduApp", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewYearEduApp() throws Exception {
		return "tra/yearEduPlan/yearEduApp/yearEduApp";
	}
	
	/**
	 * 계획상태 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getYearEduAppStatus", method = RequestMethod.POST )
	public ModelAndView getYearEduAppStatus(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		if(!paramMap.containsKey("ssnOrgCd")){
			paramMap.put( "ssnOrgCd" , (String) SessionUtil.getRequestAttribute("ssnOrgCd"));
		}
		return getDataMap(session, request, paramMap);
	}
	
	/**
	 * 연간교육계획작성 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getYearEduAppList", method = RequestMethod.POST )
	public ModelAndView getYearEduAppList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}
	
	
	/**
	 * 연간교육계획작성 저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveYearEduApp", method = RequestMethod.POST )
	public ModelAndView saveYearEduApp(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		Log.Info(paramMap.toString());
		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		Log.Info(convertMap.toString());

		String message = "";
		int resultCnt = -1;
		try{
			resultCnt = yearEduAppService.saveYearEduApp(paramMap,convertMap);
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
