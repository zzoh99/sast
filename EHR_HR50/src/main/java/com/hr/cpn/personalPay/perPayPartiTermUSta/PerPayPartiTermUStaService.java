package com.hr.cpn.personalPay.perPayPartiTermUSta;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * perPayPartiTermUSta Service
 *
 * @author EW
 *
 */
@Service("PerPayPartiTermUStaService")
public class PerPayPartiTermUStaService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * perPayPartiTermUSta 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPerPayPartiTermUStaList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getPerPayPartiTermUStaList", paramMap);
	}

	/**
	 * perPayPartiTermUSta 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int savePerPayPartiTermUSta(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deletePerPayPartiTermUSta", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("savePerPayPartiTermUSta", convertMap);
		}

		return cnt;
	}
	/**
	 * perPayPartiTermUSta 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getPerPayPartiTermUStaMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getPerPayPartiTermUStaMap", paramMap);
		Log.Debug();
		return resultMap;
	}
}
