package com.hr.pap.appGroupMemMgr;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 평가그룹매핑 Service
 */
@Service("AppGroupMemMgrService")
public class AppGroupMemMgrService{
	@Inject
	@Named("Dao")
	private Dao dao;

	public int updateInitializeAppGroupMem(Map<String, Object> paramMap) throws Exception {
		Log.Debug();
		int cnt = 0;
		cnt += dao.update("updateInitializeAppGroupMem", paramMap );
		return cnt;
	}
	
	/**
	 * 평가그룹 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveAppGroupMemMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		cnt += dao.update("saveAppGroupMemMgr", convertMap);
		Log.Debug();
		return cnt;
	}
}