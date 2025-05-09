package com.hr.tim.request.vacationApp;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 근태신청 Service
 *
 * @author JSG
 *
 */
@Service("VacationAppService")
public class VacationAppService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * vacationApp 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getVacationAppList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getVacationAppList", paramMap);
	}
	
	/**
	 * vacationApp 다건 조회 2 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getVacationAppExList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getVacationAppExList", paramMap);
	}
	
	/**
	 * vacationApp 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getVacationAppListToday(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getVacationAppListToday", paramMap);
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
	public int saveVacationAppEx(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			dao.delete("deleteApprovalMgrMaster", convertMap);   // ApprovalMgr-mapping-query.xml 쿼리
			cnt += dao.delete("deleteVacationAppEx", convertMap);
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
	public int deleteVacationApp(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		
		int cnt=0;
		
		if(convertMap.get("deleteRows") != null) {
			if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
				cnt += dao.delete("deleteVacationApp", 	  convertMap);  	//delete TTIM301
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
	public int deleteVacationAppUpd(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		
		int cnt=0;
		
		if(convertMap.get("deleteRows") != null) {
			if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
				cnt += dao.delete("deleteVacationAppUpd", convertMap);  //delete TTIM383
				cnt += dao.delete("deleteApprovalMgrMaster2",  convertMap);  //delete THRI103
				cnt += dao.delete("deleteApprovalMgrAppLine2",  convertMap);  //delete THRI107
			}
		}
		Log.Debug();
		return cnt;
	}



}