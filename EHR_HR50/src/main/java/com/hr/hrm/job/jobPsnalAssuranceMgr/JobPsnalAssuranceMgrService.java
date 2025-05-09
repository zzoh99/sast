package com.hr.hrm.job.jobPsnalAssuranceMgr;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * jobPsnalAssuranceMgr Service
 *
 * @author EW
 *
 */
@Service("JobPsnalAssuranceMgrService")
public class JobPsnalAssuranceMgrService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * jobPsnalAssuranceMgr 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getJobPsnalAssuranceMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getJobPsnalAssuranceMgrList", paramMap);
	}

	/**
	 * jobPsnalAssuranceMgr 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveJobPsnalAssuranceMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteJobPsnalAssuranceMgr", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveJobPsnalAssuranceMgr", convertMap);
		}

		return cnt;
	}
	/**
	 * jobPsnalAssuranceMgr 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getJobPsnalAssuranceMgrMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getJobPsnalAssuranceMgrMap", paramMap);
		Log.Debug();
		return resultMap;
	}
}
