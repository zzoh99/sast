package com.hr.tra.yearEduPlan.yearEduStd;

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
 * YearEduStd Controller
 *
 * @author EW
 *
 */
@Controller
@RequestMapping(value="/YearEduStd.do", method=RequestMethod.POST )
public class YearEduStdController extends ComController{
	/**
	 * YearEduStd 서비스
	 */
	@Inject
	@Named("YearEduStdService")
	private YearEduStdService yearEduStdService;

	/**
	 * YearEduStd View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewYearEduStd", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewYearEduStd() throws Exception {
		return "tra/yearEduPlan/yearEduStd/yearEduStd";
	}

	/**
	 * YearEduStd 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getYearEduStdList", method = RequestMethod.POST )
	public ModelAndView getYearEduStdList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}


	/**
	 * YearEduStd 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveYearEduStd", method = RequestMethod.POST )
	public ModelAndView saveYearEduStd(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();
		return saveData(session, request, paramMap);
	}
	
	
	
}
