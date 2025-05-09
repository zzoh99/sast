package com.hr.ben.occasion.occAppDet;
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
 * 경조신청 세부내역 Controller
 *
 * @author
 *
 */
@Controller
@RequestMapping({"/OccAppDet.do", "/OccApp.do"})
public class OccAppDetController extends ComController {

	/**
	 * 경조신청 세부내역 서비스
	 */
	@Inject
	@Named("OccAppDetService")
	private OccAppDetService occAppDetService;

	/**
	 * 경조신청 세부내역 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewOccAppDet",method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewOccAppDet() throws Exception {
		return "ben/occasion/occAppDet/occAppDet";
	}
	
	/**
	 * 신청자정보 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getOccAppDetUseInfo", method = RequestMethod.POST )
	public ModelAndView getOccAppDetUseInfo(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataMap(session, request, paramMap);
	}
	/**
	 * 경조신청 상세 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getOccAppDetMap", method = RequestMethod.POST )
	public ModelAndView getOccAppDetMap(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataMap(session, request, paramMap);
	}

	/**
	 * 경조신청 중복 체크 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getOccAppDupChk", method = RequestMethod.POST )
	public ModelAndView getOccAppDupChk(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataMap(session, request, paramMap);
	}
	

	/**
	 * 경조신청 담당자 저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveOccAppDetAdmin", method = RequestMethod.POST )
	public ModelAndView saveOccAppDetAdmin(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return saveData(session, request, paramMap);
	}


	/**
	 * 경조신청  저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveOccAppDet", method = RequestMethod.POST )
	public ModelAndView saveOccAppDet(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return saveData(session, request, paramMap);
	}
}