package com.hr.eis.hrm.welfareBohunEmpSta;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * welfareBohunEmpSta Service
 *
 * @author EW
 *
 */
@Service("WelfareBohunEmpStaService")
public class WelfareBohunEmpStaService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * welfareBohunEmpSta 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getWelfareBohunEmpStaList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getWelfareBohunEmpStaList", paramMap);
	}

	/**
	 * welfareBohunEmpSta 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveWelfareBohunEmpSta(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteWelfareBohunEmpSta", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveWelfareBohunEmpSta", convertMap);
		}

		return cnt;
	}
	/**
	 * welfareBohunEmpSta 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getWelfareBohunEmpStaMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getWelfareBohunEmpStaMap", paramMap);
		Log.Debug();
		return resultMap;
	}
}
