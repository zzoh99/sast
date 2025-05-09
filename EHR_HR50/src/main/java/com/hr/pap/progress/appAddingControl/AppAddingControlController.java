package com.hr.pap.progress.appAddingControl;
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
 * 평가결과집계및마감 Controller
 *
 * @author JCY
 *
 */
@Controller
@RequestMapping(value="/AppAddingControl.do", method=RequestMethod.POST )
public class AppAddingControlController extends ComController {
	/**
	 * 평가결과집계및마감 서비스
	 */
	@Inject
	@Named("AppAddingControlService")
	private AppAddingControlService appAddingControlService;

	/**
	 * 평가결과집계및마감 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewAppAddingControl", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewAppAddingControl() throws Exception {
		return "pap/progress/appAddingControl/appAddingControl";
	}

	/**
	 * 평가결과집계및마감 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewAppPeopleShowPop", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewAppPeopleShowPop() throws Exception {
		return "pap/progress/appAddingControl/appPeopleShowPop";
	}

	/**
	 * 평가결과집계및마감 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewAppPeopleShowLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewAppPeopleShowLayer() throws Exception {
		return "pap/progress/appAddingControl/appPeopleShowLayer";
	}
	
	/**
	 * 평가결과집계및마감 단건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAppAddingControlMap1", method = RequestMethod.POST )
	public ModelAndView getAppAddingControlMap1(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));

		Map<?, ?> map = appAddingControlService.getAppAddingControlMap1(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("map", map);

		Log.DebugEnd();
		return mv;
	}

	/**
	 * 평가결과집계 - 프로시저 호출
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=prcAppAddingControl1", method = RequestMethod.POST )
	public ModelAndView prcAppAddingControl1(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();  
		return execPrc(session, request, paramMap);
	}

	/**
	 * 평가조정계산 - 프로시저 호출
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=prcAppAddingControl2", method = RequestMethod.POST )
	public ModelAndView prcAppAddingControl2(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();  
		return execPrc(session, request, paramMap);
	}

	/**
	 * 부서이동평가자반영 - 프로시저 호출
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=prcAppAddingControl3", method = RequestMethod.POST )
	public ModelAndView prcAppAddingControl3(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();  
		return execPrc(session, request, paramMap);
	}

	/**
	 * 평가등급계산 - 프로시저 호출
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=prcAppAddingControl4", method = RequestMethod.POST )
	public ModelAndView prcAppAddingControl4(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();  
		return execPrc(session, request, paramMap);
	}

	/**
	 * 평가마감 - 프로시저 호출
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=prcAppAddingControl5", method = RequestMethod.POST )
	public ModelAndView prcAppAddingControl5(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();  
		return execPrc(session, request, paramMap);
	}

	/**
	 * KPI 최종결과반영 - 프로시저 호출
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=prcAppAddingControl6", method = RequestMethod.POST )
	public ModelAndView prcAppAddingControl6(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();  
		return execPrc(session, request, paramMap);
	}

	/**
	 * 종합평가등급계산 - 프로시저 호출
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=prcAppAddingControl7", method = RequestMethod.POST )
	public ModelAndView prcAppAddingControl7(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();  
		return execPrc(session, request, paramMap);
	}

	/**
	 * 1차평가 후 표준화작업 - 프로시저 호출
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=prcAppAddingControl8", method = RequestMethod.POST )
	public ModelAndView prcAppAddingControl8(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();  
		return execPrc(session, request, paramMap);
	}
}
