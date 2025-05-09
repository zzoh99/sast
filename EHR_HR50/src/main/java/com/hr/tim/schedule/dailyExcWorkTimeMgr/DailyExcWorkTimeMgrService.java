package com.hr.tim.schedule.dailyExcWorkTimeMgr;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * dailyExcWorkTimeMgr Service
 *
 * @author EW
 *
 */
@Service("DailyExcWorkTimeMgrService")
public class DailyExcWorkTimeMgrService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * dailyExcWorkTimeMgr 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getDailyExcWorkTimeMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getDailyExcWorkTimeMgrList", paramMap);
	}

	/**
	 * dailyExcWorkTimeMgr 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveDailyExcWorkTimeMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteDailyExcWorkTimeMgr", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveDailyExcWorkTimeMgr", convertMap);
		}

		return cnt;
	}
	/**
	 * dailyExcWorkTimeMgr 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getDailyExcWorkTimeMgrMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getDailyExcWorkTimeMgrMap", paramMap);
		Log.Debug();
		return resultMap;
	}
}
