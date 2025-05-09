package com.hr.ben.buscard.buscardApr;
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
 * 명함승인 Controller
 *
 * @author 이름
 *
 */
@Controller
@RequestMapping(value="/BuscardApr.do", method=RequestMethod.POST )
public class BuscardAprController extends ComController {
	/**
	 * 명함승인 서비스
	 */
	@Inject
	@Named("BuscardAprService")
	private BuscardAprService buscardAprService;


	/**
	 * 명함승인 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewBuscardApr",method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewBuscardApr() throws Exception {
		return "ben/buscard/buscardApr/buscardApr";
	}
	

	/**
	 * 명함승인 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getBuscardAprList", method = RequestMethod.POST )
	public ModelAndView getBuscardAprList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}
	
	
	/**
	 * 명함승인 저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveBuscardApr", method = RequestMethod.POST )
	public ModelAndView saveBuscardApr(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return saveData(session, request, paramMap);
	}

}
