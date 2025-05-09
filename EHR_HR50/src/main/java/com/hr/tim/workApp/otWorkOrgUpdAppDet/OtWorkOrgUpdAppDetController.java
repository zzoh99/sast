package com.hr.tim.workApp.otWorkOrgUpdAppDet;
import java.io.Serializable;
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

import com.hr.common.com.ComController;
import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;

/**
 * 연장근무변경신청 세부내역 Controller
 *
 * @author
 *
 */
@Controller
@RequestMapping({"/OtWorkOrgUpdApp.do","/OtWorkOrgUpdAppDet.do"})
public class OtWorkOrgUpdAppDetController extends ComController {

	/**
	 * 연장근무변경신청 세부내역 서비스
	 */
	@Inject
	@Named("OtWorkOrgUpdAppDetService")
	private OtWorkOrgUpdAppDetService otWorkOrgUpdAppDetService;

	/**
	 * 연장근무변경신청 세부내역 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewOtWorkOrgUpdAppDet", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewOtWorkOrgUpdAppDet() throws Exception {
		return "tim/workApp/otWorkOrgUpdAppDet/otWorkOrgUpdAppDet";
	}
	
	/**
	 * 연장근무변경신청 상세 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getOtWorkOrgUpdAppDetMap", method = RequestMethod.POST )
	public ModelAndView getOtWorkOrgUpdAppDetMap(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataMap(session, request, paramMap);
	}

	
	/**
	 * 단위기간 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getOtWorkOrgUpdAppDetTerDate", method = RequestMethod.POST )
	public ModelAndView getOtWorkOrgUpdAppDetTerDate(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataMap(session, request, paramMap);
	}
	
	/**
	 * 연장근무변경신청 상세 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getOtWorkOrgUpdAppDetList", method = RequestMethod.POST )
	public ModelAndView getOtWorkOrgUpdAppDetList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}
	
	/**
	 * 인정근무시간조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getOtWorkOrgUpdAppDetTimeMap", method = RequestMethod.POST )
	public ModelAndView getOtWorkOrgUpdAppDetTimeList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));

		return getDataMap(session, request, paramMap);
	}

	/**
	 * 기신청건 체크
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getOtWorkOrgUpdAppDetDupCnt", method = RequestMethod.POST )
	public ModelAndView getOtWorkOrgUpdAppDetDupCnt(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		return getDataMap(session, request, convertMap);
	}
	/**
	 * 연장근무시간 한도 체크
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getOtWorkOrgUpdAppDetCheckTime", method = RequestMethod.POST )
	public ModelAndView getOtWorkOrgUpdAppDetCheckTime(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		return getDataMap(session, request, convertMap);
	}
	
	/**
	 * 연장근무변경신청  저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveOtWorkOrgUpdAppDet", method = RequestMethod.POST )
	public ModelAndView saveOtWorkOrgUpdAppDet(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

		String message = "";
		int resultCnt = -1;
		try{
			resultCnt = otWorkOrgUpdAppDetService.saveOtWorkOrgUpdAppDet(convertMap);
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