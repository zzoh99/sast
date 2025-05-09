package com.hr.tim.workApp.holWorkAppDet;
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
 * 휴일근무신청 Controller
 *
 * @author EW
 *
 */
@Controller
@RequestMapping({"/HolWorkApp.do","/HolWorkAppDet.do"})
public class HolWorkAppDetController extends ComController {
	/**
	 * 휴일근무신청 서비스
	 */
	@Inject
	@Named("HolWorkAppDetService")
	private HolWorkAppDetService holWorkAppDetService;

	/**
	 * 휴일근무신청 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewHolWorkAppDet", method = {RequestMethod.POST, RequestMethod.GET} )
	public ModelAndView viewHolWorkAppDet(HttpSession session,
			@RequestParam Map<String, Object> paramMap,
			HttpServletRequest request) throws Exception {
		Log.DebugStart();
		ModelAndView mv = new ModelAndView();
		mv.setViewName("tim/workApp/holWorkAppDet/holWorkAppDet");
		mv.addObject("user", holWorkAppDetService.getHolWorkAppDetUserInfo(paramMap));
		return mv;
	}

	/**
	 * 휴일근무신청(세부내역) 팝업 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewHolWorkAppDetPop", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewHolWorkAppDetPop() throws Exception {
		return "tim/workApp/holWorkAppDet/holWorkAppDetPop";
	}

	/**
	 * 휴일근무신청 근무신청시간  조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getHolWorkAppDetTime", method = RequestMethod.POST )
	public ModelAndView getHolWorkAppDetTime(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataMap(session, request, paramMap);
	}
	
	/**
	 * 휴일근무신청 상세 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getHolWorkAppDetMap", method = RequestMethod.POST )
	public ModelAndView getHolWorkAppDetMap(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataMap(session, request, paramMap);
	}

	/**
	 * 휴일근무신청 휴일기본근무 근무시간 상세 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getHolWorkAppDetHolworkTimeList", method = RequestMethod.POST )
	public ModelAndView getHolWorkAppDetHolworkTimeList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
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
	@RequestMapping(params="cmd=getHolWorkAppDetDupCnt", method = RequestMethod.POST )
	public ModelAndView getHolWorkAppDetDupCnt(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataMap(session, request, paramMap);
	}
	

	/**
	 * 휴일근무신청 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveHolWorkAppDet", method = RequestMethod.POST )
	public ModelAndView saveHolWorkAppDet(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();
		return saveData(session, request, paramMap);
	}
}
