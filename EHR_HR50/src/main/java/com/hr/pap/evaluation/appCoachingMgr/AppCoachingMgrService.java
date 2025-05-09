package com.hr.pap.evaluation.appCoachingMgr;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * Coaching확인 Service
 *
 * @author EW
 *
 */
@Service("AppCoachingMgrService")
public class AppCoachingMgrService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * Coaching확인 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getAppCoachingMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getAppCoachingMgrList", paramMap);
	}

	/**
	 * Coaching확인 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveAppCoachingMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteAppCoachingMgr", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveAppCoachingMgr", convertMap);
		}

		return cnt;
	}
}
