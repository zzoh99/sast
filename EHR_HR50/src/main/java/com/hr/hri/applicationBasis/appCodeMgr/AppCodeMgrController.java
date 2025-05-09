package com.hr.hri.applicationBasis.appCodeMgr;

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
import com.hr.common.com.ComService;
import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;

/**
 * 신청서 코드 관리
 *
 * @author ParkMoohun
 */
@Controller
@RequestMapping(value="/AppCodeMgr.do", method=RequestMethod.POST )
public class AppCodeMgrController extends ComController {
	/**
	 * 공통 서비스
	 */
	@Inject
	@Named("ComService")
	private ComService comService;
	
	@Inject
	@Named("AppCodeMgrService")
	private AppCodeMgrService appCodeMgrService;

	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;
	/**
	 * 신청서 코드 관리 화면
	 *
	 * @param paramMap
	 * @param request
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewAppCodeMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewAppCodeMgr(
			@RequestParam Map<String, Object> paramMap,
			HttpServletRequest request) throws Exception {
		Log.Debug("AppCodeMgrController.viewAppCodeMgr");
		return "hri/applicationBasis/appCodeMgr/appCodeMgr";
	}

	/**
	 * 신청서 코드 관리 화면
	 *
	 * @param paramMap
	 * @param request
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewAppCodeNoteMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewAppCodeNoteMgr(
			@RequestParam Map<String, Object> paramMap,
			HttpServletRequest request) throws Exception {
		Log.Debug("AppCodeMgrController.viewAppCodeNoteMgr");
		return "hri/applicationBasis/appCodeMgr/appCodeNoteMgr";
	}

	/**
	 * 신청서 코드 관리 화면
	 *
	 * @param paramMap
	 * @param request
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewAppEtcNotePopup", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewAppEtcNotePopup(
			@RequestParam Map<String, Object> paramMap,
			HttpServletRequest request) throws Exception {
		Log.Debug("AppCodeMgrController.viewAppCodeNoteMgr");
		return "hri/applicationBasis/appCodeMgr/appEtcNotePopup";
	}
	
	/**
	 * 신청서 코드 관리 화면
	 *
	 * @param paramMap
	 * @param request
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewAppEtcNoteLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewAppEtcNoteLayer(
			@RequestParam Map<String, Object> paramMap,
			HttpServletRequest request) throws Exception {
		Log.Debug("AppCodeMgrController.viewAppCodeNoteMgr");
		return "hri/applicationBasis/appCodeMgr/appEtcNoteLayer";
	}
	
	/**
	 * 신청서 수신자 관리 화면
	 *
	 * @param paramMap
	 * @param request
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewAppCodeRecevMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewAppCodeRecevMgr(
			@RequestParam Map<String, Object> paramMap,
			HttpServletRequest request) throws Exception {
		Log.Debug("AppCodeMgrController.viewAppCodeRecevMgr");
		return "hri/applicationBasis/appCodeMgr/appCodeRecevMgr";
	}

	/**
	 * 신청서 코드 관리 리스트 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAppCodeMgrList", method = RequestMethod.POST )
	public ModelAndView getAppCodeMgrList(HttpSession session,
			HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		//한글이 들어 올경우 UTF-8로 Convertion해줘야 된다.
		paramMap = ParamUtils.converterParams(request);
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));

		List<?> result = appCodeMgrService.getAppCodeMgrList(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", result);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 결재선 조건검색 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAppCodeSearchSeqList", method = RequestMethod.POST )
	public ModelAndView getAppCodeSearchSeqList(HttpSession session,
			HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));

		List<?> result = appCodeMgrService.getAppCodeSearchSeqList(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", result);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 신청서 코드 관리 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveAppCodeMgr", method = RequestMethod.POST )
	public ModelAndView saveAppCodeMgr(HttpSession session,
			HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		String ssnEnterCd = session.getAttribute("ssnEnterCd").toString();
		convertMap.put("ssnSabun", session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd", ssnEnterCd);

		String message = "";
		Map<String, Object> resultMap = new HashMap<String, Object>();
		List<Map> insertList = (List<Map>)convertMap.get("insertRows");
		List<Map<String,Object>> dupList = new ArrayList<Map<String,Object>>();
		int cnt = 0;
		if(insertList.size()>0){
    		for(Map<String,Object> mp : insertList) { Map<String,Object> dupMap = new HashMap<String,Object>();
    			dupMap.put("ENTER_CD"	,ssnEnterCd);
    			dupMap.put("APPL_CD"	,mp.get("applCd"));
    			dupList.add(dupMap);
    		}
    		try{ cnt = commonCodeService.getDupCnt("THRI101", "ENTER_CD,APPL_CD", "s,s",dupList);
	    		if(cnt > 0 ) cnt = -1; message="중복된 값이 존재 합니다.";
    		}catch(Exception e){ cnt = -1; message="중복 체크에 실패하였습니다."; }
		}
		if(cnt == 0){
			try{ cnt = appCodeMgrService.saveAppCodeMgr(convertMap);
				if (cnt > 0) { message="저장 되었습니다."; }  else { message="저장된 내용이 없습니다."; }
			}catch(Exception e){ cnt=-1; message="저장 실패 하였습니다."; }
		}
		resultMap.put("Code", 		cnt); resultMap.put("Message", 	message);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView"); mv.addObject("Result", resultMap);
		Log.Debug("Result Message : " + mv);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 신청서 코드 관리 상세 화면
	 *
	 * @param paramMap
	 * @param request
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewAppCodeMgrDetailPopup", method = {RequestMethod.POST, RequestMethod.GET} )
	public String appCodeMgrDetailPopup(HttpSession session,
			@RequestParam Map<String, Object> paramMap,
			HttpServletRequest request) throws Exception {
		Log.Debug("AppCodeMgrController.appCodeMgrDetailPopup");
		return "hri/applicationBasis/appCodeMgr/appCodeMgrDetailPopup";
	}

	/**
	 * 신청서 코드 관리 결재자 등록 화면
	 *
	 * @param paramMap
	 * @param request
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewAppCodeMgrPopup", method = {RequestMethod.POST, RequestMethod.GET} )
	public String appCodeMgrPopup(HttpSession session,
			@RequestParam Map<String, Object> paramMap,
			HttpServletRequest request) throws Exception {
		Log.Debug("AppCodeMgrController.appCodeMgrPopup");
		return "hri/applicationBasis/appCodeMgr/appCodeMgrPopup";
	}

	/**
	 * 신청서 코드 관리 결재자 등록 화면
	 *
	 * @param paramMap
	 * @param request
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewAppCodeMgrLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public String appCodeMgrLayer(HttpSession session,
			@RequestParam Map<String, Object> paramMap,
			HttpServletRequest request) throws Exception {
		Log.Debug("AppCodeMgrController.appCodeMgrPopup");
		return "hri/applicationBasis/appCodeMgr/appCodeMgrLayer";
	}
	
	/**
	 * 신청서 코드 관리 결재자 등록 화면
	 *
	 * @param paramMap
	 * @param request
	 * @return String
	 * @throws Exception
	 */
//	@RequestMapping(params="cmd=viewAppEtcNotePopup", method = {RequestMethod.POST, RequestMethod.GET} )
//	public String appEtcNotePopup(HttpSession session,
//			@RequestParam Map<String, Object> paramMap,
//			HttpServletRequest request) throws Exception {
//		Log.Debug("AppCodeMgrController.appEtcNotePopup");
//		return "hri/applicationBasis/appCodeMgr/appEtcNotePopup";
//	}

	/**
	 * 신청서 코드 관리 팝업 리스트 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView          
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAppCodeMgrPopupList", method = RequestMethod.POST )
	public ModelAndView getAppCodeMgrPopupList(HttpSession session,
			HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		//한글이 들어 올경우 UTF-8로 Convertion해줘야 된다.
		paramMap = ParamUtils.converterParams(request);
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));

		List<?> result = appCodeMgrService.getAppCodeMgrPopupList(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", result);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 신청서 코드 관리 팝업 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveAppCodeMgrPopup", method = RequestMethod.POST )
	public ModelAndView saveAppCodeMgrPopup(HttpSession session,
			HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		return saveData(session, request, paramMap);
	}

	/**
	 * 신청서유의사항 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveAppCodeNoteMgr", method = RequestMethod.POST )
	public ModelAndView saveAppCodeNoteMgr(HttpSession session,
			HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		return saveData(session, request, paramMap);
	}
	/**
	 * 유의사항(첨부파일 저장)
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveAppAttFile", method = RequestMethod.POST )
	public ModelAndView saveAppAttFile(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.Debug("AppCodeMgrController.saveAppAttFile Start");

		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

		String message = "";
		int resultCnt = -1;
		try{
			resultCnt = appCodeMgrService.saveAppAttFile(paramMap);
			if(resultCnt > 0){ message="저장 되었습니다."; } else{ message="저장된 내용이 없습니다."; }
		}catch(Exception e){
			resultCnt = -1; message="저장에 실패하 였습니다.";
		}

		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("Code", resultCnt);
		resultMap.put("Message", message);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Result", resultMap);
		Log.Debug("AppCodeMgrController.saveAppAttFile End");
		return mv;
	}


	/**
	 * 수신여부 저장
	 */
	@RequestMapping(params="cmd=saveAppCodeMgrRecevYn", method = RequestMethod.POST )
	public ModelAndView saveAppCodeMgrRecevYn(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		
		String message = "";
		int resultCnt = -1;
		try{
			resultCnt = comService.saveData(convertMap);
			if(resultCnt > 0){ message=com.hr.common.language.LanguageUtil.getMessage("msg.alertSaveOkV1", null, "저장 되었습니다."); } else{ message=com.hr.common.language.LanguageUtil.getMessage("msg.alertSaveNoData", null, "저장된 내용이 없습니다."); }
			
		}catch(Exception e){
			resultCnt = -1; message=com.hr.common.language.LanguageUtil.getMessage("msg.alertSaveFail2", null, "저장에 실패하였습니다.");
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
	 * 신청서 팝업 Size
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAppCodeMgrPopSize", method = RequestMethod.POST )
	public ModelAndView getAppCodeMgrPopSize(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataMap(session, request, paramMap);
	}

	@RequestMapping(params="cmd=getAppCodeMgrModalSize", method = RequestMethod.POST )
	public ModelAndView getAppCodeMgrModalSize(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		return getDataMap(session, request, paramMap);
	}

}