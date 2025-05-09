package com.hr.ben.resort.resortApr;

import com.hr.common.com.ComController;
import com.hr.common.logger.Log;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.Map;

/**
 * ResortApr Controller
 *
 * @author EW
 *
 */
@Controller
@RequestMapping(value="/ResortApr.do", method=RequestMethod.POST )
public class ResortAprController extends ComController{
	/**
	 * ResortApr 서비스
	 */
	@Inject
	@Named("ResortAprService")
	private ResortAprService resortAprService;

	/**
	 * ResortApr View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewResortApr",method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewResortApr() throws Exception {
		return "ben/resort/resortApr/resortApr";
	}

	/**
	 * ResortApr 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getResortAprList", method = RequestMethod.POST )
	public ModelAndView getResortAprList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}


	/**
	 * ResortApr 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveResortApr", method = RequestMethod.POST )
	public ModelAndView saveResortApr(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();
		return saveData(session, request, paramMap);
	}
	
	
	
}
