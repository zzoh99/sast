package com.hr.eis.empSituation.jikjongHisSta;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * jikjongHisSta Service
 *
 * @author EW
 *
 */
@Service("JikjongHisStaService")
public class JikjongHisStaService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * jikjongHisSta 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getJikjongHisStaList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getJikjongHisStaList", paramMap);
	}
	
	/**
	 * jikjongHisSta2 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getJikjongHisStaList2(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getJikjongHisStaList2", paramMap);
	}

	/**
	 * jikjongHisSta 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveJikjongHisSta(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteJikjongHisSta", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveJikjongHisSta", convertMap);
		}

		return cnt;
	}
	/**
	 * jikjongHisSta 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getJikjongHisStaMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getJikjongHisStaMap", paramMap);
		Log.Debug();
		return resultMap;
	}
}
