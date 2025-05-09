package com.hr.sys.pwrSrch.pwrSrchMgrApp;

import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;


@Service("PwrSrchMgrAppService") 
public class PwrSrchMgrAppService{
 
	@Inject
	@Named("Dao")
	private Dao dao;
	
	public List<?> getPwrSrchMgrAppList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>)dao.getList("getPwrSrchMgrAppList", paramMap);
	}
	
	public int savePwrSrchMgrApp(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deletePwrSrchMgr", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("savePwrSrchMgr", convertMap);
		}
		Log.Debug();
		return cnt;
	}	
}