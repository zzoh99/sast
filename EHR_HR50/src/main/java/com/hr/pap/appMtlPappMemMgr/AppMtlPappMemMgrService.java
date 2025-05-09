package com.hr.pap.appMtlPappMemMgr;

import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * SaveData Service
 */
@Service("AppMtlPappMemMgrService")
public class AppMtlPappMemMgrService {
	@Inject
	@Named("Dao")
	private Dao dao;

	/*public int initializeAppMtlPappMem(Map<String, Object> paramMap) throws Exception {
		Log.Debug();
		int cnt = 0;
		cnt += dao.update("initializeAppMtlPappMem", paramMap );
		return cnt;
	}
	
	*//**
	 * 피평가자 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 *//*
	public int saveAppMtlPappMemMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		cnt += dao.update("saveAppMtlPappMemMgr", convertMap);
		Log.Debug();
		return cnt;
	}*/

}
