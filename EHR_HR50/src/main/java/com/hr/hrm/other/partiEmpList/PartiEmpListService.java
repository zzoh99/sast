package com.hr.hrm.other.partiEmpList;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * partiEmpList Service
 *
 * @author EW
 *
 */
@Service("PartiEmpListService")
public class PartiEmpListService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * partiEmpList 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPartiEmpListList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getPartiEmpListList", paramMap);
	}

	/**
	 * partiEmpList 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int savePartiEmpList(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deletePartiEmpList", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("savePartiEmpList", convertMap);
		}

		return cnt;
	}
	/**
	 * partiEmpList 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getPartiEmpListMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getPartiEmpListMap", paramMap);
		Log.Debug();
		return resultMap;
	}
}
