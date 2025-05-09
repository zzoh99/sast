package com.hr.eis.empSituation.jikgubHisSta;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * jikgubHisSta Service
 *
 * @author EW
 *
 */
@Service("JikgubHisStaService")
public class JikgubHisStaService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * jikgubHisSta 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getJikgubHisStaList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getJikgubHisStaList", paramMap);
	}

	/**
	 * jikgubHisSta 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveJikgubHisSta(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteJikgubHisSta", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveJikgubHisSta", convertMap);
		}

		return cnt;
	}
	/**
	 * jikgubHisSta 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getJikgubHisStaMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getJikgubHisStaMap", paramMap);
		Log.Debug();
		return resultMap;
	}
}
