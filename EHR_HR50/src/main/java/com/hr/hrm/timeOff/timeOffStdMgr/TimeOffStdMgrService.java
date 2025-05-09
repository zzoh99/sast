package com.hr.hrm.timeOff.timeOffStdMgr;

import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

@Service("TimeOffStdMgrService") 
public class TimeOffStdMgrService{
 
	@Inject
	@Named("Dao")
	private Dao dao;
	
	/**
	 * 휴복직기준관리 조회 Serivce
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getTimeOffStdMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>)dao.getList("getTimeOffStdMgrList", paramMap);
	}
	/**
	 * 휴복직기준관리  typeCd 조회 Serivce
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getTimeOffStdMgrTypeCodeList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>)dao.getList("getTimeOffStdMgrTypeCodeList", paramMap);
	}
	/**
	 * 휴복직기준관리  조회조건 APPL_CD 조회 Serivce
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getTimeOffStdMgrApplCodeList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>)dao.getList("getTimeOffStdMgrApplCodeList", paramMap);
	}
	/**
	 * 휴복직기준관리 세부내역 직급 직책 직위 해당 리스트 조회 Serivce
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getTimeOffStdMgrNoticeLvlList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>)dao.getList("getTimeOffStdMgrNoticeLvlList", paramMap);
	}
	public int saveTimeOffStdMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteTimeOffStdMgr", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveTimeOffStdMgr", convertMap);
		}
		Log.Debug();
		return cnt;
	}
	
	/**
	 *  휴복직기준 관리 신청기준 정보 단건조회 Service 
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getTimeOffTypeTermMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getTimeOffTypeTermMap", paramMap);
	}
	
	/**
	 *  휴복직기준 관리 신청기간 가능 여부체크 단건조회 Service 
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getTimeOffLimitTermCkMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getTimeOffLimitTermCkMap", paramMap);
	}
	
	
	
}