package com.hr.eis.empSituation.sexAgeGrpSta;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * sexAgeGrpSta Service
 *
 * @author EW
 *
 */
@Service("SexAgeGrpStaService")
public class SexAgeGrpStaService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * sexAgeGrpSta 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getSexAgeGrpStaList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getSexAgeGrpStaList", paramMap);
	}
	
	/**
	 * ageGrpStaList 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getAgeGrpStaList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getAgeGrpStaList", paramMap);
	}
	
	/**
	 * sexAgeGrpStaAvgAge 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getSexAgeGrpStaAvgAge(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getSexAgeGrpStaAvgAge", paramMap);
	}
	
	/**
	 * sexGrpStaList 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getSexGrpStaList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getSexGrpStaList", paramMap);
	}

	/**
	 * sexAgeGrpSta 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveSexAgeGrpSta(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteSexAgeGrpSta", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveSexAgeGrpSta", convertMap);
		}

		return cnt;
	}
	/**
	 * sexAgeGrpSta 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getSexAgeGrpStaMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getSexAgeGrpStaMap", paramMap);
		Log.Debug();
		return resultMap;
	}
}
