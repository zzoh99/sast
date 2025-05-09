package com.hr.pap.config.reward.rewardPsSimulationMgr;

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
 * 시뮬레이션기준관리 Controller
 * @author gjyoo
 *
 */
@Controller
@RequestMapping(value="/RewardPsSimulationMgr.do", method=RequestMethod.POST )
public class RewardPsSimulationMgrController extends ComController {

	
	/**
	 * 시뮬레이션기준관리 View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewRewardPsSimulationMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewRewardPsSimulationMgr() throws Exception {
		return "pap/reward/rewardPsSimulationMgr/rewardPsSimulationMgr";
	}

	/**
	 * 시뮬레이션기준관리 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getRewardPsSimulationMgrList", method = RequestMethod.POST )
	public ModelAndView getRewardPsSimulationMgrList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}

	/**
	 * 시뮬레이션기준관리 저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveRewardPsSimulationMgr", method = RequestMethod.POST )
	public ModelAndView saveRewardPsSimulationMgr(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return saveData(session, request, paramMap);
	}
}
