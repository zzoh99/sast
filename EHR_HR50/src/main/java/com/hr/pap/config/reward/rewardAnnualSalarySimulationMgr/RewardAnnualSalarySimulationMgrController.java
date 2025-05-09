package com.hr.pap.config.reward.rewardAnnualSalarySimulationMgr;

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
 * 연봉시뮬레이션 Controller
 * @author chs
 *
 */
@Controller
@RequestMapping(value="/RewardAnnualSalarySimulationMgr.do", method=RequestMethod.POST )
public class RewardAnnualSalarySimulationMgrController extends ComController {
	/**
	 * 사용할 서비스 선언
	 */
	@Inject
	@Named("RewardAnnualSalarySimulationMgrService")
	private RewardAnnualSalarySimulationMgrService rewardAnnualSalarySimulationMgrService;
	
	
	/**
	 * 연봉시뮬레이션  View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewRewardAnnualSalarySimulationMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewRewardAnnualSalarySimulationMgr() throws Exception {
		return "pap/reward/rewardAnnualSalarySimulationMgr/rewardAnnualSalarySimulationMgr";
	}

	/**
	 * 연봉시뮬레이션 다건 조회1
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getRewardAnnualSalarySimulationMgrList", method = RequestMethod.POST )
	public ModelAndView getRewardAnnualSalarySimulationMgrList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}

	/**
	 * 연봉시뮬레이션 다건 조회2
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getRewardAnnualSalarySimulationMgrList2", method = RequestMethod.POST )
	public ModelAndView getRewardAnnualSalarySimulationMgrList2(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}	
	
	/**
	 * ps시뮬기준 자료 체크
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getRewardPsIncreaseSimulationIdChk", method = RequestMethod.POST )
	public ModelAndView getRewardPsIncreaseSimulationIdChk(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		Map<?, ?> map = rewardAnnualSalarySimulationMgrService.getRewardPsIncreaseSimulationIdChk(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("resultMap", map);
		Log.DebugEnd();
		return mv;
	}	
	
	/**
	 * 연봉시뮬레이션 등급 리스트 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getRewardAnnualSalarySimulationMgrPayRateList", method = RequestMethod.POST )
	public ModelAndView getRewardAnnualSalarySimulationMgrPayRateList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}		
	
	/**
	 * 연봉시뮬레이션 저장1
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveRewardAnnualSalarySimulationMgr", method = RequestMethod.POST )
	public ModelAndView saveRewardAnnualSalarySimulationMgr(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return saveData(session, request, paramMap);
	}
	
	/**
	 * 연봉시뮬레이션 저장2
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveRewardAnnualSalarySimulationMgr2", method = RequestMethod.POST )
	public ModelAndView saveRewardAnnualSalarySimulationMgr2(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return saveData(session, request, paramMap);
	}
	
	/**
	 * ps대상자 생성  - 프로시저 호출
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=prcRewardAnnualSalarySimulation", method = RequestMethod.POST )
	public ModelAndView prcRewardAnnualSalarySimulation(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();  
		return execPrc(session, request, paramMap);
	}
	
}
