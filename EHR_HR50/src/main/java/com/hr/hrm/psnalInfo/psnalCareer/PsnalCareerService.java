package com.hr.hrm.psnalInfo.psnalCareer;
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
@Service("PsnalCareerService")
public class PsnalCareerService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * getPsnalCareerUserList 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPsnalCareerUserList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getPsnalCareerUserList", paramMap);
	}
	
	/**
	 * getPsnalCareerList 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPsnalCareerList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getPsnalCareerList", paramMap);
	}
	
	/**
	 * 인사기본(경력) 유저정보 수정 Service
	 *
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int updatePsnalCareerUser(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		int cnt = dao.update("updatePsnalCareerUser", paramMap);
		return cnt;
	}


	/**
	 * savePsnalCareer 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int savePsnalCareer(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deletePsnalCareer", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("savePsnalCareer", convertMap);
		}

		return cnt;
	}
	
	/**
	 * PsnalCareer 년, 월 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getPsnalCareerYYMM(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getPsnalCareerYYMM", paramMap);
		Log.Debug();
		return resultMap;
	}		
}