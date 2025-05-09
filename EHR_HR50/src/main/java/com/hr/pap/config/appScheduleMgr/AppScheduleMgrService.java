package com.hr.pap.config.appScheduleMgr;

import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 평가일정관리 Service
 * 
 * @author jcy
 *
 */
@Service("AppScheduleMgrService")  
public class AppScheduleMgrService{
 
	@Inject
	@Named("Dao")
	private Dao dao;
	
	/**
	 * 평가일정관리 다건 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getAppScheduleMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		List<?> resultList = (List<?>)dao.getList("getAppScheduleMgrList", paramMap);
		Log.Debug();
		return resultList;
	}	
	
	/**
	 * 평가일정관리 다건 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getAppScheduleMgrPopList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		List<?> resultList = (List<?>)dao.getList("getAppScheduleMgrPopList", paramMap);
		Log.Debug();
		return resultList;
	}
	
	
	
	public List<?> getAppScheduleCodeList (Map<?,?> paramMap) throws Exception {
		Log.Debug();
		List<?> codeList = (List<?>)dao.getList("getAppScheduleCodeList", paramMap);
		Log.Debug();
		return codeList;
	}
	
	/**
	 *  평가일정관리 단건 조회 Service 
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getAppScheduleMgrMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getAppScheduleMgrMap", paramMap);
		Log.Debug();
		return resultMap;
	}
	/**
	 * 평가일정관리 저장 Service
	 * 
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveAppScheduleMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteAppScheduleMgr", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveAppScheduleMgr", convertMap);
		}
		Log.Debug();
		return cnt;
	}
	
	/**
	 * 평가일정관리 -평가차수일정관리- 저장 Service
	 * 
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveAppScheduleMgrPop(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteAppScheduleMgrPop", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveAppScheduleMgrPop", convertMap);
		}
		Log.Debug();
		return cnt;
	}
	
	
	
	/**
	 * 평가일정관리 생성 Service
	 * 
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int insertAppScheduleMgr(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		int cnt = dao.create("insertAppScheduleMgr", paramMap);
		Log.Debug();
		return cnt;
	}
	/**
	 * 평가일정관리 수정 Service
	 * 
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int updateAppScheduleMgr(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		int cnt = dao.update("updateAppScheduleMgr", paramMap);
		Log.Debug();
		return cnt;
	}
	/**
	 * 평가일정관리 삭제 Service
	 * 
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int deleteAppScheduleMgr(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		int cnt = dao.delete("deleteAppScheduleMgr", paramMap);
		Log.Debug();
		return cnt;
	}
}