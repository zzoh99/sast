package com.hr.hri.applyApproval.appMasterMgr;

import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

@Service("AppMasterMgrService") 
public class AppMasterMgrService{
 
	@Inject
	@Named("Dao")
	private Dao dao;
	
	public int saveAppMasterMgrDtl(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		
		cnt += dao.delete("deleteAppMasterMgrDtl", convertMap);
		
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			
			cnt += dao.update("saveAppMasterMgrDtl", convertMap);
		}
		Log.Debug();
		return cnt;
	}
	public int saveAppMasterMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		cnt += dao.update("saveAppMasterMgr", convertMap);
		
		Log.Debug();
		return cnt;
	}
}