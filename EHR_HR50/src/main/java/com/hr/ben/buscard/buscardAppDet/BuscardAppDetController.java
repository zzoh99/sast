package com.hr.ben.buscard.buscardAppDet;
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
 * 명함신청 세부내역 Controller
 *
 * @author
 *
 */
@Controller
@RequestMapping({"/BuscardApp.do", "/BuscardAppDet.do"})
public class BuscardAppDetController extends ComController {

	/**
	 * 신청 세부내역 서비스
	 */
	@Inject
	@Named("BuscardAppDetService")
	private BuscardAppDetService buscardAppDetService;

	/**
	 * 명함신청 세부내역 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewBuscardAppDet",method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewBuscardAppDet() throws Exception {
		return "ben/buscard/buscardAppDet/buscardAppDet";
	}
	
	/**
	 * 명함신청 상세 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getBuscardAppDetMap", method = RequestMethod.POST )
	public ModelAndView getBuscardAppDetMap(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataMap(session, request, paramMap);
	}

	/**
	 * 명함신청  저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveBuscardAppDet", method = RequestMethod.POST )
	public ModelAndView saveBuscardAppDet(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return saveData(session, request, paramMap);
	}
	
}