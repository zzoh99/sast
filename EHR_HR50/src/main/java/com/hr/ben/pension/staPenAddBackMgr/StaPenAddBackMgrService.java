package com.hr.ben.pension.staPenAddBackMgr;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.dao.ProDao;
import com.hr.common.logger.Log;

/**
 * staPenAddBackMgr Service
 *
 * @author EW
 *
 */
@Service("StaPenAddBackMgrService")
public class StaPenAddBackMgrService{

	@Inject
	@Named("Dao")
	private Dao dao;

	@Inject
	@Named("ProDao")
	private ProDao proDao;

	/**
	 * staPenAddBackMgr 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getStaPenAddBackMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getStaPenAddBackMgrList", paramMap);
	}

	/**
	 * staPenAddBackMgr 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveStaPenAddBackMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteStaPenAddBackMgr", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveStaPenAddBackMgr", convertMap);
		}

		return cnt;
	}
	/**
	 * staPenAddBackMgr 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getStaPenAddBackMgrMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getStaPenAddBackMgrMap", paramMap);
		Log.Debug();
		return resultMap;
	}
}
