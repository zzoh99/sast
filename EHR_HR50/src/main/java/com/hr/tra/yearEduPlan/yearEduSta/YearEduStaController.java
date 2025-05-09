package com.hr.tra.yearEduPlan.yearEduSta;

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
 * YearEduSta Controller
 *
 * @author EW
 *
 */
@Controller
@RequestMapping(value="/YearEduSta.do", method=RequestMethod.POST )
public class YearEduStaController extends ComController{
	/**
	 * YearEduSta 서비스
	 */
	@Inject
	@Named("YearEduStaService")
	private YearEduStaService yearEduStaService;

	/**
	 * YearEduSta View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewYearEduSta", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewYearEduSta() throws Exception {
		return "tra/yearEduPlan/yearEduSta/yearEduSta";
	}

	/**
	 * YearEduSta 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getYearEduStaList", method = RequestMethod.POST )
	public ModelAndView getYearEduStaList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}

	
}
