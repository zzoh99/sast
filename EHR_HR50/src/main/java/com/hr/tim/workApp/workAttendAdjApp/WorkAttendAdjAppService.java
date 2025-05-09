package com.hr.tim.workApp.workAttendAdjApp;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * workAttendAdjApp Service
 *
 * @author EW
 *
 */
@Service("WorkAttendAdjAppService")
public class WorkAttendAdjAppService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * workAttendAdjApp 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getWorkAttendAdjAppList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getWorkAttendAdjAppList", paramMap);
	}

	/**
	 * workAttendAdjApp 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveWorkAttendAdjApp(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteWorkAttendAdjApp", convertMap);
			dao.delete("deleteWorkAttendAdjAppEx103", convertMap);
			dao.delete("deleteWorkAttendAdjAppEx107", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveWorkAttendAdjApp", convertMap);
		}

		return cnt;
	}
	/**
	 * workAttendAdjApp 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getWorkAttendAdjAppMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getWorkAttendAdjAppMap", paramMap);
		Log.Debug();
		return resultMap;
	}
}
