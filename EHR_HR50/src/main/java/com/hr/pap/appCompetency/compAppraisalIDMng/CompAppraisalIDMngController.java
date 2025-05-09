package com.hr.pap.appCompetency.compAppraisalIDMng;
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


import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;

/**
 * 다면평가ID관리 Controller
 *
 * @author EW
 *
 */
@Controller
@RequestMapping(value="/CompAppraisalIDMng.do", method=RequestMethod.POST )
public class CompAppraisalIDMngController {
	/**
	 * 다면평가ID관리 서비스
	 */
	@Inject
	@Named("CompAppraisalIDMngService")
	private CompAppraisalIDMngService compAppraisalIDMngService;

	/**
	 * 다면평가ID관리 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewCompAppraisalIDMng", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewCompAppraisalIDMng() throws Exception {
		return "pap/appCompetency/compAppraisalIDMng/compAppraisalIDMng";
	}

	/**
	 * 다면평가ID관리(세부내역) 팝업 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewCompAppraisalIDMngPop", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewCompAppraisalIDMngPop() throws Exception {
		return "pap/appCompetency/compAppraisalIDMng/compAppraisalIDMngPop";
	}

	/**
	 * 다면평가ID관리 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getCompAppraisalIDMngList", method = RequestMethod.POST )
	public ModelAndView getCompAppraisalIDMngList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = compAppraisalIDMngService.getCompAppraisalIDMngList(paramMap);
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
	 * 다면평가ID관리 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveCompAppraisalIDMng", method = RequestMethod.POST )
	public ModelAndView saveCompAppraisalIDMng(
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
			resultCnt =compAppraisalIDMngService.saveCompAppraisalIDMng(convertMap);
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

	/**
	 * 다면평가ID관리 단건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getCompAppraisalIDMngMap", method = RequestMethod.POST )
	public ModelAndView getCompAppraisalIDMngMap(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		Map<?, ?> map = null;
		String Message = "";

		try{
			map = compAppraisalIDMngService.getCompAppraisalIDMngMap(paramMap);
		}catch(Exception e){
			Message="조회에 실패하였습니다.";
		}

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", map);
		mv.addObject("Message", Message);

		Log.DebugEnd();
		return mv;
}

	/**
	 * 다면평가ID관리 프로시저
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=CompAppraisalIDMngPrc", method = RequestMethod.POST )
	public ModelAndView CompAppraisalIDMngPrc(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));
		paramMap.put("ssnSearchType",session.getAttribute("ssnSearchType"));
		paramMap.put("ssnGrpCd",session.getAttribute("ssnGrpCd"));

		Map<?, ?> map  = compAppraisalIDMngService.compAppraisalIDMngPrc(paramMap);

		Log.Debug("obj : "+map);
		Log.Debug("sqlCode : "+map.get("sqlCode"));
		Log.Debug("sqlErrm : "+map.get("sqlErrm"));

		Map<String, Object> resultMap = new HashMap<String, Object>();
		if (map.get("sqlCode") != null) {
			resultMap.put("Code", map.get("sqlCode").toString());
		}
		if (map.get("sqlErrm") != null) {
			resultMap.put("Message", map.get("sqlErrm").toString());
		}

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Result", resultMap);

		Log.DebugEnd();
		return mv;
	}

	/**
	 * 리더십평가 알림 대상자 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAppPeopleList", method = RequestMethod.POST )
	public ModelAndView getAppPeopleList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = compAppraisalIDMngService.getAppPeopleList(paramMap);
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
}
