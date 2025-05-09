package com.hr.tim.schedule.workPattenMgr;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.com.ComUtilService;
import com.hr.common.dao.Dao;
import com.hr.common.exception.HrException;
import com.hr.common.logger.Log;
/**
 * 근무패턴관리 Service
 *
 * @author JSG
 *
 */
@Service("WorkPattenMgrService")
public class WorkPattenMgrService extends ComUtilService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * workPattenMgr 1 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getWorkPattenMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getWorkPattenMgrList", paramMap);
	}
	
	/**
	 * workPattenMgr 2 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getWorkPattenUserMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getWorkPattenUserMgrList", paramMap);
	}
	
	/**
	 * 1 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveWorkPattenMgr(Map<?, ?> convertMap) throws Exception, HrException {
		Log.Debug();
		int cnt=0;
		
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteWorkPattenMgr", convertMap);
			dao.delete("deleteWorkPattenUserMgrAll", convertMap);

		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveWorkPattenMgr", convertMap);
		}
		
		//EDATE 자동생성 2020.06.03 
		prcComEdateCreate(convertMap, "TTIM118", "workOrgCd", null, null);
		
		Log.Debug("saveWorkPattenMgr End");
		return cnt;
	}
	
	/**
	 * 2 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveWorkPattenUserMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteWorkPattenUserMgr", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveWorkPattenUserMgr", convertMap);
		}
		Log.Debug("saveWorkPattenUserMgr End");
		return cnt;
	}

}