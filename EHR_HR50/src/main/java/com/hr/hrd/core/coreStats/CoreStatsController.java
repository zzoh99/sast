package com.hr.hrd.core.coreStats;

import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.hr.common.logger.Log;


/**
 * 
 * 
 * @author ParkMoohun
 */
@Controller
@RequestMapping(value="/CoreStats.do", method=RequestMethod.POST )
public class CoreStatsController {

	@Inject
	@Named("CoreStatsService")
	private CoreStatsService coreStatsService;
	
	/**
	 * 핵심인재현황 화면
	 * 
	 * @param paramMap
	 * @param request
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewCoreStats", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewCoreStats() throws Exception {
		Log.Debug("CoreStatsController.viewCoreStats");
		return "hrd/core/coreStats/coreStats";
	}
	
	/**
	 * 핵심인재현황 총 인원
	 * 
	 * @param session
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getCoreStatsCnt", method = RequestMethod.POST )
	public ModelAndView getCoreStatsCnt(HttpSession session,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
		Map<?,?> result = coreStatsService.getCoreStatsCnt(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView"); 
		mv.addObject("DATA", result);
		Log.DebugEnd();
		return mv;
	}
	
	/**
	 * 핵심인재현황 row list
	 * 
	 * @param session
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getCoreStatsList1", method = RequestMethod.POST )
	public ModelAndView getCoreStatsList1(HttpSession session,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
		List<?> result = coreStatsService.getCoreStatsList1(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView"); 
		mv.addObject("DATA", result);
		Log.DebugEnd();
		return mv;
	}
	
	/**
	 * 핵심인재현황 col list
	 * 
	 * @param session
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getCoreStatsList2", method = RequestMethod.POST )
	public ModelAndView getCoreStatsList2(HttpSession session,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
		List<?> result = coreStatsService.getCoreStatsList2(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView"); 
		mv.addObject("DATA", result);
		Log.DebugEnd();
		return mv;
	}

}