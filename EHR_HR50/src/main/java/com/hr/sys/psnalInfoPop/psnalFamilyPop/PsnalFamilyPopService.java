package com.hr.sys.psnalInfoPop.psnalFamilyPop;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * psnalFamilyPop Service
 *
 * @author EW
 *
 */
@Service("PsnalFamilyPopService")
public class PsnalFamilyPopService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * psnalFamilyPop 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPsnalFamilyPopList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getPsnalFamilyPopList", paramMap);
	}

	/**
	 * psnalFamilyPop 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int savePsnalFamilyPop(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deletePsnalFamilyPop", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("savePsnalFamilyPop", convertMap);
		}

		return cnt;
	}
	/**
	 * psnalFamilyPop 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getPsnalFamilyPopMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getPsnalFamilyPopMap", paramMap);
		Log.Debug();
		return resultMap;
	}
}
