package com.hr.hrm.psnalInfo.psnalFamily;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * psnalFamily Service
 *
 * @author EW
 *
 */
@Service("PsnalFamilyService")
public class PsnalFamilyService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * psnalFamily 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPsnalFamilyList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getPsnalFamilyList", paramMap);
	}

	/**
	 * psnalFamily 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int savePsnalFamily(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deletePsnalFamily", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("savePsnalFamily", convertMap);
		}

		return cnt;
	}
	/**
	 * psnalFamily 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getPsnalFamilyMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getPsnalFamilyMap", paramMap);
		Log.Debug();
		return resultMap;
	}
}
