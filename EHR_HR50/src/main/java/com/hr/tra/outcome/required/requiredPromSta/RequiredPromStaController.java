package com.hr.tra.outcome.required.requiredPromSta;
import java.util.ArrayList;
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

/**
 * 승격대상자 필수교육이수현황 Controller 
 * 
 * @author 이름
 *
 */
@Controller
@RequestMapping(value="/RequiredPromSta.do", method=RequestMethod.POST )
public class RequiredPromStaController extends ComController {
	/**
	 * 승격대상자 필수교육이수현황 서비스
	 */
	@Inject
	@Named("RequiredPromStaService")
	private RequiredPromStaService requiredPromStaService;	
	
	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;
	
	
	/**
	 * 승격대상자 필수교육이수현황 View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewRequiredPromSta", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewRequiredPromSta() throws Exception {
		return "tra/outcome/required/requiredPromSta/requiredPromSta";
	}

	/**
	 * 승격대상자 필수교육이수현황 팝업 View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewRequiredPromStaLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewRequiredPromStaLayer() throws Exception {
		return "tra/outcome/required/requiredPromSta/requiredPromStaLayer";
	}
	
	/**
	 * 승격대상자 필수교육이수현황 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getRequiredPromStaList", method = RequestMethod.POST )
	public ModelAndView getRequiredPromStaList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		
		return getDataList(session, request, paramMap);
	}

	/**
	 * 승격대상자 필수교육이수현황 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getRequiredPromStaPopList", method = RequestMethod.POST )
	public ModelAndView getRequiredPromStaPopList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		
		return getDataList(session, request, paramMap);
	}
	
	

	

}
