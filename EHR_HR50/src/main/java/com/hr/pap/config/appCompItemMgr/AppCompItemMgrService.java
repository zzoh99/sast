package com.hr.pap.config.appCompItemMgr;

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
@Service("AppCompItemMgrService")  
public class AppCompItemMgrService{
 
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
	public List<?> getAppCompItemMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		List<?> resultList = (List<?>)dao.getList("getAppCompItemMgrList", paramMap);
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
	public Map<?, ?> getAppCompItemMgrMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getAppCompItemMgrMap", paramMap);
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
	public int saveAppCompItemMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteAppCompItemMgr", convertMap);
			cnt += dao.delete("deleteAppCompItemMgr2", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveAppCompItemMgr", convertMap);
		}
		Log.Debug();
		return cnt;
	}
	
	public List<?> getAppCompItemMgrTblNm(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		List<?> resultList = (List<?>)dao.getList("getAppCompItemMgrTblNm", paramMap);
		Log.Debug();
		return resultList;
	}
	
	public List<?> getAppCompItemMgrScopeCd(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		List<?> resultList = (List<?>)dao.getList("getAppCompItemMgrScopeCd", paramMap);
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
	public int saveAppCompItemMgrCopyPop(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		
			cnt += dao.delete("deleteAppCompItemMgrCopyPop1", convertMap);
			cnt += dao.delete("deleteAppCompItemMgrCopyPop2", convertMap);
			cnt += dao.create("insertAppCompItemMgrCopyPop1", convertMap);
			cnt += dao.create("insertAppCompItemMgrCopyPop2", convertMap);
		
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
	public int insertAppCompItemMgr(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		int cnt = dao.create("insertAppCompItemMgr", paramMap);
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
	public int updateAppCompItemMgr(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		int cnt = dao.update("updateAppCompItemMgr", paramMap);
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
	public int deleteAppCompItemMgr(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		int cnt = dao.delete("deleteAppCompItemMgr", paramMap);
		Log.Debug();
		return cnt;
	}
}