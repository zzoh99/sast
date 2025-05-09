package com.hr.tra.lectureFee.lectureFeeApr;
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
import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;

/**
 * 사내강사료승인 Controller
 *
 * @author JSG
 *
 */
@Controller
@RequestMapping(value="/LectureFeeApr.do", method=RequestMethod.POST )
public class LectureFeeAprController extends ComController {
	/**
	 * 사내강사료승인 서비스
	 */
	@Inject
	@Named("LectureFeeAprService")
	private LectureFeeAprService lectureFeeAprService;

	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;

	/**
	 *  사내강사료승인 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewLectureFeeApr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewLectureFeeApr() throws Exception {
		return "tra/lectureFee/lectureFeeApr/lectureFeeApr";
	}

	/**
	 * 사내강사료신청 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getLectureFeeAprList", method = RequestMethod.POST )
	public ModelAndView getLectureFeeAprList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
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
	@RequestMapping(params="cmd=saveLectureFeeApr", method = RequestMethod.POST )
	public ModelAndView saveLectureFeeApr(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return saveData(session, request, paramMap);
	}

	/**
	 * 사내강사료 급여마감여부 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getLectureFeeAprPayClose", method = RequestMethod.POST )
	public ModelAndView getLectureFeeAprPayClose(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataMap(session, request, paramMap);
	}
}
