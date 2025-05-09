package com.hr.tim.workApp.otWorkOrgAppDet;

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

import com.hr.common.com.ComController;
import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;

/**
 * 연장근무사전신청 세부내역 Controller
 *
 * @author
 *
 */
@Controller
@RequestMapping({"/OtWorkOrgApp.do","/OtWorkOrgAppDet.do"})
public class OtWorkOrgAppDetController extends ComController {

	/**
	 * 연장근무사전신청 세부내역 서비스
	 */
	@Inject
	@Named("OtWorkOrgAppDetService")
	private OtWorkOrgAppDetService otWorkOrgAppDetService;

	/**
	 * 연장근무사전신청 세부내역 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewOtWorkOrgAppDet", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewOtWorkOrgAppDet() throws Exception {
		return "tim/workApp/otWorkOrgAppDet/otWorkOrgAppDet";
	}
	
	/**
	 * 연장근무사전신청 상세 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getOtWorkOrgAppDetMap", method = RequestMethod.POST )
	public ModelAndView getOtWorkOrgAppDetMap(
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
	@RequestMapping(params="cmd=getOtWorkOrgAppDetTerDate", method = RequestMethod.POST )
	public ModelAndView getOtWorkOrgAppDetTerDate(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataMap(session, request, paramMap);
	}
	
	/**
	 * 연장근무사전신청 상세 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getOtWorkOrgAppDetList", method = RequestMethod.POST )
	public ModelAndView getOtWorkOrgAppDetList(
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
	@RequestMapping(params="cmd=getOtWorkOrgAppDetTimeMap", method = RequestMethod.POST )
	public ModelAndView getOtWorkOrgAppDetTimeList(
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
	@RequestMapping(params="cmd=getOtWorkOrgAppDetDupCnt", method = RequestMethod.POST )
	public ModelAndView getOtWorkOrgAppDetDupCnt(
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
	@RequestMapping(params="cmd=getOtWorkOrgAppDetCheckTime", method = RequestMethod.POST )
	public ModelAndView getOtWorkOrgAppDetCheckTime(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		return getDataMap(session, request, convertMap);
	}
	
	/**
	 * 연장근무사전신청  저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveOtWorkOrgAppDet", method = RequestMethod.POST )
	public ModelAndView saveOtWorkOrgAppDet(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

		String message = "";
		int resultCnt = -1;
		try{
			resultCnt = otWorkOrgAppDetService.saveOtWorkOrgAppDet(convertMap);
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