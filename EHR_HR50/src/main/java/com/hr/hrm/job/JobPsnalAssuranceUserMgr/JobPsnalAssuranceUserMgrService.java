package com.hr.hrm.job.JobPsnalAssuranceUserMgr;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * JobPsnalAssuranceUserMgr Service
 *
 * @author EW
 *
 */
@Service("JobPsnalAssuranceUserMgrService")
public class JobPsnalAssuranceUserMgrService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * JobPsnalAssuranceUserMgr 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getJobPsnalAssuranceUserMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getJobPsnalAssuranceUserMgrList", paramMap);
	}

	/**
	 * JobPsnalAssuranceUserMgr 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveJobPsnalAssuranceUserMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteJobPsnalAssuranceUserMgr", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveJobPsnalAssuranceUserMgr", convertMap);
		}

		return cnt;
	}
	/**
	 * JobPsnalAssuranceUserMgr 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getJobPsnalAssuranceUserMgrMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getJobPsnalAssuranceUserMgrMap", paramMap);
		Log.Debug();
		return resultMap;
	}
}
