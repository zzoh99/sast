package com.hr.pap.intern.internEval;
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
import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;
/**
 * 수습평가 Controller
 *
 * @author chs
 *
 */
@Controller
@RequestMapping(value="/InternEval.do", method=RequestMethod.POST )
public class InternEvalController extends ComController {
	/**
	 * 사용할 서비스 선언
	 */
	@Inject
	@Named("InternEvalService")
	private InternEvalService internEvalService;

	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;

	/**
	 * 수습평가 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewInternEval", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewInternEval() throws Exception {
		return "pap/intern/internEval/internEval";
	}
	
	/**
	 * 수습평가 공지사항조회 팝업 View
	 *
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewInternGuidePopup", method = {RequestMethod.POST, RequestMethod.GET} )
	public ModelAndView viewInternGuidePopup(HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("pap/intern/internEval/internGuidePopup");
		mv.addObject("Param", paramMap.get("Param"));
		return mv;
	}	
	
	/**
	 * 자기평가 상세팝업호출 View
	 *
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewInternSelfEvalDetailPopup", method = {RequestMethod.POST, RequestMethod.GET} )
	public ModelAndView viewInternSelfEvalDetailPopup(HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("pap/intern/internEval/internSelfEvalDetailPopup");
		mv.addObject("Param", paramMap.get("Param"));
		return mv;
	}	
	
	/**
	 * 타인평가 리스트팝업 호출 View
	 *
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewInternOtherEvalListPopup", method = {RequestMethod.POST, RequestMethod.GET} )
	public ModelAndView viewInternOtherEvalListPopup(HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("pap/intern/internEval/internOtherEvalListPopup");
		mv.addObject("Param", paramMap.get("Param"));
		return mv;
	}
	
	/**
	 * 수습관찰표 팝업 호출 View
	 *
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewInternOtherEvalObservePopup", method = {RequestMethod.POST, RequestMethod.GET} )
	public ModelAndView viewInternOtherEvalObserveListPopup(HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("pap/intern/internEval/internOtherEvalObservePopup");
		mv.addObject("Param", paramMap.get("Param"));
		return mv;
	}	
	
	/**
	 * 수습평가표 팝업 호출 View
	 *
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewInternOtherEvalSheetListPopup", method = {RequestMethod.POST, RequestMethod.GET} )
	public ModelAndView viewInternOtherEvalSheetListPopup(HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("pap/intern/internEval/internOtherEvalSheetListPopup");
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
	@RequestMapping(params="cmd=getInternEvalComboList", method = RequestMethod.POST )
	public ModelAndView getInternEvalComboList(
				HttpSession session
			,  	HttpServletRequest request
			,	@RequestParam Map<String, Object> paramMap ) throws Exception {
		
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",   session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = internEvalService.getInternEvalComboList(paramMap);
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
	 * 수습평가_자기평가 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getInternSelfEvalList", method = RequestMethod.POST )
	public ModelAndView getInternSelfEvalList(
				HttpSession session
			,  	HttpServletRequest request
			,	@RequestParam Map<String, Object> paramMap ) throws Exception {
		
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",   session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = internEvalService.getInternSelfEvalList(paramMap);
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
	 * 수습평가_타인평가 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getInternOtherEvalList", method = RequestMethod.POST )
	public ModelAndView getInternOtherEvalList(
				HttpSession session
			,  	HttpServletRequest request
			,	@RequestParam Map<String, Object> paramMap ) throws Exception {
		
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",   session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = internEvalService.getInternOtherEvalList(paramMap);
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
	 * 수습평가 공지사항조회 팝업 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getInternGuideList", method = RequestMethod.POST )
	public ModelAndView getInternGuideList(
				HttpSession session
			,  	HttpServletRequest request
			,	@RequestParam Map<String, Object> paramMap ) throws Exception {
		
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",   session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = internEvalService.getInternGuideList(paramMap);
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
	 * 자기평가 상세팝업 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getInternSelfEvalDetailPopupList", method = RequestMethod.POST )
	public ModelAndView getInternSelfEvalDetailPopupList(
				HttpSession session
			,  	HttpServletRequest request
			,	@RequestParam Map<String, Object> paramMap ) throws Exception {
		
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",   session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = internEvalService.getInternSelfEvalDetailPopupList(paramMap);
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
	 * 자기평가 상세팝업 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getInternSelfEvalDetailPopupList2", method = RequestMethod.POST )
	public ModelAndView getInternSelfEvalDetailPopupList2(
				HttpSession session
			,  	HttpServletRequest request
			,	@RequestParam Map<String, Object> paramMap ) throws Exception {
		
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",   session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = internEvalService.getInternSelfEvalDetailPopupList2(paramMap);
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
	 * 수습관찰표 목록 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getInternOtherEvalObservePopupList", method = RequestMethod.POST )
	public ModelAndView getInternOtherEvalObservePopupList(
				HttpSession session
			,  	HttpServletRequest request
			,	@RequestParam Map<String, Object> paramMap ) throws Exception {
		
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",   session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = internEvalService.getInternOtherEvalObservePopupList(paramMap);
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
	 * 수습관찰표 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getInternOtherEvalObservePopupList2", method = RequestMethod.POST )
	public ModelAndView getInternOtherEvalObservePopupList2(
				HttpSession session
			,  	HttpServletRequest request
			,	@RequestParam Map<String, Object> paramMap ) throws Exception {
		
		Log.DebugStart();
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",   session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = internEvalService.getInternOtherEvalObservePopupList2(paramMap);
			if (list.isEmpty()) {
				list = internEvalService.getInternOtherEvalObservePopupList2Default(paramMap);
			}
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
	 * 수습평가표 유저 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getInternOtherEvalSheetUserMap", method = RequestMethod.POST )
	public ModelAndView getInternOtherEvalSheetUserMap(
				HttpSession session
			,  	HttpServletRequest request
			,	@RequestParam Map<String, Object> paramMap ) throws Exception {
		
		Log.DebugStart();
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",   session.getAttribute("ssnSabun"));

		Map<?, ?> map  = new HashMap<String, Object>();
		String Message = "";
		try{
			map = internEvalService.getInternOtherEvalSheetUserMap(paramMap);
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
	 * 수습평가표 일정 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getInternOtherEvalSheetSchMap", method = RequestMethod.POST )
	public ModelAndView getInternOtherEvalSheetSchMap(
				HttpSession session
			,  	HttpServletRequest request
			,	@RequestParam Map<String, Object> paramMap ) throws Exception {
		
		Log.DebugStart();
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",   session.getAttribute("ssnSabun"));

		Map<?, ?> map  = new HashMap<String, Object>();
		String Message = "";
		try{
			map = internEvalService.getInternOtherEvalSheetSchMap(paramMap);
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
	 * 수습평가표 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getInternOtherEvalSheetListPopupList", method = RequestMethod.POST )
	public ModelAndView getInternOtherEvalSheetListPopupList(
				HttpSession session
			,  	HttpServletRequest request
			,	@RequestParam Map<String, Object> paramMap ) throws Exception {
		
		Log.DebugStart();
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",   session.getAttribute("ssnSabun"));

		List<?> list = new ArrayList<Object>();
		String Message = "";
		try{
			list = internEvalService.getInternOtherEvalSheetListPopupList(paramMap);
			if (list.isEmpty()) {
				list = internEvalService.getInternOtherEvalSheetListPopupListDefault(paramMap);
			}
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
	@RequestMapping(params="cmd=saveInternSelfEvalDetailPopup", method = RequestMethod.POST )
	public ModelAndView saveInternSelfEvalDetailPopup(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		convertMap.put("ssnSabun", session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));

		String message = "";
		int resultCnt = -1;

		try{
			if ("3".equalsIgnoreCase(String.valueOf(paramMap.get("appStatus")))) { // 평가자
				resultCnt = internEvalService.saveInternSelfEvalDetailPopup2(convertMap);
			} else { // 평가대상자
				resultCnt = internEvalService.saveInternSelfEvalDetailPopup(convertMap);
			}
			if(resultCnt > 0){ message="저장되었습니다."; } else{ message="저장된 내용이 없습니다."; }
		}catch(Exception e){
			e.printStackTrace();
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
	 * 타인평가 리스트 팝업 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getInternOtherEvalListPopupList", method = RequestMethod.POST )
	public ModelAndView getInternOtherEvalListPopupList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
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
	@RequestMapping(params="cmd=saveInternOtherEvalObservePopup", method = RequestMethod.POST )
	public ModelAndView saveInternOtherEvalObservePopup(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		convertMap.put("ssnSabun", session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		convertMap.put("sabun", paramMap.get("sabun"));
		convertMap.put("appSabun", paramMap.get("appSabun"));
		convertMap.put("appStepCd", paramMap.get("appStepCd"));
		convertMap.put("appraisalCd", paramMap.get("appraisalCd"));
		convertMap.put("appSeqDetail", paramMap.get("appSeqDetail"));
		convertMap.put("appCont", paramMap.get("appCont"));
		String message = "";
		int resultCnt = -1;

		try{
			resultCnt = internEvalService.saveInternOtherEvalObservePopup(convertMap);
			if(resultCnt > 0){ message="저장되었습니다."; } else{ message="저장된 내용이 없습니다."; }
		}catch(Exception e){
			e.printStackTrace();
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
	 * 자기평가 상세팝업 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveInternOtherEvalSheetListPopup", method = RequestMethod.POST )
	public ModelAndView saveInternOtherEvalSheetListPopup(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		convertMap.put("ssnSabun", session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		convertMap.put("sabun", paramMap.get("sabun"));
		convertMap.put("appSabun", paramMap.get("appSabun"));
		convertMap.put("appStepCd", paramMap.get("appStepCd"));
		convertMap.put("appraisalCd", paramMap.get("appraisalCd"));
		convertMap.put("appSeqDetail", paramMap.get("appSeqDetail"));
		convertMap.put("appCont", paramMap.get("appCont"));
		String message = "";
		int resultCnt = -1;

		try{
			resultCnt = internEvalService.saveInternOtherEvalSheetListPopup(convertMap);
			if(resultCnt > 0){ message="저장되었습니다."; } else{ message="저장된 내용이 없습니다."; }
		}catch(Exception e){
			e.printStackTrace();
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
