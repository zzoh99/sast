package com.hr.hrd.code.workSklKnlgMgr;

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

/**
 * 평가조직관리 Controller
 *
 * @author CBS
 *
 */
@Controller
@RequestMapping(value="/WorkSklKnlgMgr.do", method=RequestMethod.POST )
public class WorkSklKnlgMgrController {
	/**
	 * 평가조직관리 서비스
	 */
	@Inject
	@Named("WorkSklKnlgMgrService")
	private WorkSklKnlgMgrService workSklKnlgMgrService;

	/**
	 * 평가조직관리 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewWorkSklKnlgMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewWorkSklKnlgMgr() throws Exception {
		return "hrd/code/workSklKnlgMgr/workSklKnlgMgr";
	}

	@RequestMapping(params="cmd=viewTRMRegPopup", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewSelfDevelopmentTRMPopup(HttpSession session, HttpServletRequest request,@RequestParam Map<String, Object> paramMap) throws Exception {
		return "hrd/trm/workSklKnlgMgr/trmRegPopup";
	}

	@RequestMapping(params="cmd=viewTrmEduPopup", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewTrmEduPopup(HttpSession session, HttpServletRequest request,@RequestParam Map<String, Object> paramMap) throws Exception {
		return "hrd/trm/workSklKnlgMgr/trmEduPopup";
	}

	@RequestMapping(params="cmd=viewTrmEduEventMgrPopup", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewTrmEduEventMgrPopup() throws Exception {
		return "hrd/trm/WorkSklKnlgMgr/trmEduEventMgrPopup";
	}

	@RequestMapping(params="cmd=getWorkSklMgrList", method = RequestMethod.POST )
	public ModelAndView getWorkSklMgrList(HttpSession session,  HttpServletRequest request,@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		List<?> list  = new ArrayList<Object>();
		String Message = "";
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		try{
			list = workSklKnlgMgrService.getWorkSklMgrList(paramMap);
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

	@RequestMapping(params="cmd=getWorkKnlgMgrList", method = RequestMethod.POST )
	public ModelAndView getWorkKnlgMgrList(HttpSession session,  HttpServletRequest request,@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		List<?> list  = new ArrayList<Object>();
		String Message = "";
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		try{
			list = workSklKnlgMgrService.getWorkKnlgMgrList(paramMap);
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


	@RequestMapping(params="cmd=getTRMRegList", method = RequestMethod.POST )
	public ModelAndView getTRMRegList(HttpSession session,  HttpServletRequest request,@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		List<?> list  = new ArrayList<Object>();
		String Message = "";
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		try{
			list = workSklKnlgMgrService.getTRMRegList(paramMap);
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




	@RequestMapping(params="cmd=getTRMEduPopupList", method = RequestMethod.POST )
	public ModelAndView getTRMEduPopupList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		List<?> list  = new ArrayList<Object>();
		String Message = "";
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		try{
			list = workSklKnlgMgrService.getTRMEduPopupList(paramMap);
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
	 * 평가조직관리 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
/*	@RequestMapping(params="cmd=getTRMManageList", method = RequestMethod.POST )
	public ModelAndView getAppOrgSchemeMgrList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		List<?> list  = new ArrayList<Object>();
		String Message = "";
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		try{
			list = trmManageService.getAppOrgSchemeMgrList(paramMap);
		}catch(Exception e){
			Message="조회에 실패하였습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}*/

	/**
	 * 평가조직관리 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveTRM", method = RequestMethod.POST )
	public ModelAndView saveAppOrgSchemeMgr(
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
			resultCnt = workSklKnlgMgrService.saveTRM(convertMap);
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
	 * TRM조회화면 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveWorkSklKnlgMgrList", method = RequestMethod.POST )
	public ModelAndView saveWorkSklKnlgMgrList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		convertMap.put("searchBizType", paramMap.get("searchBizType"));

		String message = "";
		int resultCnt = -1;
		try{
			resultCnt = workSklKnlgMgrService.saveWorkSklKnlgMgrList(convertMap);
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
