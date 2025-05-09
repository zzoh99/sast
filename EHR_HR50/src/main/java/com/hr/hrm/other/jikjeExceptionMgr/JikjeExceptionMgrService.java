package com.hr.hrm.other.jikjeExceptionMgr;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * jikjeExceptionMgr Service
 *
 * @author EW
 *
 */
@Service("JikjeExceptionMgrService")
public class JikjeExceptionMgrService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * jikjeExceptionMgr 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getJikjeExceptionMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getJikjeExceptionMgrList", paramMap);
	}

	/**
	 * jikjeExceptionMgr 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveJikjeExceptionMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteJikjeExceptionMgr", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveJikjeExceptionMgr", convertMap);
		}

		return cnt;
	}
	/**
	 * jikjeExceptionMgr 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getJikjeExceptionMgrMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getJikjeExceptionMgrMap", paramMap);
		Log.Debug();
		return resultMap;
	}
}
