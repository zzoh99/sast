package com.hr.cpn.payRetire.sepSimulationMgr;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 예상퇴직금 Service
 *
 * @author JM
 *
 */
@Service("SepSimulationMgrService")
public class SepSimulationMgrService{
	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 예상퇴직금 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getSepSimulationMgr(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return (Map<?, ?>) dao.getMap("getSepSimulationMgr", paramMap);
	}

	/**
	 * prcPCpnSepSimulation 프로시저
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map prcPCpnSepSimulation(Map<?, ?> paramMap) throws Exception {
		Log.Debug("prcPCpnSepSimulation");
		return (Map) dao.excute("prcPCpnSepSimulation", paramMap);
	}
}