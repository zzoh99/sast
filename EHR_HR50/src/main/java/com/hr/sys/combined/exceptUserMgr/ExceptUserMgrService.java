package com.hr.sys.combined.exceptUserMgr;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 예외사용자관리 Service
 * 
 * @author JSG
 *
 */
@Service("ExceptUserMgrService")  
public class ExceptUserMgrService{
	@Inject
	@Named("Dao")
	private Dao dao;
	/**
	 * 예외사용자관리 다건 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getExceptUserMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getExceptUserMgrList", paramMap);
	}
	
	/**
	 * 예외사용자관리 저장 Service
	 * 
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveExceptUserMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteExceptUserMgr", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveExceptUserMgr", convertMap);
		}
		Log.Debug();
		return cnt;
	}
	
	/**
	 * 예외사용자관리 삭제 Service
	 * 
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int deleteExceptUserMgr(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.delete("deleteExceptUserMgr", paramMap);
	}
}