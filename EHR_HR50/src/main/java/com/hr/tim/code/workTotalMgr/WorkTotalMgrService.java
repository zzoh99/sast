package com.hr.tim.code.workTotalMgr;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 근무코드/근무일집계설정 Service
 *
 * @author JSG
 *
 */
@Service("WorkTotalMgrService")
public class WorkTotalMgrService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 *  근무코드집계설정 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getWorkTotalMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getWorkTotalMgrList", paramMap);
	}
	
	/**
	 *  근무코드집계설정 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getWorkTotalMgrUserMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getWorkTotalMgrUserMgrList", paramMap);
	}
	
	/**
	 * 1 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveWorkTotalMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteWorkTotalMgr", convertMap);
			dao.delete("deleteWorkTotalUserMgr", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveWorkTotalMgr", convertMap);
		}
		Log.Debug("saveWorkTotalMgr End");
		return cnt;
	}
	
	/**
	 * 2 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveWorkCdUserMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteWorkCdUserMgr", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveWorkCdUserMgr", convertMap);
		}
		Log.Debug("saveWorkTotalMgr End");
		return cnt;
	}
}