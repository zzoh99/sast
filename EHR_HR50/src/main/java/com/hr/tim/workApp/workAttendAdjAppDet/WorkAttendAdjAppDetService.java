package com.hr.tim.workApp.workAttendAdjAppDet;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * workAttendAdjAppDet Service
 *
 * @author EW
 *
 */
@Service("WorkAttendAdjAppDetService")
public class WorkAttendAdjAppDetService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * workAttendAdjAppDet 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getWorkAttendAdjAppDetList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getWorkAttendAdjAppDetList", paramMap);
	}

	/**
	 * workAttendAdjAppDet 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveWorkAttendAdjAppDet(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.update("saveWorkAttendAdjAppDet", paramMap);
	}
	/**
	 * workAttendAdjAppDet 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getWorkAttendAdjAppDetMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getWorkAttendAdjAppDet", paramMap);
		Log.Debug();
		return resultMap;
	}
	
	/**
	 * getWorkAttendAdjAppDetEndYn 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getWorkAttendAdjAppDetEndYn(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getWorkAttendAdjAppDetEndYn", paramMap);
		Log.Debug();
		return resultMap;
	}
	
	/**
	 * getWorkAttendAdjAppDetSecomTime 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getWorkAttendAdjAppDetSecomTime(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getWorkAttendAdjAppDetSecomTime", paramMap);
		Log.Debug();
		return resultMap;
	}
	
	/**
	 * getWorkAttendAdjAppDetDupCheck 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getWorkAttendAdjAppDetDupCheck(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getWorkAttendAdjAppDetDupCheck", paramMap);
		Log.Debug();
		return resultMap;
	}
	
	/**
	 * getBeginTime 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getBeginTime(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getBeginTime", paramMap);
		Log.Debug();
		return resultMap;
	}
	
}
