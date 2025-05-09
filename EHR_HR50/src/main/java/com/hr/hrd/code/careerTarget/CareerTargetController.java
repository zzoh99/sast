package com.hr.hrd.code.careerTarget;

import java.util.*;

import javax.inject.Inject;
import javax.inject.Named;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;


import com.hr.common.language.Language;
import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;

@Controller
@RequestMapping(value="/CareerTarget.do", method=RequestMethod.POST )
public class CareerTargetController {
	@Inject
	@Named("Language")
	private Language language;


	@Inject
	@Named("CareerTargetService")
	private CareerTargetService careerTargetService;

	@RequestMapping(params="cmd=viewCareerTarget", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewCareerTarget(
		HttpSession session, HttpServletRequest request,@RequestParam Map<String, Object> paramMap) throws Exception {
		return "hrd/code/careerTarget/careerTarget";
	}

	@RequestMapping(params="cmd=viewCareerTargetDetailPopup", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewCareerTargetDetailPopup(HttpSession session, HttpServletRequest request,@RequestParam Map<String, Object> paramMap) throws Exception {
		return "hrd/code/careerTarget/careerTargetDetailPopup";
	}

	@RequestMapping(params="cmd=viewCareerTargetDetailLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewCareerTargetDetailLayer(HttpSession session, HttpServletRequest request,@RequestParam Map<String, Object> paramMap) throws Exception {
		return "hrd/code/careerTarget/careerTargetDetailLayer";
	}

	@RequestMapping(params="cmd=viewCareerPathDetailPopup", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewCareerPathDetailPopup(HttpSession session, HttpServletRequest request,@RequestParam Map<String, Object> paramMap) throws Exception {
		return "hrd/code/careerTarget/careerPathDetailPopup";
	}

	@RequestMapping(params="cmd=viewCareerPathDetailLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewCareerPathDetailLayer(HttpSession session, HttpServletRequest request,@RequestParam Map<String, Object> paramMap) throws Exception {
		return "hrd/code/careerTarget/careerPathDetailLayer";
	}

	@RequestMapping(params="cmd=viewCareerMapDetailLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewCareerMapDetailLayer(HttpSession session, HttpServletRequest request,@RequestParam Map<String, Object> paramMap) throws Exception {
		return "hrd/code/careerTarget/careerMapDetailLayer";
	}

	@RequestMapping(params="cmd=getCareerTargetList", method = RequestMethod.POST )
	public ModelAndView getCareerTargetList(HttpSession session, HttpServletRequest request,
	@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		List<?> list = new ArrayList<Object>();
		String Message = "";
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		try {
			list = careerTargetService.getCareerTargetList(paramMap);
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


	@RequestMapping(params="cmd=saveCareerTarget", method = RequestMethod.POST )
	public ModelAndView saveCareerTarget(
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
			resultCnt =careerTargetService.saveCareerTarget(convertMap);
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


	@RequestMapping(params="cmd=getCareerPathDetailSHT1", method = RequestMethod.POST )
	public ModelAndView getCareerPathDetailSHT1(HttpSession session, HttpServletRequest request,@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		List<?> list = new ArrayList<Object>();
		String Message = "";
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		try {
			list = careerTargetService.getCareerPathDetailSHT1(paramMap);
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

	@RequestMapping(params="cmd=getCareerPathDetailSHT2", method = RequestMethod.POST )
	public ModelAndView getCareerPathDetailSHT2(HttpSession session, HttpServletRequest request,@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		List<?> list = new ArrayList<Object>();
		String Message = "";
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		try {
			list = careerTargetService.getCareerPathDetailSHT2(paramMap);
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

	@RequestMapping(params="cmd=saveCareerPathDetailSHT2", method = RequestMethod.POST )
	public ModelAndView saveCareerPathDetailSHT2(
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
			resultCnt =careerTargetService.saveCareerPathDetailSHT2(convertMap);
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


	@RequestMapping(params="cmd=saveCareerMapContents", method = RequestMethod.POST )
	public ModelAndView saveCareerMapContents(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		String message = "";
		int resultCnt = -1;

		try{
			resultCnt = careerTargetService.saveCareerMapEmpty(paramMap);
			if(resultCnt < 1){ message="데이터 초기화에 실패하였습니다."; }
			else{
				resultCnt = careerTargetService.saveCareerMapContents(paramMap);
				if(resultCnt > 0){ message="수정되었습니다."; }
				else{ message="수정된 내용이 없습니다."; }
			}
		}catch(Exception e){
			resultCnt = -1;
			message="수정에 실패하였습니다.";
		}

/*		try{
			resultCnt = empContractMgrService.saveEmpContractMgrContents(paramMap);
			if(resultCnt > 0){ message="저장되었습니다."; } else{ message="저장된 내용이 없습니다."; }
		}catch(Exception e){
			resultCnt = -1; message="저장에 실패하였습니다.";
		}*/

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
