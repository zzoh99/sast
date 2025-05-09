package com.hr.tim.request.vacationAppDet;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 학자금신청 세부내역 Service
 *
 * @author bckim
 *
 */
@Service("VacationAppDetService")
public class VacationAppDetService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 근태신청 세부내역 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveVacationAppDet(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.update("saveVacationAppDet", paramMap);
	}
	
	/**
	 * getVacationAppDetPlanPopupList 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getVacationAppDetPlanPopupList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getVacationAppDetPlanPopupList", paramMap);
	}
	
	/**
	 * vacationAppDet 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getVacationAppDetStdGntList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getVacationAppDetStdGntList", paramMap);
	}
	
	/**
	 * vacationAppDet 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getVacationAppDetHolidayCnt(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getVacationAppDetHolidayCnt", paramMap);
		Log.Debug();
		return resultMap;
	}
	
	/**
	 * vacationAppDet 단건 조회 2 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getVacationAppDetApplDayCnt(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getVacationAppDetApplDayCnt", paramMap);
		Log.Debug();
		return resultMap;
	}
	
	/**
	 * vacationAppDet 단건 조회 3 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getVacationAppDetList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getVacationAppDetList", paramMap);
		Log.Debug();
		return resultMap;
	}
	
	/**
	 * vacationAppDet 단건 조회 4 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getVacationTaskMgrMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getVacationTaskMgrMap", paramMap);
		Log.Debug();
		return resultMap;
	}
	
	/**
	 * getVacationAppDetHour 단건 조회
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getVacationAppDetHour(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getVacationAppDetHour", paramMap);
		Log.Debug();
		return resultMap;
	}
	
	/**
	 * getVacationAppDetRestCnt 단건 조회
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getVacationAppDetRestCnt(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getVacationAppDetRestCnt", paramMap);
		Log.Debug();
		return resultMap;
	}
	
	/**
	 * getVacationAppDetDayCnt 단건 조회
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getVacationAppDetDayCnt(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getVacationAppDetDayCnt", paramMap);
		Log.Debug();
		return resultMap;
	}
	
	/**
	 * getVacationAppDetStatusCd 단건 조회
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getVacationAppDetStatusCd(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getVacationAppDetStatusCd", paramMap);
		Log.Debug();
		return resultMap;
	}
	
	/**
	 * getVacationAppDetPlanPopupMap 단건 조회
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getVacationAppDetPlanPopupMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getVacationAppDetPlanPopupMap", paramMap);
		Log.Debug();
		return resultMap;
	}
	
}