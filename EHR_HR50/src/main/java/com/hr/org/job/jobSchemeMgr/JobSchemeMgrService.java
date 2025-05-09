package com.hr.org.job.jobSchemeMgr;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 직무분류표 Service
 * 
 * @author CBS
 *
 */
@Service("JobSchemeMgrService")  
public class JobSchemeMgrService{
	@Inject
	@Named("Dao")
	private Dao dao;
	/**
	 * 직무분류표 다건 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getJobSchemeMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getJobSchemeMgrList", paramMap);
	}
	
	/**
	 * 직무분류표 저장 Service
	 * 
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveJobSchemeMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteJobSchemeMgr", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveJobSchemeMgr", convertMap);
		}
		Log.Debug();
		return cnt;
	}
	
	/**
	 * 직무분류표 삭제 Service
	 * 
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int deleteJobSchemeMgr(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.delete("deleteJobSchemeMgr", paramMap);
	}
}