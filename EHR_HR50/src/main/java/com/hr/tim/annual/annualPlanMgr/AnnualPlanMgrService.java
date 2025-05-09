package com.hr.tim.annual.annualPlanMgr;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * annualPlanMgr Service
 *
 * @author EW
 *
 */
@Service("AnnualPlanMgrService")
public class AnnualPlanMgrService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * annualPlanMgr 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getAnnualPlanMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getAnnualPlanMgrList", paramMap);
	}

	/**
	 * annualPlanMgr 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveAnnualPlanMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteAnnualPlanMgr", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveAnnualPlanMgr", convertMap);
		}

		return cnt;
	}
	/**
	 * annualPlanMgr 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getAnnualPlanMgrMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getAnnualPlanMgrMap", paramMap);
		Log.Debug();
		return resultMap;
	}
}
