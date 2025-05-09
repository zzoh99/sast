package com.hr.tim.request.bizTripExpenAppDet;
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
 * 국내출장보고서 신청 Controller
 *
 * @author EW
 *
 */
@Controller
@RequestMapping({"/BizTripExpenApp.do","/BizTripExpenAppDet.do"})
public class BizTripExpenAppDetController extends ComController {
	/**
	 * 국내출장보고서 신청 서비스
	 */
	@Inject
	@Named("BizTripExpenAppDetService")
	private BizTripExpenAppDetService bizTripExpenAppDetService;

	
	/**
	 * 국내출장보고서 신청 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewBizTripExpenAppDet", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewBizTripExpenAppDet() throws Exception {
		return "tim/request/bizTripExpenAppDet/bizTripExpenAppDet";
	}
	
	
	/**
	 * 국내출장보고서 단건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getBizTripExpenAppDetMap", method = RequestMethod.POST )
	public ModelAndView getBizTripExpenAppDetMap(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataMap(session, request, paramMap);
	}
	
	
	
	/**
	 * 국내출장보고서 신청자 정보 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getBizTripExpenAppDetUserMap", method = RequestMethod.POST )
	public ModelAndView getBizTripExpenAppDetUserMap(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataMap(session, request, paramMap);
	}
	/**
	 * 국내출장보고서 유류비 정보 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getBizTripExpenAppDetOil", method = RequestMethod.POST )
	public ModelAndView getBizTripExpenAppDetOil(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataMap(session, request, paramMap);
	}
	/**
	 * 국내출장보고서 기 신청건 체크  조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getBizTripExpenAppDetDupCnt", method = RequestMethod.POST )
	public ModelAndView getBizTripExpenAppDetDupCnt(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataMap(session, request, paramMap);
	}
	
	/**
	 * 국내출장보고서 출장동행인 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getBizTripExpenAppDetList1", method = RequestMethod.POST )
	public ModelAndView getBizTripExpenAppDetList1(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}
	
	/**
	 * 국내출장보고서 출장일정상세 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getBizTripExpenAppDetList2", method = RequestMethod.POST )
	public ModelAndView getBizTripExpenAppDetList2(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}
	
	/**
	 * 국내출장보고서 출장경비내역 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getBizTripExpenAppDetList3", method = RequestMethod.POST )
	public ModelAndView getBizTripExpenAppDetList3(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}
	
	/**
	 * 출장보고서 신청 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveBizTripExpenAppDet", method = RequestMethod.POST )
	public ModelAndView saveBizTripExpenAppDet(
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
			resultCnt =bizTripExpenAppDetService.saveBizTripExpenAppDet(convertMap);
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
