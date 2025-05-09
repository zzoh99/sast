package com.hr.org.job.jobSchemeIBOrgSrch;

import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

@Service("JobSchemeIBOrgSrchService")
public class JobSchemeIBOrgSrchService {
	@Inject
	@Named("Dao")
	private Dao dao;
	
	public List<?> getJobSchemeIBOrgSrchList(Map<?, ?> paramMap, String searchType) throws Exception {
		Log.DebugStart();
		return (List<?>)dao.getList("getJobSchemeIBOrgSrchList"+searchType, paramMap);
	}
}
