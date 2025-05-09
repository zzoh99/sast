package com.hr.sys.pwrSrch.pwrSrchUser;

import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

@Service("PwrSrchUserService") 
public class PwrSrchUserService{
 
	@Inject
	@Named("Dao")
	private Dao dao;
	
	public Map getPwrSrchUserDetailDescMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getPwrSrchUserDetailDescMap", paramMap);
	}
	public List<?> getPwrSrchUserSht1List(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>)dao.getList("getPwrSrchUserSht1List", paramMap);
	}
	public List<?> getPwrSrchUserSht2List(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>)dao.getList("getPwrSrchUserSht2List", paramMap);
	}
	
	public int savePwrSrchUser(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;

		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("savePwrSrchUser215", convertMap);
		}
		cnt += dao.update("savePwrSrchUser211", convertMap);
		Log.Debug();
		return cnt;
	}	
	
	public Map<?,?> getPwrSrchUserDetail(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (Map<?,?>)dao.getMap("getPwrSrchUserDetail", paramMap);
	}
}