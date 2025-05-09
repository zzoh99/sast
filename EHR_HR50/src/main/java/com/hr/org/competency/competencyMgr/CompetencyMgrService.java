package com.hr.org.competency.competencyMgr;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * competencyMgr Service
 *
 * @author EW
 *
 */
@Service("CompetencyMgrService")
public class CompetencyMgrService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * competencyMgr 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getCompetencyMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getCompetencyMgrList", paramMap);
	}

	/**
	 * competencyMgr 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveCompetencyMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteCompetencyMgr", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveCompetencyMgr", convertMap);
		}

		return cnt;
	}
	/**
	 * competencyMgr 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getCompetencyMgrMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getCompetencyMgrMap", paramMap);
		Log.Debug();
		return resultMap;
	}
}
