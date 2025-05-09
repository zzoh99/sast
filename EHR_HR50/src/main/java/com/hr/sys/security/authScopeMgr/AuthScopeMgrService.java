package com.hr.sys.security.authScopeMgr;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 권한범위항목관리 Service
 * 
 * @author CBS
 *
 */
@Service("AuthScopeMgrService")  
public class AuthScopeMgrService{
	@Inject
	@Named("Dao")
	private Dao dao;
	/**
	 * 권한범위항목관리 다건 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getAuthScopeMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getAuthScopeMgrList", paramMap);
	}

	/**
	 * 권한범위항목관리 저장 Service
	 * 
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveAuthScopeMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteAuthScopeMgr", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveAuthScopeMgr", convertMap);
		}
		Log.Debug();
		return cnt;
	}

	/**
	 * 권한범위항목관리 삭제 Service
	 * 
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int deleteAuthScopeMgr(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.delete("deleteAuthScopeMgr", paramMap);
	}
}