package com.hr.hrm.psnalInfo.psnalSchool;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * psnalSchool Service
 *
 * @author EW
 *
 */
@Service("PsnalSchoolService")
public class PsnalSchoolService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * psnalSchool 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPsnalSchoolList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getPsnalSchoolList", paramMap);
	}

	/**
	 * psnalSchool 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int savePsnalSchool(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deletePsnalSchool", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("savePsnalSchool", convertMap);
		}

		return cnt;
	}
	/**
	 * psnalSchool 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getPsnalSchoolMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getPsnalSchoolMap", paramMap);
		Log.Debug();
		return resultMap;
	}
}
