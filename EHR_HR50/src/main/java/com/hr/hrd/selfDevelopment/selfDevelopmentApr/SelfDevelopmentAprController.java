package com.hr.hrd.selfDevelopment.selfDevelopmentApr;

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

@Controller
@RequestMapping(value="/SelfDevelopmentApr.do", method= RequestMethod.POST )
public class SelfDevelopmentAprController {
	@Inject
	@Named("Language")
	private Language language;


	@Inject
	@Named("SelfDevelopmentAprService")
	private SelfDevelopmentAprService selfDevelopmentAprService;

	@RequestMapping(params="cmd=viewSelfDevelopmentApr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewSelfDevelopmentApr(HttpSession session, HttpServletRequest request,@RequestParam Map<String, Object> paramMap) throws Exception {
		return "hrd/selfDevelopment/selfDevelopmentApr/selfDevelopmentApr";
	}

	@RequestMapping(params="cmd=getSelfDevelopmentArpList", method = RequestMethod.POST )
	public ModelAndView getSelfDevelopmentList(HttpSession session, HttpServletRequest request,	@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		List<?> list = new ArrayList<Object>();
		String Message = "";
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		try {
			list = selfDevelopmentAprService.getSelfDevelopmentArpList(paramMap);
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
			list = selfDevelopmentAprService.getWorkAssignList(paramMap);
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
			list = selfDevelopmentAprService.getSelfSkillAndDevPlanList(paramMap);
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
			list = selfDevelopmentAprService.getSelfReportMoveHopeList(paramMap);
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
			resultCnt = selfDevelopmentAprService.saveSelfDevelopment(convertMap);
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

	// 승인취소
	@RequestMapping(params="cmd=saveSelfDevelopmentAprCancel", method = RequestMethod.POST )
	public ModelAndView saveSelfDevelopmentAprCancel(HttpSession session,  HttpServletRequest request,@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

		String message = "";
		int resultCnt = -1;
		try{
			resultCnt = selfDevelopmentAprService.saveSelfDevelopmentAprCancel(convertMap);
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

	// 승인 or 반려
	@RequestMapping(params="cmd=saveSelfDevelopmentAprConfirmOrReject", method = RequestMethod.POST )
	public ModelAndView saveSelfDevelopmentAprConfirm(HttpSession session,  HttpServletRequest request,@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

		String message = "";
		int resultCnt = -1;
		try{
			resultCnt = selfDevelopmentAprService.saveSelfDevelopmentAprConfirmOrReject(convertMap);
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
			resultCnt = selfDevelopmentAprService.saveSelfSkillAndDevPlan(convertMap);
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
