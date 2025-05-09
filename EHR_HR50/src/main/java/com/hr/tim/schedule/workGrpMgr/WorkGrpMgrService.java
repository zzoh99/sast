package com.hr.tim.schedule.workGrpMgr;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 근무그룹관리 Service
 * 
 * @author jcy
 *
 */
@Service("WorkGrpMgrService")  
public class WorkGrpMgrService{
	@Inject
	@Named("Dao")
	private Dao dao;
	
	/**
	 * 근무그룹관리 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getWorkPattenMgrGrpList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getWorkPattenMgrGrpList", paramMap);
	}
	
	/**
	 * 근무그룹관리 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getWorkPattenMgrTimeGrp(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getWorkPattenMgrTimeGrp", paramMap);
	}

	/**
	 * 근무그룹관리 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveWorkPattenMgrGrp(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteWorkPattenMgrGrp", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveWorkPattenMgrGrp", convertMap);
		}

		return cnt;
	}
	
	/**
	 * 근무그룹관리 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveWorkPattenMgrTimeGrp(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteWorkPattenMgrTimeGrp", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveWorkPattenMgrTimeGrp", convertMap);
		}

		return cnt;
	}
}