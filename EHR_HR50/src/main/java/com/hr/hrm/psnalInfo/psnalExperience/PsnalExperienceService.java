package com.hr.hrm.psnalInfo.psnalExperience;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 인사기본(경력) Service
 *
 * @author 이름
 *
 */
@Service("PsnalExperienceService")
public class PsnalExperienceService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * getPsnalExperienceList 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPsnalExperienceList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getPsnalExperienceList", paramMap);
	}
	
	/**
	 * savePsnalExperience 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int savePsnalExperience(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deletePsnalExperience", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("savePsnalExperience", convertMap);
		}

		return cnt;
	}
			
}