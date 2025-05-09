package com.hr.pap.config.appraisalIdMgr;
import java.util.Base64;
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
import com.hr.common.language.LanguageUtil;
import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;

/**
 * 평가ID관리 Controller 
 * 
 * @author JSG
 *
 */
@Controller
@RequestMapping(value="/AppraisalIdMgr.do", method=RequestMethod.POST )
public class AppraisalIdMgrController extends ComController {
	/**
	 * 사용할 서비스 선언
	 */
	@Inject
	@Named("AppraisalIdMgrService")
	private AppraisalIdMgrService appraisalIdMgrService;
	
	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;
	
	/**
	 * 평가ID관리 View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewAppraisalIdMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewAppraisalIdMgr() throws Exception {
		return "pap/config/appraisalIdMgr/appraisalIdMgr";
	}

	/**
	 * 평가ID관리 팝업 View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewAppraisalIdMgrPop", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewAppraisalIdMgrPop() throws Exception {
		return "pap/config/appraisalIdMgr/appraisalIdMgrPop";
	}

	@RequestMapping(params="cmd=viewAppraisalIdMgrLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewAppraisalIdMgrLayer() {
		return "pap/config/appraisalIdMgr/appraisalIdMgrLayer";
	}
	
	/**
	 * 평가ID관리 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAppraisalIdMgrList", method = RequestMethod.POST )
	public ModelAndView getAppraisalIdMgrList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}
	
	/**
	 * 평가ID관리 저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveAppraisalIdMgr", method = RequestMethod.POST )
	public ModelAndView saveAppraisalIdMgr(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return saveData(session, request, paramMap);
	}
	
	/**
	 * 평가ID관리 단건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAppraisalIdMgrMap", method = RequestMethod.POST )
	public ModelAndView getAppraisalIdMgrMap(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		Map<?, ?> map = appraisalIdMgrService.getAppraisalIdMgrMap(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("resultMap", map);
		Log.DebugEnd();
		return mv;
	}
	
	/**
	 * 평가ID관리 MAX 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAppraisalIdMgrCodeSeq", method = RequestMethod.POST )
	public ModelAndView getAppraisalIdMgrCodeSeq(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		Map<?, ?> map = appraisalIdMgrService.getAppraisalIdMgrCodeSeq(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("map", map);
		Log.DebugEnd();
		return mv;
	}
	
	/**
	 * 평가ID관리 DEL CHECK 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAppraisalIdMgrDelCheck", method = RequestMethod.POST )
	public ModelAndView getTemplateMap(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		Map<?, ?> map = appraisalIdMgrService.getAppraisalIdMgrDelCheck(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("map", map);
		Log.DebugEnd();
		return mv;
	}
	
	
	/**
	 * 평가ID관리 생성
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=insertAppraisalIdMgr", method = RequestMethod.POST )
	public ModelAndView insertAppraisalIdMgr(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();
		String getParamNames ="sNo,sDelete,sStatus,prgCd,prgNm,prgEngNm,prgPath,use,version,memo,dateTrackYn,logSaveYn";
		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,getParamNames,"");
		convertMap.put("ssnSabun", session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		
		String message = "";
		int resultCnt = -1;
		try{
			resultCnt = appraisalIdMgrService.insertAppraisalIdMgr(convertMap);
			if(resultCnt > 0){ message="생성 되었습니다."; }
			else{ message="생성된 내용이 없습니다."; }
		}catch(Exception e){
			resultCnt = -1;
			message="생성에 실패하였습니다.";
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
	 * 평가ID관리 수정
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=updateAppraisalIdMgr", method = RequestMethod.POST )
	public ModelAndView updateAppraisalIdMgr(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		String getParamNames ="sNo,sDelete,sStatus,prgCd,prgNm,prgEngNm,prgPath,use,version,memo,dateTrackYn,logSaveYn";
		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,getParamNames,"");
		convertMap.put("ssnSabun", session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		
		String message = "";
		int resultCnt = -1;
		try{
			resultCnt = appraisalIdMgrService.updateAppraisalIdMgr(convertMap);
			if(resultCnt > 0){ message="수정되었습니다."; }
			else{ message="수정된 내용이 없습니다."; }
		}catch(Exception e){
			resultCnt = -1;
			message="수정에 실패하였습니다.";
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
	 * 평가ID관리 삭제
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=deleteAppraisalIdMgr", method = RequestMethod.POST )
	public ModelAndView deleteAppraisalIdMgr(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		String getParamNames ="sNo,sDelete,sStatus,prgCd,prgNm,prgEngNm,prgPath,use,version,memo,dateTrackYn,logSaveYn";
		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,getParamNames,"");
		convertMap.put("ssnSabun", session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		
		String message = "";
		int resultCnt = -1;
		try{
			// 삭제 서비스 호출
			resultCnt = appraisalIdMgrService.deleteAppraisalIdMgr(convertMap);
			if(resultCnt > 0){ message="삭제되었습니다."; }
			else{ message="삭제된 내용이 없습니다."; }
		}catch(Exception e){
			resultCnt = -1;
			message="삭제에 실패하였습니다.";
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
	 * 평가ID관리 > 일정 탭 View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewAppraisalIdMgrTab1", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewAppraisalIdMgrTab1() throws Exception {
		return "pap/config/appraisalIdMgr/appraisalIdMgrTab1";
	}

	/**
	 * 평가ID관리 > 일정 탭 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAppraisalIdMgrTab1", method = RequestMethod.POST )
	public ModelAndView getAppraisalIdMgrTab1(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}

	/**
	 * 평가ID관리 > 일정 탭 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveAppraisalIdMgrTab1", method = RequestMethod.POST )
	public ModelAndView saveAppraisalIdMgrTab1(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return saveData(session, request, paramMap);
	}
	
	/**
	 * 근로계약서관리 Contents 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveAppraisalIdMgrTab1Guide", method = RequestMethod.POST )
	public ModelAndView saveEmpContractMgrContents(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		String message = "";
		int resultCnt = -1;
		
		try{
			resultCnt = appraisalIdMgrService.saveAppraisalIdMgrTab1Guide(paramMap);
			if(resultCnt > 0){ message="수정되었습니다."; }
			else{ message="수정된 내용이 없습니다."; }
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


	/**
	 * 평가ID관리 > 목표/실적일정 탭 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewAppraisalIdMgrTab2", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewAppraisalIdMgrTab2() throws Exception {
		return "pap/config/appraisalIdMgr/appraisalIdMgrTab2";
	}

	/**
	 * 평가ID관리 > 목표/실적일정 탭 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAppraisalIdMgrTab2", method = RequestMethod.POST )
	public ModelAndView getAppraisalIdMgrTab2(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}

	/**
	 * 평가ID관리 > 목표/실적일정 탭 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveAppraisalIdMgrTab2", method = RequestMethod.POST )
	public ModelAndView saveAppraisalIdMgrTab2(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return saveData(session, request, paramMap);
	}

	/**
	 * 평가ID관리 > 최종평가일정 탭 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewAppraisalIdMgrTab3", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewAppraisalIdMgrTab3() throws Exception {
		return "pap/config/appraisalIdMgr/appraisalIdMgrTab3";
	}

	/**
	 * 평가ID관리 > 최종평가일정 탭 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAppraisalIdMgrTab3", method = RequestMethod.POST )
	public ModelAndView getAppraisalIdMgrTab3(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}

	/**
	 * 평가ID관리 > 최종평가일정 탭 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveAppraisalIdMgrTab3", method = RequestMethod.POST )
	public ModelAndView saveAppraisalIdMgrTab3(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return saveData(session, request, paramMap);
	}

	/**
	 * 평가ID관리 > 이의제기일정 탭 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewAppraisalIdMgrTab4", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewAppraisalIdMgrTab4() throws Exception {
		return "pap/config/appraisalIdMgr/appraisalIdMgrTab4";
	}

	/**
	 * 평가ID관리 > 이의제기일정 탭 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAppraisalIdMgrTab4", method = RequestMethod.POST )
	public ModelAndView getAppraisalIdMgrTab4(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}

	/**
	 * 평가ID관리 > 이의제기일정 탭 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveAppraisalIdMgrTab4", method = RequestMethod.POST )
	public ModelAndView saveAppraisalIdMgrTab4(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return saveData(session, request, paramMap);
	}

}
