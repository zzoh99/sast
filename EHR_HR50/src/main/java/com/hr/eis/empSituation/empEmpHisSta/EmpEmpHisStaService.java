package com.hr.eis.empSituation.empEmpHisSta;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * empEmpHisSta Service
 *
 * @author EW
 *
 */
@Service("EmpEmpHisStaService")
public class EmpEmpHisStaService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * empEmpHisSta 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getEmpEmpHisStaList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getEmpEmpHisStaList", paramMap);
	}
	
	/**
	 * empEmpHisSta1 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getEmpEmpHisStaList1(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getEmpEmpHisStaList1", paramMap);
	}
	
	/**
	 * empEmpHisSta2 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getEmpEmpHisStaList2(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getEmpEmpHisStaList2", paramMap);
	}

	/**
	 * empEmpHisSta 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveEmpEmpHisSta(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteEmpEmpHisSta", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveEmpEmpHisSta", convertMap);
		}

		return cnt;
	}
	/**
	 * empEmpHisSta 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getEmpEmpHisStaMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getEmpEmpHisStaMap", paramMap);
		Log.Debug();
		return resultMap;
	}
}
