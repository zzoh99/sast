package com.hr.eis.groupEmpSituation.empRetHisSta;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * empRetHisSta Service
 *
 * @author EW
 *
 */
@Service("EmpRetHisStaService")
public class EmpRetHisStaService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * empRetHisSta 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getEmpRetHisStaList2(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getEmpRetHisStaList2", paramMap);
	}

	/**
	 * empRetHisSta 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveEmpRetHisSta(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteEmpRetHisSta", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveEmpRetHisSta", convertMap);
		}

		return cnt;
	}
	/**
	 * empRetHisSta 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getEmpRetHisStaMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getEmpRetHisStaMap", paramMap);
		Log.Debug();
		return resultMap;
	}
}
