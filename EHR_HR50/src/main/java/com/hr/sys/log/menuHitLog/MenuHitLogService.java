package com.hr.sys.log.menuHitLog;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * menuHitLog Service
 *
 * @author EW
 *
 */
@Service("MenuHitLogService")
public class MenuHitLogService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * menuHitLog 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getMenuHitLogList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getMenuHitLogList", paramMap);
	}

	/**
	 * menuHitLog 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveMenuHitLog(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteMenuHitLog", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveMenuHitLog", convertMap);
		}

		return cnt;
	}
	/**
	 * menuHitLog 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getMenuHitLogMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getMenuHitLogMap", paramMap);
		Log.Debug();
		return resultMap;
	}
}
