package com.hr.pap.evaluation.appEval;
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

import com.hr.common.code.CommonCodeService;
import com.hr.common.com.ComController;
import com.hr.common.language.LanguageUtil;
import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;

/**
 * 평가수행 Controller 
 * 
 * @author JCY
 *
 */
@Controller
@RequestMapping(value="/AppEval.do", method=RequestMethod.POST )
public class AppEvalController extends ComController {

	/**
	 * 사용할 서비스 선언
	 */
	@Inject
	@Named("AppEvalService")
	private AppEvalService appEvalService;
	
	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;
	
	/**
	 * 평가수행 View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewAppEval", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewAppEval() throws Exception {
		return "pap/evaluation/appEval/appEval";
	}
	
	/**
	 * 평가수행 팝업호출 View
	 *
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewAppOtherEvalListPopup", method = {RequestMethod.POST, RequestMethod.GET} )
	public ModelAndView viewAppOtherEvalListPopup(HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("pap/evaluation/appEval/appOtherEvalListPopup");
		mv.addObject("Param", paramMap.get("Param"));
		return mv;
	}	
	
	/**
	 * 평가수행 상세팝업호출 View
	 *
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewAppOtherEvalDetailPopup", method = {RequestMethod.POST, RequestMethod.GET} )
	public ModelAndView viewAppOtherEvalDetailPopup(HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("pap/evaluation/appEval/appOtherEvalDetailPopup");
		mv.addObject("Param", paramMap.get("Param"));
		return mv;
	}	

	/**
	 * 평가수행 팝업호출 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewAppSelfEvalListPopup", method = {RequestMethod.POST, RequestMethod.GET} )
	public ModelAndView viewAppSelfEvalListPopup(HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("pap/evaluation/appEval/appSelfEvalListPopup");
		mv.addObject("Param", paramMap.get("Param"));
		return mv;
	}	
	
	/**
	 * 평가수행 가이드 팝업호출 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewAppGuidePopup", method = {RequestMethod.POST, RequestMethod.GET} )
	public ModelAndView viewAppGuidePopup(HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("pap/evaluation/appEval/appGuidePopup");
		mv.addObject("Param", paramMap.get("Param"));
		return mv;
	}	
	
	/**
	 * 평가수행_대상평가기준 조회(평가대상자, 평가자 데이터있으면 조회)
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAppEvalComboList", method = RequestMethod.POST )
	public ModelAndView getAppEvalComboList(
				HttpSession session
			,  	HttpServletRequest request
			,	@RequestParam Map<String, Object> paramMap ) throws Exception {
		
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",   session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = appEvalService.getAppEvalComboList(paramMap);
		}catch(Exception e){
			Message="조회에 실패하였습니다.";
		}
		
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		
		Log.DebugEnd();
		
		return mv;
	}
	
	/**
	 * 평가수행_자기평가 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAppSelfEvalList", method = RequestMethod.POST )
	public ModelAndView getAppSelfEvalList(
				HttpSession session
			,  	HttpServletRequest request
			,	@RequestParam Map<String, Object> paramMap ) throws Exception {
		
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",   session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = appEvalService.getAppSelfEvalList(paramMap);
		}catch(Exception e){
			Message="조회에 실패하였습니다.";
		}
		
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		
		Log.DebugEnd();
		
		return mv;
	}
	
	/**
	 * 평가수행_타인평가 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAppOtherEvalList", method = RequestMethod.POST )
	public ModelAndView getAppOtherEvalList(
				HttpSession session
			,  	HttpServletRequest request
			,	@RequestParam Map<String, Object> paramMap ) throws Exception {
		
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",   session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = appEvalService.getAppOtherEvalList(paramMap);
		}catch(Exception e){
			Message="조회에 실패하였습니다.";
		}
		
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		
		Log.DebugEnd();
		
		return mv;
	}	
	
	/**
	 * 평가수행 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAppEvalList", method = RequestMethod.POST )
	public ModelAndView getAppEvalList(
				HttpSession session
			,  	HttpServletRequest request
			,	@RequestParam Map<String, Object> paramMap ) throws Exception {
		
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",   session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = appEvalService.getAppEvalList(paramMap);
		}catch(Exception e){
			Message="조회에 실패하였습니다.";
		}
		
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		
		Log.DebugEnd();
		
		return mv;
	}
	
	/**
	 * 목표합의 팝업 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getOtherEvalListPopupList1", method = RequestMethod.POST )
	public ModelAndView getOtherEvalListPopupList1(
				HttpSession session
			,  	HttpServletRequest request
			,	@RequestParam Map<String, Object> paramMap ) throws Exception {
		
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",   session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = appEvalService.getOtherEvalListPopupList1(paramMap);
		}catch(Exception e){
			Message="조회에 실패하였습니다.";
		}
		
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		
		Log.DebugEnd();
		
		return mv;
	}
	
	/**
	 * 타인평가 상세팝업 유저 유저조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getOtherEvalDetailPopupUserList", method = RequestMethod.POST )
	public ModelAndView getOtherEvalDetailPopupUserList(
				HttpSession session
			,  	HttpServletRequest request
			,	@RequestParam Map<String, Object> paramMap ) throws Exception {
		
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",   session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = appEvalService.getOtherEvalDetailPopupUserList(paramMap);
		}catch(Exception e){
			Message="조회에 실패하였습니다.";
		}
		
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		
		Log.DebugEnd();
		
		return mv;
	}
	
	/**
	 * 타인평가 가이드 팝업 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAppGuideList", method = RequestMethod.POST )
	public ModelAndView getAppGuideList(
				HttpSession session
			,  	HttpServletRequest request
			,	@RequestParam Map<String, Object> paramMap ) throws Exception {
		
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",   session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = appEvalService.getAppGuideList(paramMap);
		}catch(Exception e){
			Message="조회에 실패하였습니다.";
		}
		
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		
		Log.DebugEnd();
		
		return mv;
	}	
	
	/**
	 * 타인평가  평가항목 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getOtherEvalDetailPopupItemList", method = RequestMethod.POST )
	public ModelAndView getOtherEvalDetailPopupItemList(
				HttpSession session
			,  	HttpServletRequest request
			,	@RequestParam Map<String, Object> paramMap ) throws Exception {
		
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",   session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = appEvalService.getOtherEvalDetailPopupItemList(paramMap);
		}catch(Exception e){
			Message="조회에 실패하였습니다.";
		}
		
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		
		Log.DebugEnd();
		
		return mv;
	}	
	
	/**
	 * 타인평가 일정 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getOtherEvalDetailPopupSchList", method = RequestMethod.POST )
	public ModelAndView getOtherEvalDetailPopupSchList(
				HttpSession session
			,  	HttpServletRequest request
			,	@RequestParam Map<String, Object> paramMap ) throws Exception {
		
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",   session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = appEvalService.getOtherEvalDetailPopupSchList(paramMap);
		}catch(Exception e){
			Message="조회에 실패하였습니다.";
		}
		
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		
		Log.DebugEnd();
		
		return mv;
	}	
	
	/**
	 * 평가수행_목표수준 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAppSelfEvalAppClassList", method = RequestMethod.POST )
	public ModelAndView getAppSelfEvalAppClassList(
				HttpSession session
			,  	HttpServletRequest request
			,	@RequestParam Map<String, Object> paramMap ) throws Exception {
		
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",   session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = appEvalService.getAppSelfEvalAppClassList(paramMap);
		}catch(Exception e){
			Message="조회에 실패하였습니다.";
		}
		
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		
		Log.DebugEnd();
		
		return mv;
	}	
	
	/**
	 * ExecCompAppMngUpload 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveOtherEvalDetailPopup", method = RequestMethod.POST )
	public ModelAndView saveOtherEvalDetailPopup(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();
		if ("05".equals(String.valueOf(paramMap.get("appTypeCd"))) 
				|| ("07".equals(String.valueOf(paramMap.get("appTypeCd"))))) { //  && "Save".equals(String.valueOf(paramMap.get("action")))
			paramMap.putAll(ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),""));
		}
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		paramMap.put("ssnEnterCd",	session.getAttribute("ssnEnterCd"));
		paramMap.put("action",	request.getParameter("action"));

		String message = "";
		int resultCnt = -1;
		
		try{
			resultCnt = "07".equals(String.valueOf(paramMap.get("appTypeCd")))? appEvalService.saveOtherEvalDetailPopup2(paramMap) : appEvalService.saveOtherEvalDetailPopup(paramMap);
			if(resultCnt > 0){ message = LanguageUtil.getMessage("msg.alertSaveOkV1", null, "저장 되었습니다."); } else{ message = LanguageUtil.getMessage("msg.alertSaveNoData", null, "저장된 내용이 없습니다."); }
		}catch(Exception e){
			e.printStackTrace();
			resultCnt = -1; message = LanguageUtil.getMessage("msg.alertSaveFail2", null, "저장에 실패하였습니다.");
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
	
	// 자기평가 
	/**
	 * 평가자조회 팝업 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getSelfEvalListPopupList1", method = RequestMethod.POST )
	public ModelAndView getSelfEvalListPopupList1(
				HttpSession session
			,  	HttpServletRequest request
			,	@RequestParam Map<String, Object> paramMap ) throws Exception {
		
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",   session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = appEvalService.getSelfEvalListPopupList1(paramMap);
		}catch(Exception e){
			Message="조회에 실패하였습니다.";
		}
		
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		
		Log.DebugEnd();
		
		return mv;
	}
	
	/**
	 * 자기평가 상세팝업호출 View
	 *
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewAppSelfEvalDetailPopup", method = {RequestMethod.POST, RequestMethod.GET} )
	public ModelAndView viewAppSelfEvalDetailPopup(HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("pap/evaluation/appEval/appSelfEvalDetailPopup");
		mv.addObject("Param", paramMap.get("Param"));
		return mv;
	}	
	

	/**
	 * 타인평가 상세팝업 유저 유저조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getSelfEvalDetailPopupUserList", method = RequestMethod.POST )
	public ModelAndView getSelfEvalDetailPopupUserList(
				HttpSession session
			,  	HttpServletRequest request
			,	@RequestParam Map<String, Object> paramMap ) throws Exception {
		
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",   session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = appEvalService.getSelfEvalDetailPopupUserList(paramMap);
		}catch(Exception e){
			Message="조회에 실패하였습니다.";
		}
		
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		
		Log.DebugEnd();
		
		return mv;
	}
	

	/**
	 * 자기평가 일정 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getSelfEvalDetailPopupSchList", method = RequestMethod.POST )
	public ModelAndView getSelfEvalDetailPopupSchList(
				HttpSession session
			,  	HttpServletRequest request
			,	@RequestParam Map<String, Object> paramMap ) throws Exception {
		
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",   session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = appEvalService.getSelfEvalDetailPopupSchList(paramMap);
		}catch(Exception e){
			Message="조회에 실패하였습니다.";
		}
		
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		
		Log.DebugEnd();
		
		return mv;
	}	
	

	/**
	 * 자기평가  평가항목 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getSelfEvalDetailPopupItemList", method = RequestMethod.POST )
	public ModelAndView getSelfEvalDetailPopupItemList(
				HttpSession session
			,  	HttpServletRequest request
			,	@RequestParam Map<String, Object> paramMap ) throws Exception {
		
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",   session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = appEvalService.getSelfEvalDetailPopupItemList(paramMap);
		}catch(Exception e){
			Message="조회에 실패하였습니다.";
		}
		
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		
		Log.DebugEnd();
		
		return mv;
	}	
	
	/**
	 * 자기평가 상세팝업 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveSelfEvalDetailPopup", method = RequestMethod.POST )
	public ModelAndView saveSelfEvalDetailPopup(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();

		paramMap.putAll(ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),""));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		paramMap.put("ssnEnterCd",	session.getAttribute("ssnEnterCd"));
		String action = request.getParameter("action");
		paramMap.put("action",	action);
		String message = "";
		int resultCnt = -1;
		
		
		try{
			resultCnt = appEvalService.saveSelfEvalDetailPopup(paramMap);
			if ("update".equalsIgnoreCase(action)) {
				if(resultCnt > 0){ message = LanguageUtil.getMessage("msg.alertSaveOkV1", null, "진행상태가 변경 되었습니다."); } else{ message = LanguageUtil.getMessage("msg.alertSaveNoData", null, "저장된 내용이 없습니다."); }
				resultCnt = 99; 
			} else {
				if(resultCnt > 0){ message = LanguageUtil.getMessage("msg.alertSaveOkV1", null, "저장 되었습니다."); } else{ message = LanguageUtil.getMessage("msg.alertSaveNoData", null, "저장된 내용이 없습니다."); }
			}
		}catch(Exception e){
			e.printStackTrace();
			resultCnt = -1; message = LanguageUtil.getMessage("msg.alertSaveFail2", null, "저장에 실패하였습니다.");
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
	 * 2차평가 조회팝업 팝업호출 View
	 *
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewAppOtherEvalListPopup2", method = {RequestMethod.POST, RequestMethod.GET} )
	public ModelAndView viewAppOtherEvalListPopup2(HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("pap/evaluation/appEval/appOtherEvalListPopup2");
		mv.addObject("Param", paramMap.get("Param"));
		return mv;
	}	
	
	/**
	 * 2차평가 조회팝업 - 평가등그배분 그리드 세팅전 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAppGradeRateItemList", method = RequestMethod.POST )
	public ModelAndView getAppGradeRateItemList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}

	/**
	 * 2차평가 조회팝업 - 평가차수 성과배분그룹 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAppOtherEvalAppGroup", method = RequestMethod.POST )
	public ModelAndView getAppOtherEvalAppGroup(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}
	
	/**
	 * 2차평가 조회팝업 - 평가등급배분 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAppOtherEvalAppRateList", method = RequestMethod.POST )
	public ModelAndView getAppOtherEvalAppRateList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		paramMap.put("columns", String.valueOf(paramMap.get("columns")).split("@"));
		return getDataList(session, request, paramMap);
	}
	
	/**
	 * 2차평가 조회팝업 - 평가자평가 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAppOtherEvalListPopup2", method = RequestMethod.POST )
	public ModelAndView getAppOtherEvalListPopup2(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}
	
	/**
	 *  2차평가 상세 팝업호출 View
	 *
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewAppOtherEvalDetailPopup2", method = {RequestMethod.POST, RequestMethod.GET} )
	public ModelAndView viewAppOtherEvalDetailPopup2(HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("pap/evaluation/appEval/appOtherEvalDetailPopup2");
		mv.addObject("Param", paramMap.get("Param"));
		return mv;
	}	
	
	/**
	 * 2차평가 조회팝업 - 일정 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getOtherEvalDetailPopupSchList2", method = RequestMethod.POST )
	public ModelAndView getOtherEvalDetailPopupSchList2(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}
}
