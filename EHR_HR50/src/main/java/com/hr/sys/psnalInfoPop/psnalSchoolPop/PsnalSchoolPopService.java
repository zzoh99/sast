package com.hr.sys.psnalInfoPop.psnalSchoolPop;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * psnalSchoolPop Service
 *
 * @author EW
 *
 */
@Service("PsnalSchoolPopService")
public class PsnalSchoolPopService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * psnalSchoolPop 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPsnalSchoolPopList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getPsnalSchoolPopList", paramMap);
	}

	/**
	 * psnalSchoolPop 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int savePsnalSchoolPop(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deletePsnalSchoolPop", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("savePsnalSchoolPop", convertMap);
		}

		return cnt;
	}
	/**
	 * psnalSchoolPop 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getPsnalSchoolPopMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getPsnalSchoolPopMap", paramMap);
		Log.Debug();
		return resultMap;
	}
}
