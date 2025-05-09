package com.hr.tim.etc.workTimeDayStats;
import java.io.Serializable;
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

import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;
import com.hr.common.code.CommonCodeService;
import com.hr.common.language.LanguageUtil;
/**
 * 일별근무현황 Controller
 *
 * @author
 *
 */
@Controller
@RequestMapping(value="/WorkTimeDayStats.do", method=RequestMethod.POST )
public class WorkTimeDayStatsController {
	/**
	 * 일별근무현황 서비스
	 */
	@Inject
	@Named("WorkTimeDayStatsService")
	private WorkTimeDayStatsService workTimeDayStatsService;

	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;

	/**
	 * WorkTimeDayStats View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewWorkTimeDayStats", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewWorkTimeDayStats() throws Exception {
		return "tim/etc/workTimeDayStats/workTimeDayStats";
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
	@RequestMapping(params="cmd=getWorkTimeDayStatsList", method = RequestMethod.POST )
	public ModelAndView getWorkTimeDayStatsList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {

		paramMap.put("ssnSabun",		session.getAttribute("ssnSabun"));
		paramMap.put("ssnEnterCd",		session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSearchType",	session.getAttribute("ssnSearchType"));
		paramMap.put("ssnGrpCd",		session.getAttribute("ssnGrpCd"));


		Log.DebugStart();
		HashMap<String, String> mapElement = null;
		List<?> titleList = new ArrayList<Object>();
		List<Serializable> titles = new ArrayList<Serializable>();

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		Map<?,?> map  = new HashMap<String,Object>();

		try{
			paramMap.put("cmd", "getWorkTimeDayStatsHeaderList");
			titleList = workTimeDayStatsService.getDataList(paramMap);
			paramMap.put("titles", titleList);

			paramMap.put("cmd", "getWorkTimeDayStatsList");
			list = workTimeDayStatsService.getDataList(paramMap);
		}catch(Exception e){
			Message=LanguageUtil.getMessage("msg.alertSearchFail2", null, "조회에 실패하였습니다.");
		}
		ModelAndView mv = new ModelAndView();


		mv.setViewName("jsonView");
		mv.addObject("DATA", list);

		mv.addObject("Message", Message);
		//mv.addObject("TOTAL",map.get("cnt"));
		Log.DebugEnd();
		return mv;
	}
	
	@RequestMapping(params="cmd=getWorkTimeDayStatsHeaderList", method = RequestMethod.POST )
	public ModelAndView getWorkTimeDayStatsHeaderList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = workTimeDayStatsService.getWorkTimeDayStatsHeaderList(paramMap);

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
