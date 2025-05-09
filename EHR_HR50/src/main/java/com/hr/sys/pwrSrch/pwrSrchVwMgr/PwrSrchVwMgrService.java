package com.hr.sys.pwrSrch.pwrSrchVwMgr;

import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

@Service("PwrSrchVwMgrService") 
public class PwrSrchVwMgrService{
 
	@Inject
	@Named("Dao")
	private Dao dao;
	
	public List<?> getPwrSrchVwMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>)dao.getList("getPwrSrchVwMgrList", paramMap);
	}	
	
	public int savePwrSrchVwMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteSysPwrSch", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt = dao.update("saveSysPwrSch", convertMap);
		}
		Log.Debug();
		return cnt;
	}	
}