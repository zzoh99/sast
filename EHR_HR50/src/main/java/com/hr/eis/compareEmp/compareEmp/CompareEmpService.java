package com.hr.eis.compareEmp.compareEmp;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * compareEmp Service
 *
 * @author EW
 *
 */
@Service("CompareEmpService")
public class CompareEmpService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * compareEmp 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getCompareEmpList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getCompareEmpList", paramMap);
	}

	/**
	 * compareEmp 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveCompareEmp(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteCompareEmp", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveCompareEmp", convertMap);
		}

		return cnt;
	}
	/**
	 * compareEmp 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getCompareEmpPeopleMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getCompareEmpPeopleMap", paramMap);
		Log.Debug();
		return resultMap;
	}
	
	/**
	 * compareEmp 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getCompareEmpJobList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getCompareEmpJobList", paramMap);
	}
	
	/**
	 * compareEmp 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getCompareEmpCareerList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getCompareEmpCareerList", paramMap);
	}
	
	/**
	 * compareEmp 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPapList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getPapList", paramMap);
	}
	
	/**
	 * compareEmp 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 *//*
	public Map<?, ?> getCompareEmpJobList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getCompareEmpJobList", paramMap);
		Log.Debug();
		return resultMap;
	}
	*//**
	 * compareEmp 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 *//*
	public Map<?, ?> getCompareEmpCareerList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getCompareEmpCareerList", paramMap);
		Log.Debug();
		return resultMap;
	}*/
	
	/**
	 * Appraisal 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getAppraisalList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getAppraisalList", paramMap);
	}
	
	/**
	 * Appraisal 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getExperienceList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getExperienceList", paramMap);
	}
}
