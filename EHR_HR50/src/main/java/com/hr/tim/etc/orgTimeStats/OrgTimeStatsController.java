package com.hr.tim.etc.orgTimeStats;
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
import com.hr.common.language.LanguageUtil;
/**
 * 부서원근태현황 Controller
 *
 * @author bckim
 *
 */
@Controller
@RequestMapping(value="/OrgTimeStats.do", method=RequestMethod.POST )
public class OrgTimeStatsController {

	/**
	 * 부서원근태현황 서비스
	 */
	@Inject
	@Named("OrgTimeStatsService")
	private OrgTimeStatsService orgTimeStatsService;

	/**
	 * orgTimeStats View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewOrgTimeStats", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewOrgTimeStats() throws Exception {
		return "tim/etc/orgTimeStats/orgTimeStats";
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
	@RequestMapping(params="cmd=getOrgTimeStatsList", method = RequestMethod.POST )
	public ModelAndView getOrgTimeStatsList(
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
			titleList = orgTimeStatsService.getOrgTimeStatsHeaderList(paramMap);
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
			list = orgTimeStatsService.getOrgTimeStatsList(paramMap);

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

	@RequestMapping(params="cmd=getOrgTimeStatsHeaderList", method = RequestMethod.POST )
	public ModelAndView getOrgTimeStatsHeaderList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = orgTimeStatsService.getOrgTimeStatsHeaderList(paramMap);

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
