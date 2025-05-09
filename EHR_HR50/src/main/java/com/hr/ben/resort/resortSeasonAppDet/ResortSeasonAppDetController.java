package com.hr.ben.resort.resortSeasonAppDet;

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

/**
 * ResortSeasonAppDet Controller
 *
 * @author bckim
 *
 */
@Controller
@RequestMapping({"/ResortSeasonAppDet.do", "/ResortApp.do"})
public class ResortSeasonAppDetController extends ComController {

	/**
	 * ResortSeasonAppDet 서비스
	 */
	@Inject
	@Named("ResortSeasonAppDetService")
	private ResortSeasonAppDetService resortSeasonAppDetService;

	/**
	 * ResortSeasonAppDet View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewResortSeasonAppDet",method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewResortSeasonAppDet() throws Exception {
		return "ben/resort/resortSeasonAppDet/resortSeasonAppDet";
	}
	
	/**
	 * 성수기 리조트 객실 리스트 및 신청건수
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getResortSeasonAppDetResortList", method = RequestMethod.POST )
	public ModelAndView getResortSeasonAppDetResortList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}

	/**
	 * ResortSeasonAppDet 단건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getResortSeasonAppDetMap", method = RequestMethod.POST )
	public ModelAndView getResortSeasonAppDetMap(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataMap(session, request, paramMap);
	}

	/**
	 * ResortSeasonAppDet 개인연락처 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getResortSeasonAppDetMap2", method = RequestMethod.POST )
	public ModelAndView getResortSeasonAppDetMap2(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataMap(session, request, paramMap);
	}
	
	/**
	 * ResortSeasonAppDet 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveResortSeasonAppDet", method = RequestMethod.POST )
	public ModelAndView saveResortSeasonAppDet(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return saveData(session, request, paramMap);
	}

	/**
	 * 리조트명 selector 세팅
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getResortSeasonAppDetResortName", method = RequestMethod.POST )
	public ModelAndView getResortSeasonAppDetResortName(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}
	/**
	 * 회사지원 가능여부 체크
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getResortSeasonAppDetChkComMon", method = RequestMethod.POST )
	public ModelAndView getResortSeasonAppDetChkComMon(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataMap(session, request, paramMap);
	}
	/**
	 * 리조트 지원 대상자 여부
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getResortSeasonAppDetTargetYn", method = RequestMethod.POST )
	public ModelAndView getResortSeasonAppDetTargetYn(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataMap(session, request, paramMap);
	}
	/**
	 * 중복 신청여부 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getResortSeasonAppDetChkDupAppl", method = RequestMethod.POST )
	public ModelAndView getResortSeasonAppDetChkDupAppl(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataMap(session, request, paramMap);
	}
}
