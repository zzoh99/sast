package com.hr.tim.schedule.workOrgScheduleCre;
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

/**
 * 근무스케줄 생성 Controller
 *
 * @author 
 *
 */
@Controller
@RequestMapping(value="/WorkOrgScheduleCre.do", method=RequestMethod.POST )
public class WorkOrgScheduleCreController {

	/**
	 * 근무스케줄 생성 서비스
	 */
	@Inject
	@Named("WorkOrgScheduleCreService")
	private WorkOrgScheduleCreService workOrgScheduleCreService;

	/**
	 * 근무스케줄 생성 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewWorkOrgScheduleCre", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewWorkOrgScheduleCre() throws Exception {
		return "tim/schedule/workOrgScheduleCre/workOrgScheduleCre";
	}

	/**
	 * 근무스케줄 생성 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getWorkOrgScheduleCre", method = RequestMethod.POST )
	public ModelAndView getWorkOrgScheduleCre(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",   session.getAttribute("ssnSabun"));

		Map<?, ?> map  = new HashMap<String,Object>();
		String Message = "";
		try{
			map = workOrgScheduleCreService.getWorkOrgScheduleCre(paramMap);

		}catch(Exception e){
			Message="조회에 실패 하였습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", map);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}
	
	/**
	 * workOrgScheduleCre 단건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getWorkOrgScheduleProgress", method = RequestMethod.POST )
	public ModelAndView getWorkOrgScheduleProgress(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		
		Map<?, ?> map = null;
		String Message = "";
		
		try{
			map = workOrgScheduleCreService.getWorkOrgScheduleProgress(paramMap);
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
	 * 근무스케줄 생성(처리) 프로시저
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=prcWorkOrgScheduleCre", method = RequestMethod.POST )
	public ModelAndView prcWorkOrgScheduleCre(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",   session.getAttribute("ssnSabun"));

		Map map  = workOrgScheduleCreService.prcWorkOrgScheduleCre(paramMap);

		Log.Debug("obj : "+map);
		Log.Debug("sqlcode : "+map.get("sqlcode"));
		Log.Debug("sqlerrm : "+map.get("sqlerrm"));

		Map<String, Object> resultMap = new HashMap<String, Object>();
		if (map.get("sqlCode") != null) {
			resultMap.put("Code", map.get("sqlCode").toString());
		}
		if (map.get("sqlErrm") != null) {
			resultMap.put("Message", map.get("sqlErrm").toString());
		}

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Result", resultMap);
		Log.DebugEnd();
		return mv;
	}
	
	@RequestMapping(params="cmd=prcWorkOrgScheduleCre2", method = RequestMethod.POST )
	public ModelAndView prcWorkOrgScheduleCre2(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",   session.getAttribute("ssnSabun"));

		Map map  = workOrgScheduleCreService.prcWorkOrgScheduleCre2(paramMap);

		Log.Debug("obj : "+map);
		Log.Debug("sqlcode : "+map.get("sqlcode"));
		Log.Debug("sqlerrm : "+map.get("sqlerrm"));

		Map<String, Object> resultMap = new HashMap<String, Object>();
		if (map.get("sqlCode") != null) {
			resultMap.put("Code", map.get("sqlCode").toString());
		}
		if (map.get("sqlErrm") != null) {
			resultMap.put("Message", map.get("sqlErrm").toString());
		}

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Result", resultMap);
		Log.DebugEnd();
		return mv;
	}
	
}
