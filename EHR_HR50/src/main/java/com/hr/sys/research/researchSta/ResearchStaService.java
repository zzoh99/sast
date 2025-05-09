package com.hr.sys.research.researchSta;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * researchSta Service
 *
 * @author EW
 *
 */
@Service("ResearchStaService")
public class ResearchStaService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * researchSta 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getResearchStaList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getResearchStaList", paramMap);
	}

	/**
	 * researchSta 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveResearchSta(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteResearchSta", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveResearchSta", convertMap);
		}

		return cnt;
	}
	/**
	 * researchSta 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getResearchStaMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getResearchStaMap", paramMap);
		Log.Debug();
		return resultMap;
	}
}
