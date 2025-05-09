package com.hr.tim.code.workTotalPrtMgr;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 근태/근무인쇄항목설정 Service
 *
 * @author JSG
 *
 */
@Service("WorkTotalPrtMgrService")
public class WorkTotalPrtMgrService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * workTotalPrtMgr 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getWorkTotalPrtMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getWorkTotalPrtMgrList", paramMap);
	}
	
	/**
	 * workTotalPrtMgr 2 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getWorkTotalPrtMgrUserMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getWorkTotalPrtMgrUserMgrList", paramMap);
	}
	
	/**
	 * 1 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveWorkTotalPrtMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteWorkTotalPrtMgr", convertMap);
			dao.delete("deleteWorkTotalPrtUserMgr", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveWorkTotalPrtMgr", convertMap);
		}
		Log.Debug("saveWorkTotalPrtMgr End");
		return cnt;
	}
	
	/**
	 * 2 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveWorkPrtUserMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteWorkPrtUserMgr", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveWorkPrtUserMgr", convertMap);
		}
		Log.Debug("saveWorkPrtUserMgr End");
		return cnt;
	}
	
	
}