package com.hr.pap.appPappMemMgr;

import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 평가자맵핑 Service
 */
@Service("AppPappMemMgrService")
public class AppPappMemMgrService {
	@Inject
	@Named("Dao")
	private Dao dao;

	public int deleteInitializeAppPappMem(Map<String, Object> paramMap) throws Exception {
		Log.Debug();
		int cnt = 0;
		cnt += dao.update("deleteInitializeAppPappMem", paramMap );
		return cnt;
	}
	
	/**
	 * 평가자 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveAppPappMemMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		cnt += dao.update("saveAppPappMemMgr", convertMap);
		Log.Debug();
		return cnt;
	}

}
