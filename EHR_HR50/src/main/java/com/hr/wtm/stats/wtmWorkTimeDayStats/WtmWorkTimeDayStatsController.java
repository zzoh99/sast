package com.hr.wtm.stats.wtmWorkTimeDayStats;

import com.hr.common.code.CommonCodeService;
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
import java.io.Serializable;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
/**
 * 일별근무현황 Controller
 *
 * @author
 *
 */
@Controller
@RequestMapping(value="/WtmWorkTimeDayStats.do", method=RequestMethod.POST )
public class WtmWorkTimeDayStatsController {
	/**
	 * 일별근무현황 서비스
	 */
	@Inject
	@Named("WtmWorkTimeDayStatsService")
	private WtmWorkTimeDayStatsService wtmWorkTimeDayStatsService;

	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;

	/**
	 * WorkTimeDayStats View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewWtmWorkTimeDayStats",method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewWtmWorkTimeDayStats() throws Exception {
		return "wtm/stats/wtmWorkTimeDayStats/wtmWorkTimeDayStats";
	}
	
	/**
	 * 일별근무현황 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getWtmWorkTimeDayStatsList", method = RequestMethod.POST )
	public ModelAndView getWtmWorkTimeDayStatsList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {

		Log.DebugStart();

		paramMap.put("ssnSabun",		session.getAttribute("ssnSabun"));
		paramMap.put("ssnEnterCd",		session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSearchType",	session.getAttribute("ssnSearchType"));
		paramMap.put("ssnGrpCd",		session.getAttribute("ssnGrpCd"));

		List<?> list  = new ArrayList<>();
		String Message = "";

		try {
			paramMap.put("cmd", "getWtmWorkTimeDayStatsHeaderList");
			List<?> titleList = wtmWorkTimeDayStatsService.getDataList(paramMap);
			paramMap.put("titles", titleList);

			paramMap.put("cmd", "getWtmWorkTimeDayStatsList");
			list = wtmWorkTimeDayStatsService.getDataList(paramMap);
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
	
	@RequestMapping(params="cmd=getWtmWorkTimeDayStatsHeaderList", method = RequestMethod.POST )
	public ModelAndView getWtmWorkTimeDayStatsHeaderList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<>();
		String Message = "";
		try{
			list = wtmWorkTimeDayStatsService.getWtmWorkTimeDayStatsHeaderList(paramMap);

		}catch(Exception e){
			Message=LanguageUtil.getMessage("msg.alertSearchFail2", null, "조회에 실패하였습니다.");
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}
}
