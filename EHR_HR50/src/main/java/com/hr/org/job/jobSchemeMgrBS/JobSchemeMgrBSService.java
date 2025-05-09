package com.hr.org.job.jobSchemeMgrBS;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * JobSchemeMgrBS Service
 *
 * @author EW
 *
 */
@Service("JobSchemeMgrBSService")
public class JobSchemeMgrBSService{

	@Inject
	@Named("Dao")
	private Dao dao;
	
	/**
	 * 직무분류표 저장
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveJobSchemeMgrBS(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteJobSchemeMgrBS", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveJobSchemeMgrBS", convertMap);
		}

		return cnt;
	}
}
