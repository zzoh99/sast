package com.hr.hrd.core2.coreState;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import javax.inject.Named;
import java.util.List;
import java.util.Map;

@Service("CoreStateService")
public class CoreStateService {

	@Inject
	@Named("Dao")
	private Dao dao;
	
	public Map<?,?> getCoreStateCnt(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (Map<?,?>)dao.getMap("getCoreStateCnt", paramMap);
	}
	
	public List<?> getCoreStateOrgList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>)dao.getList("getCoreStateOrgList", paramMap);
	}
	
	public List<?> getCoreStatsOrgMemberList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>)dao.getList("getCoreStatsOrgMemberList", paramMap);
	}

}