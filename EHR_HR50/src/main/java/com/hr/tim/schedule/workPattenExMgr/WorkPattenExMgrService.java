package com.hr.tim.schedule.workPattenExMgr;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * workPattenExMgr Service
 *
 * @author EW
 *
 */
@Service("WorkPattenExMgrService")
public class WorkPattenExMgrService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * workPattenExMgr 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getWorkPattenExMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getWorkPattenExMgrList", paramMap);
	}

	/**
	 * workPattenExMgr 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveWorkPattenExMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteWorkPattenExMgr", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveWorkPattenExMgr", convertMap);
		}

		return cnt;
	}
	/**
	 * workPattenExMgr 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getWorkPattenExMgrMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getWorkPattenExMgrMap", paramMap);
		Log.Debug();
		return resultMap;
	}
}
