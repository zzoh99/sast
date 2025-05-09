package com.hr.tim.request.workday;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
import com.hr.common.util.DateUtil;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import javax.inject.Named;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 근태신청 Service
 *
 * @author JSG
 *
 */
@Service
public class WorkdayAppService {

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * WorkdayApp 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getWorkdayAppList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getWorkdayAppList", paramMap);
	}
	
	/**
	 * WorkdayApp 다건 조회 2 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getWorkdayAppExList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getWorkdayAppExList", paramMap);
	}
	
	/**
	 * WorkdayApp 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getWorkdayAppListToday(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getWorkdayAppListToday", paramMap);
		Log.Debug();
		return resultMap;
	}
	
	/**
	 *  근태신청(휴가사용내역)  저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveWorkdayAppEx(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			dao.delete("deleteApprovalMgrMaster", convertMap);   // ApprovalMgr-mapping-query.xml 쿼리
			cnt += dao.delete("deleteWorkdayAppEx", convertMap);
		}
		Log.Debug();
		return cnt;
	}
	

	/**
	 * 근태 신청 삭제
	 * 
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int deleteWorkdayApp(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		
		int cnt=0;
		
		if(convertMap.get("deleteRows") != null) {
			if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
				cnt += dao.delete("deleteWorkdayApp", 	  convertMap);  	//delete TTIM301
				cnt += dao.delete("deleteApprovalMgrMaster",  convertMap);  //delete THRI103
				cnt += dao.delete("deleteApprovalMgrAppLine", convertMap);  //delete THRI107
			}
		}
		Log.Debug();
		return cnt;
	}
	/**
	 * 근태 취소신청 삭제
	 * 
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int deleteWorkdayAppUpd(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		
		int cnt=0;
		
		if(convertMap.get("deleteRows") != null) {
			if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
				cnt += dao.delete("deleteWorkdayAppUpd", convertMap);  //delete TTIM383
				cnt += dao.delete("deleteApprovalMgrMaster2",  convertMap);  //delete THRI103
				cnt += dao.delete("deleteApprovalMgrAppLine2",  convertMap);  //delete THRI107
			}
		}
		Log.Debug();
		return cnt;
	}

	public Map<?, ?> getWorktimeAppPlan(Map<String, Object> paramMap) throws Exception{
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getWorktimeAppPlan2", paramMap);
		Log.Debug();
		return resultMap;
	}

	public List<?> getHolidayList(Map<String, Object> paramMap) throws Exception {
		paramMap.replace("searchAppSYmd", DateUtil.addMonths(String.valueOf(paramMap.get("searchAppSYmd")), -1));
		paramMap.replace("searchAppEYmd", DateUtil.addMonths(String.valueOf(paramMap.get("searchAppEYmd")), 1));
		return (List<?>) dao.getList("getHolidayList",paramMap);
	}


}