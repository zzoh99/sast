package com.hr.sys.pwrSrch.pwrSrchCdElemtMgr;

import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

@Service("PwrSrchCdElemtMgrService") 
public class PwrSrchCdElemtMgrService{
 
	@Inject
	@Named("Dao")
	private Dao dao;
	
	public List<?> getPwrSrchCdElemtMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>)dao.getList("getPwrSrchCdElemtMgrList", paramMap);
	}
	
	public int savePwrSrchCdElemtMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deletePwrSrchCdElemtMgr", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("savePwrSrchCdElemtMgr", convertMap);
		}
		Log.Debug();
		return cnt;
	}	
	
	public Map<?,?> getPwrSrchCdElemtMgrDetail(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (Map<?,?>)dao.getMap("getPwrSrchCdElemtMgrDetail", paramMap);
	}
}