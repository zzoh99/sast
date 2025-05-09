package com.hr.hri.commonApproval.comAppFormMgr;
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

import com.hr.common.code.CommonCodeService;
import com.hr.common.com.ComController;
import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;

/**
 * 공통신청서양식관리 Controller 
 * 
 * @author 이름
 *
 */
@Controller
@RequestMapping(value="/ComAppFormMgr.do", method=RequestMethod.POST )
public class ComAppFormMgrController extends ComController {
	/**
	 * 공통신청서양식관리 서비스
	 */
	@Inject
	@Named("ComAppFormMgrService")
	private ComAppFormMgrService comAppFormMgrService;	
	
	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;
	
	
	/**
	 * 공통신청서양식관리 View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewComAppFormMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewComAppFormMgr() throws Exception {
		return "hri/commonApproval/comAppFormMgr/comAppFormMgr";
	}
	
	/**
	 * 에디터
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewIframeEditor", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewIframeEditor() throws Exception {
		//return "../../common/plugin/Editor/iframe_editor";
		return "common/plugin/Editor/include_editor";
	}

	/**
	 * 공통신청서 미리보기 팝업 View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewComAppFormMgrPreview", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewComAppFormMgrPreview() throws Exception {
		return "hri/commonApproval/comAppFormMgr/comAppFormMgrPreview";
	}

	/**
	 * 공통신청서 미리보기 팝업 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewIframeComAppFormMgrForm", method = {RequestMethod.POST, RequestMethod.GET} )
	public ModelAndView viewIframeComAppFormMgrForm(HttpSession session,
													@RequestParam Map<String, Object> paramMap,
													HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("hri/commonApproval/comAppFormMgr/iframeComAppFormMgrForm");
		mv.addObject("authPg", paramMap.get("authPg"));
		return mv;
	}

	/**
	 * 공통신청서양식관리 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getComAppFormMgrList", method = RequestMethod.POST )
	public ModelAndView getComAppFormMgrList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}
	
	/**
	 * 공통신청서양식관리 신청서코드 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getComAppFormMgrApplCdList", method = RequestMethod.POST )
	public ModelAndView getComAppFormMgrApplCdList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}

	/**
	 * 공통신청서양식관리 신청서항목 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getComAppFormMgrColList", method = RequestMethod.POST )
	public ModelAndView getComAppFormMgrColList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}

	/**
	 * 공통신청서양식관리 신청서항목 미리보기 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getComAppFormMgrColViewList", method = RequestMethod.POST )
	public ModelAndView getComAppFormMgrColViewList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}
	
	
	/**
	 * 공통신청서양식관리 저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveComAppFormMgr", method = RequestMethod.POST )
	public ModelAndView saveComAppFormMgr(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));

		String message = "";
		int resultCnt = -1;
		try{
			resultCnt = comAppFormMgrService.saveComAppFormMgr(convertMap);
			
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
	 * 공통신청서양식관리 신청서항목 저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveComAppItemMgrCol", method = RequestMethod.POST )
	public ModelAndView saveComAppItemMgrCol(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();  
		
		return saveData(session, request, paramMap);
	}


}
