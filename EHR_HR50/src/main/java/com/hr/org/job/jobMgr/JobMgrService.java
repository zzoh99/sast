package com.hr.org.job.jobMgr;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import javax.inject.Named;
import java.util.List;
import java.util.Map;
/**
 * 직무기술서 Service
 *
 * @author CBS
 *
 */
@Service("JobMgrService")
public class JobMgrService{
	@Inject
	@Named("Dao")
	private Dao dao;
	/**
	 * 직무기술서 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getJobMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getJobMgrList", paramMap);
	}

	/**
	 * 직무기술서 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveJobMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteJobMgr", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveJobMgr", convertMap);
		}
		Log.Debug();
		return cnt;
	}

	/**
	 * 직무기술서 삭제 Service
	 *
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int deleteJobMgr(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.delete("deleteJobMgr", paramMap);
	}

	/**
	 * 수행조직 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getJobMgrOrgList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getJobMgrOrgList", paramMap);
	}

	/**
	 * 수행조직 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveJobMgrOrg(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteJobMgrOrg", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveJobMgrOrg", convertMap);
		}
		Log.Debug();
		return cnt;
	}

	/**
	 * 수행조직 삭제 Service
	 *
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int deleteJobMgrOrg(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.delete("deleteJobMgrOrg", paramMap);
	}

	/**
	 * 핵심과업 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getJobMgrTaskList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getJobMgrTaskList", paramMap);
	}

	/**
	 * 핵심과업 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveJobMgrTask(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteJobMgrTask", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveJobMgrTask", convertMap);
		}
		Log.Debug();
		return cnt;
	}

	/**
	 * 핵심과업 삭제 Service
	 *
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int deleteJobMgrTask(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.delete("deleteJobMgrTask", paramMap);
	}

	/**
	 * 자격면허 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getJobMgrLicenseList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getJobMgrLicenseList", paramMap);
	}

	/**
	 * 자격면허 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveJobMgrLicense(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteJobMgrLicense", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveJobMgrLicense", convertMap);
		}
		Log.Debug();
		return cnt;
	}

	/**
	 * 자격면허 삭제 Service
	 *
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int deleteJobMgrLicense(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.delete("deleteJobMgrLicense", paramMap);
	}

	/**
	 * 역량요건 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getJobMgrCompetencyList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getJobMgrCompetencyList", paramMap);
	}

	/**
	 * 역량요건 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveJobMgrCompetency(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteJobMgrCompetency", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveJobMgrCompetency", convertMap);
		}
		Log.Debug();
		return cnt;
	}

	/**
	 * 역량요건 삭제 Service
	 *
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int deleteJobMgrCompetency(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.delete("deleteJobMgrCompetency", paramMap);
	}

	/**
	 * 연관업무_선행직무 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getJobMgrPriorJobList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getJobMgrPriorJobList", paramMap);
	}

	/**
	 * 연관업무_선행직무 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveJobMgrPriorJob(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteJobMgrPriorJob", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveJobMgrPriorJob", convertMap);
		}
		Log.Debug();
		return cnt;
	}

	/**
	 * 연관업무_선행직무 삭제 Service
	 *
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int deleteJobMgrPriorJob(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.delete("deleteJobMgrPriorJob", paramMap);
	}

	/**
	 * 연관업무_후행직무 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getJobMgrAfterJobList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getJobMgrAfterJobList", paramMap);
	}

	/**
	 * 연관업무_후행직무 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveJobMgrAfterJob(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteJobMgrAfterJob", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveJobMgrAfterJob", convertMap);
		}
		Log.Debug();
		return cnt;
	}

	/**
	 * 연관업무_후행직무 삭제 Service
	 *
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int deleteJobMgrAfterJob(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.delete("deleteJobMgrAfterJob", paramMap);
	}

	/**
	 * 이동가능직무_직군내 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getJobMgrMoveJikgunJobList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getJobMgrMoveJikgunJobList", paramMap);
	}

	/**
	 * 이동가능직무_직군내 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveJobMgrMoveJikgunJob(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteJobMgrMoveJikgunJob", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveJobMgrMoveJikgunJob", convertMap);
		}
		Log.Debug();
		return cnt;
	}

	/**
	 * 이동가능직무_직군내 삭제 Service
	 *
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int deleteJobMgrMoveJikgunJob(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.delete("deleteJobMgrMoveJikgunJob", paramMap);
	}

	/**
	 * 이동가능직무_직렬내 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getJobMgrMoveJikryulJobList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getJobMgrMoveJikryulJobList", paramMap);
	}

	/**
	 * 이동가능직무_직렬내 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveJobMgrMoveJikryulJob(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteJobMgrMoveJikryulJob", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveJobMgrMoveJikryulJob", convertMap);
		}
		Log.Debug();
		return cnt;
	}

	/**
	 * 이동가능직무_직렬내 삭제 Service
	 *
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int deleteJobMgrMoveJikryulJob(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.delete("deleteJobMgrMoveJikryulJob", paramMap);
	}

	public List<?> getJobMgrLgLicenseList(Map<String, Object> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getJobMgrLgLicenseList", paramMap);
	}

	public List<?> getJobMgrSkillCompetencyList(Map<String, Object> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getJobMgrSkillCompetencyList", paramMap);
	}

	public List<?> getJobMgrEducationList(Map<String, Object> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getJobMgrEducationList", paramMap);
	}

	public List<?> getKpiList(Map<String, Object> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getKpiList", paramMap);
	}

	public int saveJobMgrLgLicense(Map<String, Object> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteJobMgrLgLicense", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveJobMgrLgLicense", convertMap);
		}
		return cnt;
	}

	public int saveJobMgrSkillCompetency(Map<String, Object> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteJobMgrSkillCompetency", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveJobMgrSkillCompetency", convertMap);
		}
		return cnt;
	}

	public int saveJobMgrEducationList(Map<String, Object> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteJobMgrEducationList", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveJobMgrEducationList", convertMap);
		}
		return cnt;
	}

	public int saveKpiList(Map<String, Object> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteKpiList", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveKpiList", convertMap);
		}
		return cnt;
	}
}