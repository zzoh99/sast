package com.hr.ben.health.healthMgr;

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
 * 건강검진 대상자관리 Controller
 *
 * @author JY
 *
 */
@Controller
@RequestMapping(value="/HealthMgr.do", method=RequestMethod.POST )
public class HealthMgrController extends ComController {
	
	/**
	 * 건강검진 대상자관리 서비스
	 */
	@Inject
	@Named("HealthMgrService")
	private HealthMgrService healthMgrService;

	/**
	 * 건강검진대상자관리 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewHealthMgr",method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewSchMgr() throws Exception {
		return "ben/health/healthMgr/healthMgr";
	}


	/**
	 * 건강검진대상자관리 - 대상자 선택 팝업 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewHealthMgrLayer",method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewHealthMgrLayer() throws Exception {
		return "ben/health/healthMgr/healthMgrLayer";
	}
	
	/**
	 * 건강검진대상자관리 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getHealthMgrList", method = RequestMethod.POST )
	public ModelAndView getHealthMgrList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}

	/**
	 * 건강검진대상자관리 대상자선택 팝업 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getHealthMgrPopList", method = RequestMethod.POST )
	public ModelAndView getHealthMgrPopList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}
	
	/**
	 * 건강검진대상자관리 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveHealthMgr", method = RequestMethod.POST )
	public ModelAndView saveHealthMgr(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();  
		return saveData(session, request, paramMap);
	}

	/**
	 * 건강검진대상자관리 저장 ( 엑셀업로드 후 저장 )
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveHealthMgrExcel", method = RequestMethod.POST )
	public ModelAndView saveHealthMgrExcel(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();  
		return saveData(session, request, paramMap);
	}
	
	
	/**
	 * 건강검진대상자관리 - 대상자생성 프로시저 호출
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=prcHealthMgr", method = RequestMethod.POST )
	public ModelAndView prcHealthMgr(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();  
		return execPrc(session, request, paramMap);
	}
}
