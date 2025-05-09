package com.hr.tim.month.dailyWorkStatus;
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
 * 일근무관리 Controller
 *
 * @author JSG
 *
 */
@Controller
@RequestMapping(value="/DailyWorkStatus.do", method=RequestMethod.POST )
public class DailyWorkStatusController {
	/**
	 * 일근무관리 서비스
	 */
	@Inject
	@Named("DailyWorkStatusService")
	private DailyWorkStatusService dailyWorkStatusService;

	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;

	/**
	 * dailyWorkStatus View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewDailyWorkStatus", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewDailyWorkStatus() throws Exception {
		return "tim/month/dailyWorkStatus/dailyWorkStatus";
	}

	/**
	 * dailyWorkStatus(세부내역) 팝업 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewDailyWorkStatusPop", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewDailyWorkStatusPop() throws Exception {
		return "tim/month/dailyWorkStatus/dailyWorkStatusPop";
	}

	/**
	 * dailyWorkStatus 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getDailyWorkStatusHeaderList", method = RequestMethod.POST )
	public ModelAndView getDailyWorkStatusHeaderList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = dailyWorkStatusService.getDailyWorkStatusHeaderList(paramMap);
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
	 * 일근무관리 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getDailyWorkStatusList", method = RequestMethod.POST )
	public ModelAndView getDailyWorkStatusList(
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
			//map  = dailyWorkStatusService.getDailyWorkStatusCntMap(paramMap);
			titleList = dailyWorkStatusService.getDailyWorkStatusHeaderList(paramMap);
			paramMap.put("titles", titleList);
			list = dailyWorkStatusService.getDailyWorkStatusList(paramMap);
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
}
