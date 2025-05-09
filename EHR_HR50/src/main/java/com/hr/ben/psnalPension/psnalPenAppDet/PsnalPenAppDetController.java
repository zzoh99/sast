package com.hr.ben.psnalPension.psnalPenAppDet;
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
 * 개인연금신청 세부내역 Controller
 *
 * @author
 *
 */
@Controller
@RequestMapping({"/PsnalPenAppDet.do", "/PsnalPenApp.do"})
public class PsnalPenAppDetController extends ComController {

	/**
	 * 개인연금신청 세부내역 서비스
	 */
	@Inject
	@Named("PsnalPenAppDetService")
	private PsnalPenAppDetService psnalPenAppDetService;

	/**
	 * 개인연금신청 세부내역 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewPsnalPenAppDet", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewPsnalPenAppDet() throws Exception {
		return "ben/psnalPension/psnalPenAppDet/psnalPenAppDet";
	}
	
	/**
	 * 개인연금신청 상세 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPsnalPenAppDetMap", method = RequestMethod.POST )
	public ModelAndView getPsnalPenAppDetMap(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataMap(session, request, paramMap);
	}
	/**
	 * 개인연금신청 중복 체크 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPsnalPenAppDupChk", method = RequestMethod.POST )
	public ModelAndView getPsnalPenAppDupChk(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataMap(session, request, paramMap);
	}


	/**
	 * 개인연금신청  저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=savePsnalPenAppDet", method = RequestMethod.POST )
	public ModelAndView savePsnalPenAppDet(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return saveData(session, request, paramMap);
	}
}