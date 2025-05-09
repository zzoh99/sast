package com.hr.tra.lectureFee.lectureFeeAppDet;
import java.util.ArrayList;
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

import com.hr.common.code.CommonCodeService;
import com.hr.common.com.ComController;
import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;

/**
 * 사내강사료신청 Controller 
 * 
 * @author 이름
 *
 */
@Controller
@RequestMapping({"/LectureFeeAppDet.do", "/LectureFeeApp.do"}) 
public class LectureFeeAppDetController extends ComController {
	/**
	 * 사내강사료신청 서비스
	 */
	@Inject
	@Named("LectureFeeAppDetService")
	private LectureFeeAppDetService lectureFeeAppDetService;	
	
	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;
	
	
	/**
	 * 사내강사료신청 View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewLectureFeeAppDet", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewLectureFeeAppDet() throws Exception {
		return "tra/lectureFee/lectureFeeAppDet/lectureFeeAppDet";
	}
	
	/**
	 * 사내강사료신청 단건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getLectureFeeAppDetMap", method = RequestMethod.POST )
	public ModelAndView getLectureFeeAppDetMap(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataMap(session, request, paramMap);
	}
	
	/**
	 * 강의과목 강의료 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getLectureFeeAppDetInfo", method = RequestMethod.POST )
	public ModelAndView getLectureFeeAppDetInfo(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataMap(session, request, paramMap);
	}

	/**
	 * 사내강사료신청 중복 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getLectureFeeAppDetDupChk", method = RequestMethod.POST )
	public ModelAndView getLectureFeeAppDetDupChk(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataMap(session, request, paramMap);
	}
	
	
	/**
	 * 사내강사료신청 저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveLectureFeeAppDet", method = RequestMethod.POST )
	public ModelAndView saveLectureFeeAppDet(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		return saveData(session, request, paramMap);
	}
	
	/**
	 * 사내강사료 지급정보 저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveLectureFeeAppDetAdmin", method = RequestMethod.POST )
	public ModelAndView saveLectureFeeAppDetAdmin(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return saveData(session, request, paramMap);
	}

}
