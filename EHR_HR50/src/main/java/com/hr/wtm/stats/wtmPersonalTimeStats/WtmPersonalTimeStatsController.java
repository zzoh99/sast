package com.hr.wtm.stats.wtmPersonalTimeStats;

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
 * 부서원근태현황 Controller
 *
 * @author bckim
 *
 */
@Controller
@RequestMapping(value="/WtmPersonalTimeStats.do", method=RequestMethod.POST )
public class WtmPersonalTimeStatsController {

	/**
	 * 부서원근태현황 서비스
	 */
	@Inject
	@Named("WtmPersonalTimeStatsService")
	private WtmPersonalTimeStatsService wtmPersonalTimeStatsService;

	/**
	 * personalTimeStats View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewWtmPersonalTimeStats",method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewPersonalTimeStats() throws Exception {
		return "wtm/stats/wtmPersonalTimeStats/wtmPersonalTimeStats";
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
	@RequestMapping(params="cmd=getWtmPersonalTimeStatsList", method = RequestMethod.POST )
	public ModelAndView getOrgDatTimeStatsList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));

		HashMap<String, String> mapElement = null;
		List<?> titleList = new ArrayList<Object>();
		List<Serializable> titles = new ArrayList<Serializable>();

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			titleList = wtmPersonalTimeStatsService.getWtmPersonalTimeStatsHeaderList(paramMap);
			for(int i = 0 ; i < titleList.size() ; i++){
				mapElement = new HashMap<String, String>();
				Map<String, String> map = (Map)titleList.get(i);
				mapElement.put("gntCd",       map.get("gntCd").toString());
				mapElement.put("gntNm",       map.get("gntNm").toString());
				mapElement.put("saveName1",   map.get("saveName1").toString());
				mapElement.put("saveName2",   map.get("saveName2").toString());
				titles.add(mapElement);
			}
			paramMap.put("titles", titles);
			list = wtmPersonalTimeStatsService.getWtmPersonalTimeStatsList(paramMap);

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

	@RequestMapping(params="cmd=getWtmPersonalTimeStatsHeaderList", method = RequestMethod.POST )
	public ModelAndView getWtmPersonalTimeStatsHeaderList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<>();
		String Message = "";
		try{
			list = wtmPersonalTimeStatsService.getWtmPersonalTimeStatsHeaderList(paramMap);

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
	
	@RequestMapping(params="cmd=getWtmPersonalTimeStatsOrgList", method = RequestMethod.POST )
	public ModelAndView getWtmPersonalTimeStatsOrgList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<>();
		String Message = "";
		try{
			list = wtmPersonalTimeStatsService.getWtmPersonalTimeStatsOrgList(paramMap);

		}catch(Exception e){
			Message=LanguageUtil.getMessage("msg.alertSearchFail2", null, "조회에 실패하였습니다.");
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("codeList", list);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}
}
