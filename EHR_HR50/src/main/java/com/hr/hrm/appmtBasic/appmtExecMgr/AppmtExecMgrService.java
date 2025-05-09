package com.hr.hrm.appmtBasic.appmtExecMgr;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * appmtExecMgr Service
 *
 * @author EW
 *
 */
@Service("AppmtExecMgrService")
public class AppmtExecMgrService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * appmtExecMgr 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getAppmtExecMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getAppmtExecMgrList", paramMap);
	}

	/**
	 * appmtExecMgr 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveAppmtExecMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteAppmtExecMgr", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveAppmtExecMgr", convertMap);
		}

		return cnt;
	}
	/**
	 * appmtExecMgr 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getAppmtExecMgrMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getAppmtExecMgrMap", paramMap);
		Log.Debug();
		return resultMap;
	}
}
