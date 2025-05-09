package com.hr.tim.annual.annualPlanAgrApr;
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
 * 연차촉진 계획승인 Controller
 *
 * @author EW
 *
 */
@Controller
@RequestMapping(value="/AnnualPlanAgrApr.do", method=RequestMethod.POST )
public class AnnualPlanAgrAprController extends ComController {
	/**
	 * 연차촉진 계획승인 서비스
	 */
	@Inject
	@Named("AnnualPlanAgrAprService")
	private AnnualPlanAgrAprService annualPlanAgrAprService;

	/**
	 * 연차촉진 계획승인 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewAnnualPlanAgrApr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewAnnualPlanAgrApr() throws Exception {
		return "tim/annual/annualPlanAgrApr/annualPlanAgrApr";
	}


	/**
	 * 연차촉진 계획승인 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAnnualPlanAgrAprList", method = RequestMethod.POST )
	public ModelAndView getAnnualPlanAgrAprList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}
	

}
