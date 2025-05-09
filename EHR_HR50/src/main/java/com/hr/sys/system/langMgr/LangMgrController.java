package com.hr.sys.system.langMgr;
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
 * 언어관리 Controller
 *
 * @author CBS
 *
 */
@Controller
@RequestMapping(value="/LangMgr.do", method=RequestMethod.POST )
public class LangMgrController {

	/**
	 * 언어관리 서비스
	 */
	@Inject
	@Named("LangMgrService")
	private LangMgrService langMgrService;

	/**
	 *  언어관리 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewLangMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewLangMgr() throws Exception {
		return "sys/system/langMgr/langMgr";
	}


	/**
	 * 언어관리 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getLangMgrList", method = RequestMethod.POST )
	public ModelAndView getLangMgrList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		List<?> list  = new ArrayList<Object>();
		String message = "";
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		try{
			list = langMgrService.getLangMgrList(paramMap);
		}catch(Exception e){
			message = "조회에 실패 하였습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", message);
		Log.DebugEnd();
		return mv;
	}


	/**
	 * 언어관리 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */

	@RequestMapping(params="cmd=saveLangMgr", method = RequestMethod.POST )
	public ModelAndView saveLangMgr(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();

		// 열로 된 데이터들을 Map 형태의 연관된 데이터 셋으로 만들기 위해
		// 같이 묶여질 param명을 ,구분자 포함하여 만든다.
		// 파싱할 항목을 , 로 구분하여 스트링형태로 생성
		//String getParamNames ="sNo,sDelete,sStatus,langCd,langNm,countryCd,seq,useYn";

		// Request에서 파싱하여 저장용도로 Param을 따로 구성
		// 파싱된 객체 목록
		// "mergeRows" 	merge문을 사용하여 update,insert를 한번에 처리하기 위한 저장 List
		// "insertRows" 생성 List
		// "updateRows" 수정 List
		// "deleteRows" 삭제 List
		//Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,getParamNames,"");
		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");

		//convertMap.put("ssnSabun", session.getAttribute("ssnSabun"));
		//convertMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));

		String Message = "";
		int resultCnt = -1;
		try{
			resultCnt =langMgrService.saveLangMgr(convertMap);
			if(resultCnt > 0){ Message = "저장되었습니다."; }
			else{ Message = "저장된 내용이 없습니다."; }
		}catch(Exception e){
			resultCnt = -1; Message = "저장에 실패 하였습니다.";
		}


		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("Code", resultCnt);
		resultMap.put("Message", Message);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Result", resultMap);
		Log.DebugEnd();
		return mv;
	}


	/**
	 * 언어관리 삭제
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=deleteLangMgr", method = RequestMethod.POST )
	public ModelAndView deleteLangMgr(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		//String getParamNames ="sNo,sDelete,sStatus,langId,langNm,langEngNm,seq,useYn";
		//Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,getParamNames,"");
		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		//convertMap.put("ssnSabun", session.getAttribute("ssnSabun"));
		//convertMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));

		String Message = "";
		int resultCnt = -1;
		try{
			resultCnt = langMgrService.deleteLangMgr(convertMap);
			if(resultCnt > 0){ Message = "삭제되었습니다."; }
			else{ Message = "삭제된 내용이 없습니다."; }
		}catch(Exception e){
			resultCnt = -1; Message = "삭제에 실패 하였습니다.";
		}



		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("Code", resultCnt);
		resultMap.put("Message", Message);

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Result", resultMap);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 시스템사용자관리 기준코드 설명 팝업 View
	 *
	 * @return String
	 * @throws Exception
	 */
	/*
	@RequestMapping(params="cmd=dbItemMgrPopup", method = RequestMethod.POST )
	public String dbItemMgrPopup() throws Exception {
		return "sys/system/dbItemMgr/dbItemMgrPopup";
	}
	*/




	/**
	 * 사용언어관리 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getUseLangMgrList", method = RequestMethod.POST )
	public ModelAndView getUseLangMgrList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		List<?> list  = new ArrayList<Object>();
		String message = "";
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		try{
			list = langMgrService.getUseLangMgrList(paramMap);
		}catch(Exception e){
			message = "조회에 실패 하였습니다";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", message);
		Log.DebugEnd();
		return mv;
	}


	/**
	 * 사용언어관리 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveUseLangMgr", method = RequestMethod.POST )
	public ModelAndView saveUseLangMgr(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

		String Message = "";
		int resultCnt = -1;
		try{
			resultCnt = langMgrService.saveUseLangMgr(convertMap);
			if(resultCnt > 0){ Message = "저장되었습니다."; }
			else{ Message = "저장된 내용이 없습니다."; }
		}catch(Exception e){
			resultCnt = -1;
			Message =  "저장에 실패 하였습니다.";
		}

		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("Code", resultCnt);
		resultMap.put("Message", Message);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Result", resultMap);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 언어관리 삭제
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=deleteUseLangMgr", method = RequestMethod.POST )
	public ModelAndView deleteUseLangMgr(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		String getParamNames ="sNo,sDelete,sStatus,langId,seq,useYn,defaultYn";
		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,getParamNames,"");
		//convertMap.put("ssnSabun", session.getAttribute("ssnSabun"));
		//convertMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));

		String Message = "";
		int resultCnt = -1;
		try{
			resultCnt = langMgrService.deleteUseLangMgr(convertMap);
			if(resultCnt > 0){ Message = "삭제되었습니다."; }
			else{ Message = "삭제된 내용이 없습니다."; }
		}catch(Exception e){
			resultCnt = -1; Message = "삭제에 실패하였습니다.";
		}


		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("Code", resultCnt);
		resultMap.put("Message", Message);

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Result", resultMap);
		Log.DebugEnd();
		return mv;
	}


}
