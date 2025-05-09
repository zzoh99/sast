package com.hr.pap.evaluation.mboTargetKpiMgr;

import java.util.Map;

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
 * 조직KPI관리 Controller
 * @author gjyoo
 *
 */
@Controller
@RequestMapping({"EvaMain.do", "/MboTargetKpiMgr.do"})
public class MboTargetKpiMgrController extends ComController {
	
	/**
	 * 조직KPI관리 View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewMboTargetKpiMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public ModelAndView viewMboTargetKpiMgr(
		HttpSession session,  HttpServletRequest request,
		@RequestParam Map<String, Object> paramMap ) throws Exception {

		ModelAndView mv = new ModelAndView();
		mv.setViewName("pap/evaluation/mboTargetKpiMgr/mboTargetKpiMgr");
		mv.addObject("map", paramMap);

		return mv;
	}

	/**
	 * 조직KPI관리 조직장 목표 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getMboTargetKpiMgrList1", method = RequestMethod.POST )
	public ModelAndView getMboTargetKpiMgrList1(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}

	/**
	 * 조직KPI관리 피평가자별 지정 목표 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getMboTargetKpiMgrList2", method = RequestMethod.POST )
	public ModelAndView getMboTargetKpiMgrList2(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}

	/**
	 * 조직KPI저장 - 프로시저 호출
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=prcMboTargetKpiMgr", method = RequestMethod.POST )
	public ModelAndView prcMboTargetKpiMgr(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();  
		return execPrc(session, request, paramMap);
	}
}
