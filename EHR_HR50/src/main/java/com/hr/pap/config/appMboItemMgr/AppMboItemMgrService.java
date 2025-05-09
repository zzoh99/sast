package com.hr.pap.config.appMboItemMgr;

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
@Service("AppMboItemMgrService")  
public class AppMboItemMgrService{
 
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
	public List<?> getAppMboItemMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		List<?> resultList = (List<?>)dao.getList("getAppMboItemMgrList", paramMap);
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
	public Map<?, ?> getAppMboItemMgrMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getAppMboItemMgrMap", paramMap);
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
	public int saveAppMboItemMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteAppMboItemMgr", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveAppMboItemMgr", convertMap);
		}
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
	public int insertAppMboItemMgr(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		int cnt = dao.create("insertAppMboItemMgr", paramMap);
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
	public int updateAppMboItemMgr(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		int cnt = dao.update("updateAppMboItemMgr", paramMap);
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
	public int deleteAppMboItemMgr(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		int cnt = dao.delete("deleteAppMboItemMgr", paramMap);
		Log.Debug();
		return cnt;
	}
}