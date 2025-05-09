package com.hr.tim.month.timeCardMgr;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * TimeCard관리 Service
 *
 * @author jcy
 *
 */
@Service("TimeCardMgrService")
public class TimeCardMgrService{
	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * TimeCard관리 단건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?,?> getTimeCardMgr(String queryId, Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (Map<?,?>) dao.getMap(queryId, paramMap);
	}
	
	/**
	 * timeCardMgr 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getTimeCardMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getTimeCardMgrList", paramMap);
	}

	/**
	 * timeCardMgr 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveTimeCardMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteTimeCardMgr", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveTimeCardMgr", convertMap);
		}

		return cnt;
	}

	/**
	 * TimeCard관리 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveTimeCardMgrPopTemp332(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveTimeCardMgrPopTemp332", convertMap);
		}

		return cnt;
	}

	/**
	 * TimeCard관리 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int deleteTimeCardMgrPopTemp332(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
			cnt += dao.update("deleteTimeCardMgrPopTemp332", convertMap);

		return cnt;
	}

	/**
	 * TimeCard관리 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveTimeCardMgrPop(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveTimeCardMgrPop", convertMap);
		}

		return cnt;
	}
	
	/**
	 * 프로시저 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map callTimeCardMgrWorkHourChg(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		
		return (Map) dao.excute("callTimeCardMgrWorkHourChg", paramMap);
	}
	
	/**
	 * 프로시저 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map callP_TIM_SECOM_TIME_CRE(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		
		return (Map) dao.excute("callP_TIM_SECOM_TIME_CRE", paramMap);
	}
	
	
	/**
	 * 프로시저 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map prcP_TIM_TC_LOAD(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return (Map) dao.excute("prcP_TIM_TC_LOAD", paramMap);
	}
	
	/**
	 * 프로시저 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map callTimeCardMgrP_TIM_WORK_HOUR_CHG(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return (Map) dao.excute("callTimeCardMgrP_TIM_WORK_HOUR_CHG", paramMap);
	}


}