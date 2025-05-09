package com.hr.wtm.stats.wtmOrgDailyTimeStats;

import com.hr.common.language.LanguageUtil;
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
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * 부서원근태현황 Controller
 *
 * @author bckim
 *
 */
@Controller
@RequestMapping(value="/WtmOrgDailyTimeStats.do", method=RequestMethod.POST )
public class WtmOrgDailyTimeStatsController {

	/**
	 * 부서원근태현황 서비스
	 */
	@Inject
	@Named("WtmOrgDailyTimeStatsService")
	private WtmOrgDailyTimeStatsService wtmOrgDailyTimeStatsService;

	/**
	 * orgDayTimeStats View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewWtmOrgDailyTimeStats",method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewWtmOrgDailyTimeStats() throws Exception {
		return "wtm/stats/wtmOrgDailyTimeStats/wtmOrgDailyTimeStats";
	}
	
	/**
	 * 부서원근태현황 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getWtmOrgDailyTimeStatsList", method = RequestMethod.POST )
	public ModelAndView getWtmOrgDailyTimeStatsList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<>();
		String Message = "";
		try {
			list = wtmOrgDailyTimeStatsService.getWtmOrgDailyTimeStatsList(paramMap);
		} catch(Exception e) {
			Message = LanguageUtil.getMessage("msg.alertSearchFail2", null, "조회에 실패하였습니다.");
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 일일근태현황(부서별) 에서 헤더 조회
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getWtmOrgDailyTimeStatsHeaderList", method = RequestMethod.POST )
	public ModelAndView getWtmOrgDailyTimeStatsHeaderList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<>();
		String Message = "";
		try {
			list = wtmOrgDailyTimeStatsService.getWtmOrgDailyTimeStatsHeaderList(paramMap);
		} catch(Exception e) {
			Message = LanguageUtil.getMessage("msg.alertSearchFail2", null, "조회에 실패하였습니다.");
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}
}
