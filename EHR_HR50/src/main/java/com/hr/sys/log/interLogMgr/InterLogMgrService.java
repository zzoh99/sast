package com.hr.sys.log.interLogMgr;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * interLogMgr Service
 *
 * @author EW
 *
 */
@Service("InterLogMgrService")
public class InterLogMgrService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * interLogMgr 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getInterLogMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getInterLogMgrList", paramMap);
	}

	/**
	 * interLogMgr 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveInterLogMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteInterLogMgr", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveInterLogMgr", convertMap);
		}

		return cnt;
	}
	/**
	 * interLogMgr 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getInterLogMgrMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getInterLogMgrMap", paramMap);
		Log.Debug();
		return resultMap;
	}
}
