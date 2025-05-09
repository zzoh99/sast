package com.hr.eis.empSituation.careerCntGrpSta;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * careerCntGrpSta Service
 *
 * @author EW
 *
 */
@Service("CareerCntGrpStaService")
public class CareerCntGrpStaService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * careerCntGrpSta 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getCareerCntGrpStaList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getCareerCntGrpStaList", paramMap);
	}

	/**
	 * careerCntGrpSta 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveCareerCntGrpSta(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteCareerCntGrpSta", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveCareerCntGrpSta", convertMap);
		}

		return cnt;
	}
	/**
	 * careerCntGrpSta 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getCareerCntGrpStaMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getCareerCntGrpStaMap", paramMap);
		Log.Debug();
		return resultMap;
	}
}
