package com.hr.org.job.jobDivReportAppDet;
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
@Service("JobDivReportAppDetService")
public class JobDivReportAppDetService{
	@Inject
	@Named("Dao")
	private Dao dao;
	
	/**
	 * 직무분장보고 저장
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveJobDivReportAppDet(Map<?, ?> paramMap, Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveJobDivReportAppDetGrid", convertMap);
		}
		
		cnt += dao.update("saveJobDivReportAppDet", paramMap);

		return cnt;
	}
	
}