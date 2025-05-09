package com.hr.sys.security.authScopeUserMgr;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 사용자별 권한범위관리 Service
 * 
 *
 */
@Service("AuthScopeUserMgrService")  
public class AuthScopeUserMgrService{
	@Inject
	@Named("Dao")
	private Dao dao;

	
	/**
	 * 사용자별 권한범위관리 사용자 저장 Service
	 * 
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveAuthScopeUserMgrUser(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;

		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteAuthScopeUserMgrUser1", convertMap);
			cnt += dao.delete("deleteAuthScopeUserMgrUser2", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveAuthScopeUserMgrUser", convertMap);
		}
		
		
		Log.Debug();
		return cnt;
	}
	
	/**
	 * 사용자별 권한범위관리 저장 Service
	 * 
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveAuthScopeUserMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;

		cnt += dao.delete("deleteAuthScopeUserMgr", convertMap);
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveAuthScopeUserMgr", convertMap);
		}
		
		
		Log.Debug();
		return cnt;
	}
}
