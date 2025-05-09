package com.hr.org.job.jobDivReportApp;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 직무분장보고 Service
 *
 * @author jy
 *
 */
@Service("JobDivReportAppService")
public class JobDivReportAppService{
	@Inject
	@Named("Dao")
	private Dao dao;
	
	/**
	 * 직무분장보고 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int deleteJobDivReportApp(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteJobDivReportApp", convertMap);
			cnt += dao.delete("deleteJobDivReportAppGrid", convertMap);
			dao.delete("deleteApprovalMgrMaster", convertMap);
			dao.delete("deleteApprovalMgrAppLine", convertMap);
		}

		return cnt;
	}
	
}