package com.hr.ben.benefitBasis.natiPenRatioMgr;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * natiPenRatioMgr Service
 *
 * @author EW
 *
 */
@Service("NatiPenRatioMgrService")
public class NatiPenRatioMgrService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * natiPenRatioMgr 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getNatiPenRatioMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getNatiPenRatioMgrList", paramMap);
	}

	/**
	 * natiPenRatioMgr 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveNatiPenRatioMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteNatiPenRatioMgr", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveNatiPenRatioMgr", convertMap);
		}

		return cnt;
	}
	/**
	 * natiPenRatioMgr 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getNatiPenRatioMgrMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getNatiPenRatioMgrMap", paramMap);
		Log.Debug();
		return resultMap;
	}
}
