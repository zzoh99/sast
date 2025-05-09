package com.hr.tra.eLearning.eduElAppDet;
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
 * 이러닝신청 세부내역 Controller
 *
 * @author
 *
 */
@Controller
@RequestMapping({"/EduElAppDet.do", "/EduElApp.do"})
public class EduElAppDetController extends ComController {

	/**
	 * 이러닝신청 세부내역 서비스
	 */
	@Inject
	@Named("EduElAppDetService")
	private EduElAppDetService eduElAppDetService;

	/**
	 * 이러닝신청 세부내역 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewEduElAppDet", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewEduElAppDet() throws Exception {
		return "tra/eLearning/eduElAppDet/eduElAppDet";
	}

	
	/**
	 * 이러닝신청 상세 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getEduElAppDetMap", method = RequestMethod.POST )
	public ModelAndView getEduElAppDetMap(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataMap(session, request, paramMap);
	}

	
	
	/**
	 * 이러닝신청 신청정보 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getEduElAppDetInfo", method = RequestMethod.POST )
	public ModelAndView getEduElAppDetInfo(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataMap(session, request, paramMap);
	}

	/**
	 * 이러닝신청 중복 체크 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */

	  @RequestMapping(params="cmd=getEduElAppDetDupChk", method = RequestMethod.POST )
	  public ModelAndView getEduElAppDupChk( 
			  HttpSession session, HttpServletRequest request,	  
			  @RequestParam Map<String, Object> paramMap ) throws Exception {
		  Log.DebugStart(); 
		  return getDataMap(session, request, paramMap);		  
	  }
	 	

	/**
	 * 이러닝신청  저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveEduElAppDet", method = RequestMethod.POST )
	public ModelAndView saveEduElAppDet(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return saveData(session, request, paramMap);
	}
}