package com.hr.org.competency.competencySchemeMgr;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * competencySchemeMgr Service
 *
 * @author EW
 *
 */
@Service("CompetencySchemeMgrService")
public class CompetencySchemeMgrService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * competencySchemeMgr 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getCompetencySchemeMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getCompetencySchemeMgrList", paramMap);
	}

	/**
	 * competencySchemeMgr 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveCompetencySchemeMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteCompetencySchemeMgr", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveCompetencySchemeMgr", convertMap);
		}

		return cnt;
	}
	/**
	 * competencySchemeMgr 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getCompetencySchemeMgrMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getCompetencySchemeMgrMap", paramMap);
		Log.Debug();
		return resultMap;
	}
}
