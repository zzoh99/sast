package com.hr.org.job.jobDivReportMgr;
import javax.inject.Inject;
import javax.inject.Named;

import com.hr.common.logger.Log;
import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;

import java.util.List;
import java.util.Map;

/**
 * 직무분장표 Service
 *
 * @author jy
 *
 */
@Service("JobDivReportMgrService")
public class JobDivReportMgrService{
	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getJobDivReportMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getJobDivReportMgrList", paramMap);
	}
}