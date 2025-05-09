package com.hr.tim.workApp.workAttendAdjApr;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * workAttendAdjApr Service
 *
 * @author EW
 *
 */
@Service("WorkAttendAdjAprService")
public class WorkAttendAdjAprService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * workAttendAdjApr 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getWorkAttendAdjAprList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getWorkAttendAdjAprList", paramMap);
	}

	/**
	 * workAttendAdjApr 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveWorkAttendAdjApr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteWorkAttendAdjApr", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveWorkAttendAdjApr", convertMap);
		}

		return cnt;
	}
	/**
	 * workAttendAdjApr 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getWorkAttendAdjAprMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getWorkAttendAdjAprMap", paramMap);
		Log.Debug();
		return resultMap;
	}
}
