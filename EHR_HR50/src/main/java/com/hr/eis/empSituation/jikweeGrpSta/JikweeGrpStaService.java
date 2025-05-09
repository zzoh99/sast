package com.hr.eis.empSituation.jikweeGrpSta;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * jikweeGrpSta Service
 *
 * @author EW
 *
 */
@Service("JikweeGrpStaService")
public class JikweeGrpStaService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * jikweeGrpSta1 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getJikweeGrpStaList1(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getJikweeGrpStaList1", paramMap);
	}
	
	/**
	 * jikweeGrpSta2 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getJikweeGrpStaList2(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getJikweeGrpStaList2", paramMap);
	}

	/**
	 * jikweeGrpSta 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveJikweeGrpSta(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteJikweeGrpSta", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveJikweeGrpSta", convertMap);
		}

		return cnt;
	}
	/**
	 * jikweeGrpSta 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getJikweeGrpStaMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getJikweeGrpStaMap", paramMap);
		Log.Debug();
		return resultMap;
	}
}
