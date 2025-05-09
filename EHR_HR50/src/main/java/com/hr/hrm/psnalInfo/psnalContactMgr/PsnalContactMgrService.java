package com.hr.hrm.psnalInfo.psnalContactMgr;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * psnalContactMgr Service
 *
 * @author EW
 *
 */
@Service("PsnalContactMgrService")
public class PsnalContactMgrService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * psnalContactMgr 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPsnalContactMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getPsnalContactMgrList", paramMap);
	}

	/**
	 * psnalContactMgr 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int savePsnalContactMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deletePsnalContactMgr", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("savePsnalContactMgr", convertMap);
		}

		return cnt;
	}
	/**
	 * psnalContactMgr 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getPsnalContactMgrMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getPsnalContactMgrMap", paramMap);
		Log.Debug();
		return resultMap;
	}
	/**
	 * psnalContactMgr 프로시저 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> PsnalContactMgrPrcP_PROCEDURE(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (Map<?, ?>) dao.excute("PsnalContactMgrPrcP_PROCEDURE", paramMap);
	}
}
