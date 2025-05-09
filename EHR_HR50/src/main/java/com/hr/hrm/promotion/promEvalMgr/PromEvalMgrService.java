package com.hr.hrm.promotion.promEvalMgr;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import javax.inject.Named;
import java.util.List;
import java.util.Map;

/**
 * 승진급심사관리 Service
 *
 * @author 이름
 *
 */
@Service("PromEvalMgrService")
public class PromEvalMgrService {

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 승진급심사관리 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<Map<String, Object>> getPromEvalMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<Map<String, Object>>) dao.getList("getPromEvalMgrList", paramMap);
	}

	/**
	 * 승진급심사관리 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int savePromEvalMgr(Map<?, ?> convertMap) throws Exception {
		Log.DebugStart();
		int cnt=0;
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("savePromEvalMgr", convertMap);
		}
		Log.DebugEnd();
		return cnt;
	}
}