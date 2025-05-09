package com.hr.pap.progress.appResultMgr;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 평가결과종합관리 Service
 *
 * @author JCY
 *
 */
@Service("AppResultMgrService")
public class AppResultMgrService{
	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 *  평가결과종합관리 단건 조회 Service (평가ID 정보 조회)
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getAppResultMgrMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getAppResultMgrMap", paramMap);
	}

}