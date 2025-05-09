package com.hr.sys.log.acessLogSht;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * acessLogSht Service
 *
 * @author EW
 *
 */
@Service("AcessLogShtService")
public class AcessLogShtService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * acessLogSht 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getAcessLogShtList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getAcessLogShtList", paramMap);
	}

	/**
	 * acessLogSht 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveAcessLogSht(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteAcessLogSht", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveAcessLogSht", convertMap);
		}

		return cnt;
	}
	/**
	 * acessLogSht 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getAcessLogShtMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getAcessLogShtMap", paramMap);
		Log.Debug();
		return resultMap;
	}
}
