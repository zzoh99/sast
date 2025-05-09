package com.hr.pap.progress.mboUploadMgr;

import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 성과(보상)항목관리 Service
 */
@Service("MboUploadMgrService")
public class MboUploadMgrService {
	@Inject
	@Named("Dao")
	private Dao dao;
	
	/**
	 * 성과(보상)항목관리 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveMboUploadMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteMboUploadMgr", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveMboUploadMgr", convertMap);
		}
		return cnt;
	}

	/**
	 * 성과(보상)항목관리 전체삭제 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int deleteMboUploadMgrAll(Map<?, ?> pramMap) throws Exception {
		Log.Debug();
		int cnt=0;
		cnt += dao.delete("deleteMboUploadMgrAll", pramMap);
		return cnt;
	}
}
