package com.hr.tim.code.timeCdMgr;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * timeCdMgr Service
 *
 * @author EW
 *
 */
@Service("TimeCdMgrService")
public class TimeCdMgrService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * timeCdMgr 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getTimeCdMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getTimeCdMgrList", paramMap);
	}

	/**
	 * timeCdMgr 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveTimeCdMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteTimeCdMgr", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveTimeCdMgr", convertMap);
		}

		return cnt;
	}
	/**
	 * timeCdMgr 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getTimeCdMgrMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getTimeCdMgrMap", paramMap);
		Log.Debug();
		return resultMap;
	}
}
