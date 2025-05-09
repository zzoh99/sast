package com.hr.pap.config.reward.rewardPsIncreaseSimulationMgr;

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
 * PS인상시뮬레이션 Controller
 * @author chs
 *
 */
@Controller
@RequestMapping(value="/RewardPsIncreaseSimulationMgr.do", method=RequestMethod.POST ) 
public class RewardPsIncreaseSimulationMgrController extends ComController {
	/**
	 * 사용할 서비스 선언
	 */
	@Inject
	@Named("RewardPsIncreaseSimulationMgrService")
	private RewardPsIncreaseSimulationMgrService rewardPsIncreaseSimulationMgrService;
	
	
	/**
	 * PS인상시뮬레이션  View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewRewardPsIncreaseSimulationMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewRewardPsIncreaseSimulationMgr() throws Exception {
		return "pap/reward/rewardPsIncreaseSimulationMgr/rewardPsIncreaseSimulationMgr";
	}

	/**
	 * PS인상시뮬레이션 다건 조회1
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getRewardPsIncreaseSimulationMgrList", method = RequestMethod.POST )
	public ModelAndView getRewardPsIncreaseSimulationMgrList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}

	/**
	 * PS인상시뮬레이션 다건 조회2
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getRewardPsIncreaseSimulationMgrList2", method = RequestMethod.POST )
	public ModelAndView getRewardPsIncreaseSimulationMgrList2(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}	
	
	/**
	 * PS인상시뮬레이션 다건 조회3
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getRewardPsIncreaseSimulationMgrList3", method = RequestMethod.POST )
	public ModelAndView getRewardPsIncreaseSimulationMgrList3(
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
		Map<?, ?> map = rewardPsIncreaseSimulationMgrService.getRewardPsIncreaseSimulationIdChk(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("resultMap", map);
		Log.DebugEnd();
		return mv;
	}	
	
	/**
	 * PS인상시뮬레이션 등급 리스트 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getRewardPsIncreaseSimulationMgrPayRateList", method = RequestMethod.POST )
	public ModelAndView getRewardPsIncreaseSimulationMgrPayRateList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}		
	
	/**
	 * PS인상시뮬레이션 저장1
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveRewardPsIncreaseSimulationMgr", method = RequestMethod.POST )
	public ModelAndView saveRewardPsIncreaseSimulationMgr(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return saveData(session, request, paramMap);
	}
	
	/**
	 * PS인상시뮬레이션 저장2
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveRewardPsIncreaseSimulationMgr2", method = RequestMethod.POST )
	public ModelAndView saveRewardPsIncreaseSimulationMgr2(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return saveData(session, request, paramMap);
	}
	
	/**
	 * PS인상시뮬레이션 저장3
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveRewardPsIncreaseSimulationMgr3", method = RequestMethod.POST )
	public ModelAndView saveRewardPsIncreaseSimulationMgr3(
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
	@RequestMapping(params="cmd=prcRewardPsIncreaseSimulation", method = RequestMethod.POST )
	public ModelAndView prcRewardPsIncreaseSimulation(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();  
		return execPrc(session, request, paramMap);
	}
	
}
