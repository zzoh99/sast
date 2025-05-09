package com.hr.tim.code.workTimeCdMgr;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 근무시간코드설정 Service
 *
 * @author bckim
 *
 */
@Service("WorkTimeCdMgrService")
public class WorkTimeCdMgrService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * workTimeCdMgr 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getWorkTimeCdMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getWorkTimeCdMgrList", paramMap);
	}
	
	/**
	 * workTimeCdMgr 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getWorkTimeCdMgrStdHourList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getWorkTimeCdMgrStdHourList", paramMap);
	}
	
	/**
	 * workTimeCdMgr 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getWorkTimeCdMgrMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getWorkTimeCdMgrMap", paramMap);
		Log.Debug();
		return resultMap;
	}
	
	/**
	 * 근무시간코드설정 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveWorkTimeCdMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			dao.delete("deleteWorkTimeCdMgr", convertMap);
			dao.delete("deleteWorkTimeCdMgrStdHour", convertMap);
			dao.delete("deleteWorkTimeCdMgrWorkGrp", convertMap);
			dao.delete("deleteWorkTimeCdMgrPatten", convertMap);
			cnt += dao.delete("deleteWorkTimeCdMgr", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveWorkTimeCdMgr", convertMap);
		}
		Log.Debug();
		return cnt;
	}
	
	/**
	 * 예외인정근무시간 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveWorkTimeCdMgrStdHour(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteWorkTimeCdMgrStdHour", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveWorkTimeCdMgrStdHour", convertMap);
		}
		Log.Debug();
		return cnt;
	}
}