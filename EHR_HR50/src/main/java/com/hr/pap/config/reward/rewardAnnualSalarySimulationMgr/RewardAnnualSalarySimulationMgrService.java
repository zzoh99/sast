package com.hr.pap.config.reward.rewardAnnualSalarySimulationMgr;

import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;

/**
 * 평가대상자생성/관리 Service
 *
 * @author JSG
 *
 */
@Service("RewardAnnualSalarySimulationMgrService")
public class RewardAnnualSalarySimulationMgrService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 *  ps시뮬기준 자료 체크
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getRewardPsIncreaseSimulationIdChk(Map<?, ?> paramMap) throws Exception {
		Map<?, ?> resultMap = dao.getMap("getRewardPsIncreaseSimulationIdChk", paramMap);
		return resultMap;
	}

}
