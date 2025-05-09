package com.hr.tim.etc.annualYearStats;

import com.hr.common.code.CommonCodeService;
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
 * 연차사용현황 Controller 
 * 
 * @author 이름
 *
 */
@Controller
@RequestMapping(value="/AnnualYearSta.do", method=RequestMethod.POST )
public class AnnualYearStaController extends ComController {
	/**
	 * 연차사용현황 서비스
	 */
	@Inject
	@Named("AnnualYearStaService")
	private AnnualYearStaService requiredStaService;	
	
	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;
	
	
	/**
	 * 연차사용현황 View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewAnnualYearSta", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewAnnualYearSta() throws Exception {
		return "tim/etc/annualYearSta/annualYearSta";
	}


	/**
	 * 연차사용현황 Title 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAnnualYearStaTitleList", method = RequestMethod.POST )
	public ModelAndView getAnnualYearStaTitleList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}
	
	/**
	 * 연차사용현황 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	/* 20240719 사용안함 jyp
	@RequestMapping(params="cmd=getAnnualYearStaList", method = RequestMethod.POST )
	public ModelAndView getAnnualYearStaList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		List<?> titleList = requiredStaService.getAnnualYearStaTitleList(paramMap);

		paramMap.put("titles", titleList);

		return getDataList(session, request, paramMap);
	}

	 */
	
	

}
