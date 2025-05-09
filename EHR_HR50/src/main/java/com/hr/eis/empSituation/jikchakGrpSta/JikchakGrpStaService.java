package com.hr.eis.empSituation.jikchakGrpSta;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * jikchakGrpSta Service
 *
 * @author EW
 *
 */
@Service("JikchakGrpStaService")
public class JikchakGrpStaService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * jikchakGrpSta 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getJikchakGrpStaList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getJikchakGrpStaList", paramMap);
	}
	
	/**
	 * jikchakGrpSta2 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getJikchakGrpStaList2(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getJikchakGrpStaList2", paramMap);
	}

	/**
	 * jikchakGrpSta 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveJikchakGrpSta(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteJikchakGrpSta", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveJikchakGrpSta", convertMap);
		}

		return cnt;
	}
	/**
	 * jikchakGrpSta 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getJikchakGrpStaMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getJikchakGrpStaMap", paramMap);
		Log.Debug();
		return resultMap;
	}
}
