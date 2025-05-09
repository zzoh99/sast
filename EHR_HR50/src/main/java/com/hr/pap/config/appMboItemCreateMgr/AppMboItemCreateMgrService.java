package com.hr.pap.config.appMboItemCreateMgr;

import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 업적평가표생성관리 Service
 * 
 * @author JSG
 *
 */
@Service("AppMboItemCreateMgrService")  
public class AppMboItemCreateMgrService{
 
	@Inject
	@Named("Dao")
	private Dao dao;
	
	/**
	 * 업적평가표생성관리 다건 조회 Service (아래)
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getAppMboItemCreateMgrList1(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		List<?> resultList = (List<?>)dao.getList("getAppMboItemCreateMgrList1", paramMap);
		Log.Debug();
		return resultList;
	}
	
	/**
	 * 업적평가표생성관리 다건 조회 Service (아래)
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getAppMboItemCreateMgrList2(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		List<?> resultList = (List<?>)dao.getList("getAppMboItemCreateMgrList2", paramMap);
		Log.Debug();
		return resultList;
	}
	
	/**
	 *  업적평가표생성관리 단건 조회 Service 
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getAppMboItemCreateMgrMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getAppMboItemCreateMgrMap", paramMap);
		Log.Debug();
		return resultMap;
	}

	/**
	 * 업적평가표생성관리 저장 Service (아래)
	 * 
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveAppMboItemCreateMgr1(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteAppMboItemCreateMgr1", convertMap);
		}
		Log.Debug();
		return cnt;
	}
	/**
	 * 업적평가표생성관리 저장 Service (아래)
	 * 
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveAppMboItemCreateMgr2(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteAppMboItemCreateMgr2", convertMap);
		}
		Log.Debug();
		return cnt;
	}
	/**
	 * 업적평가표생성관리 생성 Service
	 * 
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int insertAppMboItemCreateMgr(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		int cnt = dao.create("insertAppMboItemCreateMgr", paramMap);
		Log.Debug();
		return cnt;
	}
	/**
	 * 업적평가표생성관리 수정 Service
	 * 
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int updateAppMboItemCreateMgr(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		int cnt = dao.update("updateAppMboItemCreateMgr", paramMap);
		Log.Debug();
		return cnt;
	}
	/**
	 * 업적평가표생성관리 삭제 Service
	 * 
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int deleteAppMboItemCreateMgr(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		int cnt = dao.delete("deleteAppMboItemCreateMgr", paramMap);
		Log.Debug();
		return cnt;
	}
}