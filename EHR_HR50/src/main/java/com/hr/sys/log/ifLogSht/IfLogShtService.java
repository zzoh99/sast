package com.hr.sys.log.ifLogSht;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * ifLogSht Service
 *
 * @author EW
 *
 */
@Service("IfLogShtService")
public class IfLogShtService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * ifLogSht 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getIfLogShtList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getIfLogShtList", paramMap);
	}

	/**
	 * ifLogSht 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveIfLogSht(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteIfLogSht", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveIfLogSht", convertMap);
		}

		return cnt;
	}
	/**
	 * ifLogSht 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getIfLogShtMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getIfLogShtMap", paramMap);
		Log.Debug();
		return resultMap;
	}
}
