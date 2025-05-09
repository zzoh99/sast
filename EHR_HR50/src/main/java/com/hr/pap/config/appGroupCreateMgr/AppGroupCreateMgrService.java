package com.hr.pap.config.appGroupCreateMgr;

import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 업적평가항목정의 Service
 * 
 * @author JSG
 *
 */
@Service("AppGroupCreateMgrService")  
public class AppGroupCreateMgrService{
 
	@Inject
	@Named("Dao")
	private Dao dao;
	
	/**
	 * 업적평가항목정의 다건 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getAppGroupCreateMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		List<?> resultList = (List<?>)dao.getList("getAppGroupCreateMgrList", paramMap);
		Log.Debug();
		return resultList;
	}	
	
	/**
	 *  업적평가항목정의 단건 조회 Service 
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getAppGroupCreateMgrMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getAppGroupCreateMgrMap", paramMap);
		Log.Debug();
		return resultMap;
	}
	/**
	 * 업적평가항목정의 저장 Service
	 * 
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveAppGroupCreateMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteAppGroupCreateMgr", convertMap);
			cnt += dao.delete("deleteAppGroupCreateMgr2", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveAppGroupCreateMgr", convertMap);
		}
		Log.Debug();
		return cnt;
	}
	
	public List<?> getAppGroupCreateMgrTblNm(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		List<?> resultList = (List<?>)dao.getList("getAppGroupCreateMgrTblNm", paramMap);
		Log.Debug();
		return resultList;
	}
	
	public List<?> getAppGroupCreateMgrScopeCd(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		List<?> resultList = (List<?>)dao.getList("getAppGroupCreateMgrScopeCd", paramMap);
		Log.Debug();
		return resultList;
	}
	
	/**
	 * 업적평가항목정의 저장 Service
	 * 
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveAppGroupCreateMgrCopyPop(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		
			cnt += dao.delete("deleteAppGroupCreateMgrCopyPop1", convertMap);
			cnt += dao.delete("deleteAppGroupCreateMgrCopyPop2", convertMap);
			cnt += dao.create("insertAppGroupCreateMgrCopyPop1", convertMap);
			cnt += dao.create("insertAppGroupCreateMgrCopyPop2", convertMap);
		
		Log.Debug();
		return cnt;
	}
	
	
	
	/**
	 * 업적평가항목정의 생성 Service
	 * 
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int insertAppGroupCreateMgr(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		int cnt = dao.create("insertAppGroupCreateMgr", paramMap);
		Log.Debug();
		return cnt;
	}
	/**
	 * 업적평가항목정의 수정 Service
	 * 
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int updateAppGroupCreateMgr(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		int cnt = dao.update("updateAppGroupCreateMgr", paramMap);
		Log.Debug();
		return cnt;
	}
	/**
	 * 업적평가항목정의 삭제 Service
	 * 
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int deleteAppGroupCreateMgr(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		int cnt = dao.delete("deleteAppGroupCreateMgr", paramMap);
		Log.Debug();
		return cnt;
	}
}