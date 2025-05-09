package com.hr.eis.empSituation.jikchakHisSta;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * jikchakHisSta Service
 *
 * @author EW
 *
 */
@Service("JikchakHisStaService")
public class JikchakHisStaService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * jikchakHisSta 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getJikchakHisStaList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getJikchakHisStaList", paramMap);
	}
	
	/**
	 * jikchakHisSta2 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getJikchakHisStaList2(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getJikchakHisStaList2", paramMap);
	}

	/**
	 * jikchakHisSta 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveJikchakHisSta(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteJikchakHisSta", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveJikchakHisSta", convertMap);
		}

		return cnt;
	}
	/**
	 * jikchakHisSta 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getJikchakHisStaMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getJikchakHisStaMap", paramMap);
		Log.Debug();
		return resultMap;
	}
}
