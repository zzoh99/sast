package com.hr.eis.empSituation.cmpDivGrpSta;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * cmpDivGrpSta Service
 *
 * @author EW
 *
 */
@Service("CmpDivGrpStaService")
public class CmpDivGrpStaService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * cmpDivGrpSta 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getCmpDivGrpStaList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getCmpDivGrpStaList", paramMap);
	}

	/**
	 * cmpDivGrpSta 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveCmpDivGrpSta(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteCmpDivGrpSta", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveCmpDivGrpSta", convertMap);
		}

		return cnt;
	}
	/**
	 * cmpDivGrpSta 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getCmpDivGrpStaMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getCmpDivGrpStaMap", paramMap);
		Log.Debug();
		return resultMap;
	}
}
