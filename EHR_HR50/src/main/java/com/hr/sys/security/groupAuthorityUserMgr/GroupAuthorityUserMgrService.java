package com.hr.sys.security.groupAuthorityUserMgr;

import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;


@Service("GroupAuthorityUserMgrService") 
public class GroupAuthorityUserMgrService{
 
	@Inject
	@Named("Dao")
	private Dao dao;
	
	public List<?> getGroupAuthorityUserMgrList(Map<String, Object> paramMap) throws Exception {
		Log.Debug("GroupAuthorityUserMgrService.getGroupAuthorityUserMgrList Start");
		return (List<?>)dao.getList("getGroupAuthorityUserMgrList", paramMap);
	}	
	
	
	
	public int saveGroupAuthorityUserMgr(Map<String, Object> convertMap) throws Exception {
		Log.Debug("GroupAuthorityUserMgrService.saveGroupAuthorityUserMgr Start");
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			Log.Debug("GroupAuthorityUserMgrService.saveGroupAuthorityUserMgr >>> delete  Start");
			cnt += dao.delete("deleteGroupAuthorityUserMgr", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			Log.Debug("GroupAuthorityUserMgrService.saveGroupAuthorityUserMgr  >>> Merge  Start");
			cnt += dao.update("saveGroupAuthorityUserMgr", convertMap);
		}
		
		return cnt;
	}	
	
	public Map loginInfoCreate(Map<?, ?> paramMap) throws Exception {
		Log.Debug("GroupAuthorityUserMgrService.loginInfoCreate");
		return (Map) dao.excute("callP_SYS_GRP_USER_INS", paramMap);
	}
	

	
}