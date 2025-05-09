package com.hr.tim.annual.annualPlanAgrStd;
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
 * 연차촉진기준관리 Controller 
 * 
 * @author 이름
 *
 */
@Controller
@RequestMapping(value="/AnnualPlanAgrStd.do", method=RequestMethod.POST )
public class AnnualPlanAgrStdController extends ComController {
	/**
	 * 연차촉진기준관리 서비스
	 */
	@Inject
	@Named("AnnualPlanAgrStdService")
	private AnnualPlanAgrStdService annualPlanAgrStdService;	
	
	
	/**
	 * 연차촉진기준관리 View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewAnnualPlanAgrStd", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewAnnualPlanAgrStd() throws Exception {
		return "tim/annual/annualPlanAgrStd/annualPlanAgrStd";
	}
	
	/**
	 * 연차촉진기준관리 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAnnualPlanAgrStdList", method = RequestMethod.POST )
	public ModelAndView getAnnualPlanAgrStdList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}
	
	
	/**
	 * 연차촉진기준관리 저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveAnnualPlanAgrStd", method = RequestMethod.POST )
	public ModelAndView saveAnnualPlanAgrStd(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return saveData(session, request, paramMap);
	}

}
