package com.hr.pap.config.appSelfReportItemMgr;

import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 자기신고서항목정의 Service
 * 
 * @author JCY
 *
 */
@Service("AppSelfReportItemMgrService")  
public class AppSelfReportItemMgrService{
 
	@Inject
	@Named("Dao")
	private Dao dao;
	
	/**
	 * 자기신고서항목정의 다건 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getAppSelfReportItemMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		List<?> resultList = (List<?>)dao.getList("getAppSelfReportItemMgrList", paramMap);
		Log.Debug();
		return resultList;
	}	
	
	/**
	 * 자기신고서 항목값 관리 다건 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getAppSelfReportItemMgrValuePopList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		List<?> resultList = (List<?>)dao.getList("getAppSelfReportItemMgrValuePopList", paramMap);
		Log.Debug();
		return resultList;
	}	
	
	
	
	
	/**
	 *  자기신고서항목정의 단건 조회 Service 
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getAppSelfReportItemMgrMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getAppSelfReportItemMgrMap", paramMap);
		Log.Debug();
		return resultMap;
	}
	/**
	 * 자기신고서항목정의 저장 Service
	 * 
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveAppSelfReportItemMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteAppSelfReportItemMgr", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveAppSelfReportItemMgr", convertMap);
		}
		Log.Debug();
		return cnt;
	}
	
	/**
	 * 자기신고서항목정의 저장 Service
	 * 
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveAppSelfReportItemMgrValuePop(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteAppSelfReportItemMgrValuePop", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveAppSelfReportItemMgrValuePop", convertMap);
		}
		Log.Debug();
		return cnt;
	}
	
	/**
	 * 자기신고서항목정의 저장 Service
	 * 
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveAppSelfReportItemMgrCopyPop(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		
			cnt += dao.delete("deleteAppSelfReportItemMgrCopyPop1", convertMap);
			cnt += dao.update("saveAppSelfReportItemMgrCopyPop1", convertMap);
			cnt += dao.delete("deleteAppSelfReportItemMgrCopyPop2", convertMap);
			cnt += dao.update("saveAppSelfReportItemMgrCopyPop2", convertMap);
		
		Log.Debug();
		return cnt;
	}
	
	
	
	/**
	 * 자기신고서항목정의 생성 Service
	 * 
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int insertAppSelfReportItemMgr(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		int cnt = dao.create("insertAppSelfReportItemMgr", paramMap);
		Log.Debug();
		return cnt;
	}
	/**
	 * 자기신고서항목정의 수정 Service
	 * 
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int updateAppSelfReportItemMgr(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		int cnt = dao.update("updateAppSelfReportItemMgr", paramMap);
		Log.Debug();
		return cnt;
	}
	/**
	 * 자기신고서항목정의 삭제 Service
	 * 
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int deleteAppSelfReportItemMgr(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		int cnt = dao.delete("deleteAppSelfReportItemMgr", paramMap);
		Log.Debug();
		return cnt;
	}
}