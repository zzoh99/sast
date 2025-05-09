package com.hr.sys.psnalInfoPop.psnalCareerPop;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * psnalCareerPop Service
 *
 * @author EW
 *
 */
@Service("PsnalCareerPopService")
public class PsnalCareerPopService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * psnalCareerPop 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPsnalCareerPopList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getPsnalCareerPopList", paramMap);
	}

	/**
	 * psnalCareerPop 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int savePsnalCareerPop(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deletePsnalCareerPop", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("savePsnalCareerPop", convertMap);
		}

		return cnt;
	}
	/**
	 * psnalCareerPop 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getPsnalCareerPopMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getPsnalCareerPopMap", paramMap);
		Log.Debug();
		return resultMap;
	}
}
