package com.hr.hri.applyApproval.appDeputyMgr;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * appDeputyMgr Service
 *
 * @author EW
 *
 */
@Service("AppDeputyMgrService")
public class AppDeputyMgrService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * appDeputyMgr 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getAppDeputyMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getAppDeputyMgrList", paramMap);
	}

	/**
	 * appDeputyMgr 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveAppDeputyMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteAppDeputyMgr", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveAppDeputyMgr", convertMap);
		}

		return cnt;
	}
	/**
	 * appDeputyMgr 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getAppDeputyMgrMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getAppDeputyMgrMap", paramMap);
		Log.Debug();
		return resultMap;
	}
}
