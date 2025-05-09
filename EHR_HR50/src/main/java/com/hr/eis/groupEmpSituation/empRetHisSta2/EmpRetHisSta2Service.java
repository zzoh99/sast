package com.hr.eis.groupEmpSituation.empRetHisSta2;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * empRetHisSta2 Service
 *
 * @author EW
 *
 */
@Service("EmpRetHisSta2Service")
public class EmpRetHisSta2Service{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * empRetHisSta2 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getEmpRetHisSta2List2(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getEmpRetHisSta2List2", paramMap);
	}
	
	/**
	 * empRetHisSta2 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getEmpRetHisSta2List3(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getEmpRetHisSta2List3", paramMap);
	}

	/**
	 * empRetHisSta2 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveEmpRetHisSta2(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteEmpRetHisSta2", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveEmpRetHisSta2", convertMap);
		}

		return cnt;
	}
	/**
	 * empRetHisSta2 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getEmpRetHisSta2Map(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getEmpRetHisSta2Map", paramMap);
		Log.Debug();
		return resultMap;
	}
}
