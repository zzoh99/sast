package com.hr.ben.health.healthStd;

import com.hr.common.com.ComController;
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
import java.util.Map;

/**
 * 건강검진 기준관리 Controller
 *
 * @author JY
 *
 */
@Controller
@RequestMapping(value="/HealthStd.do", method=RequestMethod.POST )
public class HealthStdController extends ComController {
	
	/**
	 * 건강검진 기준관리 서비스
	 */
	@Inject
	@Named("HealthStdService")
	private HealthStdService healthStdService;

	/**
	 * 건강검진기준관리 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewHealthStd",method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewSchStd() throws Exception {
		return "ben/health/healthStd/healthStd";
	}
	
	/**
	 * 건강검진기준관리 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getHealthStdList", method = RequestMethod.POST )
	public ModelAndView getHealthStdList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}
	
	/**
	 * 건강검진기준관리 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveHealthStd", method = RequestMethod.POST )
	public ModelAndView saveHealthStd(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();  
		return saveData(session, request, paramMap);
	}
}
