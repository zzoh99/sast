package com.hr.tra.yearEduPlan.yearEduOrgApr;

import java.util.ArrayList;
import java.util.HashMap;
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

import com.hr.common.com.ComController;
import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;

/**
 * YearEduOrgApr Controller
 *
 * @author EW
 *
 */
@Controller
@RequestMapping(value="/YearEduOrgApr.do", method=RequestMethod.POST )
public class YearEduOrgAprController extends ComController{
	/**
	 * YearEduOrgApr 서비스
	 */
	@Inject
	@Named("YearEduOrgAprService")
	private YearEduOrgAprService yearEduOrgAprService;

	/**
	 * YearEduOrgApr View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewYearEduOrgApr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewYearEduOrgApr() throws Exception {
		return "tra/yearEduPlan/yearEduOrgApr/yearEduOrgApr";
	}

	/**
	 * YearEduOrgApr 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getYearEduOrgAprList", method = RequestMethod.POST )
	public ModelAndView getYearEduOrgAprList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}

	
}
