package com.hr.tim.workApp.holAlterAppDet;
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
 * 대체휴가신청 Controller
 *
 * @author EW
 *
 */
@Controller
@RequestMapping({"/HolAlterApp.do","/HolAlterAppDet.do"})
public class HolAlterAppDetController extends ComController {
	/**
	 * 대체휴가신청 서비스
	 */
	@Inject
	@Named("HolAlterAppDetService")
	private HolAlterAppDetService holAlterAppDetService;

	/**
	 * 대체휴가신청 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewHolAlterAppDet", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewHolAlterAppDet() throws Exception {
		return "tim/workApp/holAlterAppDet/holAlterAppDet";
	}

	/**
	 * 재직상태, 휴일  체크
	 */
	@RequestMapping(params="cmd=getHolAlterAppDetHoliChk", method = RequestMethod.POST )
	public ModelAndView getHolAlterAppDetHoliChk(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataMap(session, request, paramMap);
	}

	/**
	 * 대체휴가신청 세부내역 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getHolAlterAppDetMap", method = RequestMethod.POST )
	public ModelAndView getHolAlterAppDetMap(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataMap(session, request, paramMap);
	}


	/**
	 * 대체휴가신청 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveHolAlterAppDet", method = RequestMethod.POST )
	public ModelAndView saveHolAlterAppDet(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return saveData(session, request, paramMap);
	}

	
}