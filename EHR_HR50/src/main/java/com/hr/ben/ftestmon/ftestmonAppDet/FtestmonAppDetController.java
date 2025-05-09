package com.hr.ben.ftestmon.ftestmonAppDet;
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
 * 어학시험응시료신청 세부내역 Controller
 *
 * @author
 *
 */
@Controller
@RequestMapping({"/FtestmonAppDet.do", "/FtestmonApp.do"})
public class FtestmonAppDetController extends ComController {

	/**
	 * 어학시험응시료신청 세부내역 서비스
	 */
	@Inject
	@Named("FtestmonAppDetService")
	private FtestmonAppDetService ftestmonAppDetService;

	/**
	 * 어학시험응시료신청 세부내역 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewFtestmonAppDet",method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewFtestmonAppDet() throws Exception {
		return "ben/ftestmon/ftestmonAppDet/ftestmonAppDet";
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
	/*
	 * @RequestMapping(params="cmd=getFtestmonAppDetUseInfo", method = RequestMethod.POST ) public ModelAndView
	 * getFtestmonAppDetUseInfo( HttpSession session, HttpServletRequest request,
	 * 
	 * @RequestParam Map<String, Object> paramMap ) throws Exception {
	 * Log.DebugStart(); return getDataMap(session, request, paramMap); }
	 */	
	
	/**
	 * 어학시험응시료신청 상세 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getFtestmonAppDetMap", method = RequestMethod.POST )
	public ModelAndView getFtestmonAppDetMap(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataMap(session, request, paramMap);
	}

	/**
	 * 어학시험응시료신청 중복 체크 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */

	  @RequestMapping(params="cmd=getFtestmonAppDupChk", method = RequestMethod.POST )
	  public ModelAndView getFtestmonAppDupChk( 
			  HttpSession session, HttpServletRequest request,	  
			  @RequestParam Map<String, Object> paramMap ) throws Exception {
		  Log.DebugStart(); 
		  return getDataMap(session, request, paramMap);		  
	  }
	 	

	/**
	 * 어학시험응시료신청 담당자 저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveFtestmonAppDetAdmin", method = RequestMethod.POST )
	public ModelAndView saveFtestmonAppDetAdmin(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return saveData(session, request, paramMap);
	}

	/**
	 * 어학시험응시료신청  저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveFtestmonAppDet", method = RequestMethod.POST )
	public ModelAndView saveFtestmonAppDet(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return saveData(session, request, paramMap);
	}
}