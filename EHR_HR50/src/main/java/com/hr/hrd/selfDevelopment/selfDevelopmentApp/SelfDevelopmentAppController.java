package com.hr.hrd.selfDevelopment.selfDevelopmentApp;

import com.hr.common.language.Language;
import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.hr.common.code.CommonCodeService;
import com.hr.common.com.ComController;

@Controller
@RequestMapping(value="/SelfDevelopmentApp.do", method=RequestMethod.POST )
public class SelfDevelopmentAppController extends ComController  {
	@Inject
	@Named("Language")
	private Language language;

	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;
	
	@Inject
	@Named("SelfDevelopmentAppService")
	private SelfDevelopmentAppService selfDevelopmentAppService;

	@RequestMapping(params="cmd=viewSelfDevelopmentApp", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewSelfDevelopmentApp(HttpSession session, HttpServletRequest request,@RequestParam Map<String, Object> paramMap) throws Exception {
		return "hrd/selfDevelopment/selfDevelopmentApp/selfDevelopmentApp";
	}

	@RequestMapping(params="cmd=viewSelfDevelopmentDet", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewSelfDevelopmentDet(HttpSession session, HttpServletRequest request,@RequestParam Map<String, Object> paramMap) throws Exception {
		return "hrd/selfDevelopment/selfDevelopmentApp/selfDevelopmentDet";
	}

	
//	getWorkJobList
	@RequestMapping(params="cmd=getWorkJobList", method = RequestMethod.POST )
	public ModelAndView getWorkJobList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}
	
	
	@RequestMapping(params="cmd=getSelfDevelopmentList", method = RequestMethod.POST )
	public ModelAndView getSelfDevelopmentList(HttpSession session, HttpServletRequest request,	@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		List<?> list = new ArrayList<Object>();
		String Message = "";
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		try {
			list = selfDevelopmentAppService.getSelfDevelopmentList(paramMap);
		} catch (Exception e) {
			Message = "조회에 실패 하였습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}

	@RequestMapping(params="cmd=getWorkAssignList", method = RequestMethod.POST )
	public ModelAndView getWorkAssignList(HttpSession session, HttpServletRequest request,	@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		List<?> list = new ArrayList<Object>();
		String Message = "";
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		try {
			list = selfDevelopmentAppService.getWorkAssignList(paramMap);
		} catch (Exception e) {
			Message = "조회에 실패 하였습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}

	@RequestMapping(params="cmd=getSelfSkillAndDevPlanList", method = RequestMethod.POST )
	public ModelAndView getSelfSkillAndDevPlanList(HttpSession session, HttpServletRequest request,	@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		List<?> list = new ArrayList<Object>();
		String Message = "";
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		try {
			list = selfDevelopmentAppService.getSelfSkillAndDevPlanList(paramMap);
		} catch (Exception e) {
			Message = "조회에 실패 하였습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}

	@RequestMapping(params="cmd=getSelfReportMoveHopeList", method = RequestMethod.POST )
	public ModelAndView getSelfReportMoveHopeList(HttpSession session, HttpServletRequest request,	@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		List<?> list = new ArrayList<Object>();
		String Message = "";
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		try {
			list = selfDevelopmentAppService.getSelfReportMoveHopeList(paramMap);
		} catch (Exception e) {
			Message = "조회에 실패 하였습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}

	@RequestMapping(params="cmd=saveSelfDevelopment", method = RequestMethod.POST )
	public ModelAndView saveCDPManageList(HttpSession session,  HttpServletRequest request,@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

		String message = "";
		int resultCnt = -1;
		try{
			resultCnt = selfDevelopmentAppService.saveSelfDevelopment(convertMap);
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

	@RequestMapping(params="cmd=saveSelfSkillAndDevPlan", method = RequestMethod.POST )
	public ModelAndView saveSelfSkillAndDevPlan(HttpSession session,  HttpServletRequest request,@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

		String message = "";
		int resultCnt = -1;
		try{
			resultCnt = selfDevelopmentAppService.saveSelfSkillAndDevPlan(convertMap);
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

	@RequestMapping(params="cmd=getSelfDevelopmentPrevStepStatusList", method = RequestMethod.POST )
	public ModelAndView getSelfDevelopmentPrevStepStatusList(HttpSession session, HttpServletRequest request,	@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		List<?> list = null;
		String Message = "";
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		try {
			list = selfDevelopmentAppService.getSelfDevelopmentPrevStepStatusList(paramMap);
		} catch (Exception e) {
			Message = "조회에 실패 하였습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}
}
