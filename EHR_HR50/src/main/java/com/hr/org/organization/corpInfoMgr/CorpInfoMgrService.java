package com.hr.org.organization.corpInfoMgr;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * corpInfoMgr Service
 *
 * @author EW
 *
 */
@Service("CorpInfoMgrService")
public class CorpInfoMgrService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * corpInfoMgr 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getCorpInfoMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getCorpInfoMgrList", paramMap);
	}

	/**
	 * corpInfoMgr 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getCorpInfoMgrListDetail(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getCorpInfoMgrListDetail", paramMap);
	}

	/**
	 * corpInfoMgr 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveCorpInfoMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteCorpInfoMgr", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveCorpInfoMgr", convertMap);
		}

		return cnt;
	}

	/**
	 * corpInfoMgr 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveCorpInfoMgrDetail(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteCorpInfoMgrDetail", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveCorpInfoMgrDetail", convertMap);
		}

		return cnt;
	}

	/**
	 * corpInfoMgr 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getCorpInfoMgrLocationMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getCorpInfoMgrLocationMap", paramMap);
		Log.Debug();
		return resultMap;
	}
}
