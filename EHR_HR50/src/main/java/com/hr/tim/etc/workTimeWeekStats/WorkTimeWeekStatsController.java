package com.hr.tim.etc.workTimeWeekStats;
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

import com.hr.common.logger.Log;
/**
 * 주단위근무현황 Controller
 *
 * @author JSG
 *
 */
@Controller
@RequestMapping(value="/WorkTimeWeekStats.do", method=RequestMethod.POST )
public class WorkTimeWeekStatsController {
	/**
	 * 주단위근무현황 서비스
	 */
	@Inject
	@Named("WorkTimeWeekStatsService")
	private WorkTimeWeekStatsService workTimeWeekStatService;

	/**
	 * WorkTimeWeekStats View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewWorkTimeWeekStats", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewWorkTimeWeekStats() throws Exception {
		return "tim/etc/workTimeWeekStats/workTimeWeekStats";
	}
	
	/**
	 * 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getWorkTimeWeekStatsList", method = RequestMethod.POST )
	public ModelAndView getWorkTimeWeekStatsList(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",		session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnLocaleCd",		session.getAttribute("ssnLocaleCd"));
		paramMap.put("ssnSabun",		session.getAttribute("ssnSabun"));

		Log.DebugStart();

		List<?> result = workTimeWeekStatService.getWorkTimeWeekStatsList(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", result);
		Log.DebugEnd();
		return mv;
	}
	
	
	/**
	 * getWorkTimeWeekStatsMyWorkGrp 단건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getWorkTimeWeekStatsMyWorkGrp", method = RequestMethod.POST )
	public ModelAndView getWorkTimeWeekStatsMyWorkGrp(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
	
		Map<?, ?> map = null;
		String Message = "";
	
		try{
			map = workTimeWeekStatService.getWorkTimeWeekStatsMyWorkGrp(paramMap);
		}catch(Exception e){
			Message="조회에 실패하였습니다.";
		}
	
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", map);
		mv.addObject("Message", Message);
	
		Log.DebugEnd();
		return mv;
	}
	
	/**
	 * getWorkTimeWeekStatsWeekList 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getWorkTimeWeekStatsWeekList", method = RequestMethod.POST )
	public ModelAndView getWorkTimeWeekStatsWeekList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = workTimeWeekStatService.getWorkTimeWeekStatsWeekList(paramMap);
		}catch(Exception e){
			Message="조회에 실패 하였습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}
	
	/**
	 * getWorkTimeWeekStatsMonthWeekList 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getWorkTimeWeekStatsMonthWeekList", method = RequestMethod.POST )
	public ModelAndView getWorkTimeWeekStatsMonthWeekList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = workTimeWeekStatService.getWorkTimeWeekStatsMonthWeekList(paramMap);
		}catch(Exception e){
			Message="조회에 실패 하였습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}
	
	
	
	@RequestMapping(params="cmd=getWorkTimeWeekPerList", method = RequestMethod.POST )
	public ModelAndView getWorkTimeWeekPerList(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",		session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnLocaleCd",		session.getAttribute("ssnLocaleCd"));
		paramMap.put("ssnSabun",		session.getAttribute("ssnSabun"));

		Log.DebugStart();

		List<?> result = workTimeWeekStatService.getWorkTimeWeekPerList(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", result);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 단위기간근무현황 WorkTimeWeekStats2 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewWorkTimeWeekStats2", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewWorkTimeWeekStats2() throws Exception {
		return "tim/etc/workTimeWeekStats/workTimeWeekStats2";
	}
	
	/**
	 * 단위기간근무현황 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getWorkTimeWeekStatsList2", method = RequestMethod.POST )
	public ModelAndView getWorkTimeWeekStatsList2(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",		session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnLocaleCd",		session.getAttribute("ssnLocaleCd"));
		paramMap.put("ssnSabun",		session.getAttribute("ssnSabun"));

		Log.DebugStart();

		List<?> result = workTimeWeekStatService.getWorkTimeWeekStatsList2(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", result);
		Log.DebugEnd();
		return mv;
	}
}
