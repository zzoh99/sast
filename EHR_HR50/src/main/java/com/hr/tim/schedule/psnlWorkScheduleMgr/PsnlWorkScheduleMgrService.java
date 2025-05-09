package com.hr.tim.schedule.psnlWorkScheduleMgr;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 개인근무스케줄관리 Service
 *
 * @author JSG
 *
 
 */

@Service("PsnlWorkScheduleMgrService")
public class PsnlWorkScheduleMgrService{
	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 개인근무스케줄관리 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPsnlWorkScheduleMgrList(Map<String, Object>  paramMap) throws Exception {
		Log.Debug();

		List<Map<String, Object>> titles = (List<Map<String, Object>>)dao.getList("getPsnlWorkScheduleMgrHeaderList", paramMap);
		paramMap.put("titles", titles);

		return (List<?>) dao.getList("getPsnlWorkScheduleMgrList", paramMap);
	}

	/**
	 * 개인근무스케줄관리 헤더 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPsnlWorkScheduleMgrHeaderList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getPsnlWorkScheduleMgrHeaderList", paramMap);
	}

	/**
	 * 개인근무스케줄관리- 일일근무시간(sheet2) 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPsnlWorkScheduleMgrDayWorkList(Map<String, Object> paramMap) throws Exception {
		Log.Debug();

		//개인근무스케줄관리 - 일일근무시간(sheet2) 헤더 다건 조회 
		List<Map<String, Object>> titles = (List<Map<String, Object>>)dao.getList("getPsnlWorkScheduleMgrDayWorkHeaderList", paramMap);
		paramMap.put("titles", titles);

		
		return (List<?>) dao.getList("getPsnlWorkScheduleMgrDayWorkList", paramMap);
	}

	/**
	 * 개인근무스케줄관리 - 일일근무시간(sheet2) 헤더 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPsnlWorkScheduleMgrDayWorkHeaderList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getPsnlWorkScheduleMgrDayWorkHeaderList", paramMap);
	}

	/**
	 * 개인근무스케줄관리 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int savePsnlWorkScheduleMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deletePsnlWorkScheduleMgr", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("savePsnlWorkScheduleMgr", convertMap);
		}

		return cnt;
	}

		
	public Map<?, ?> getPsnlWorkExtendCheck(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getPsnlWorkExtendCheck", paramMap);
	}	
	
	/**
	 * 개인근무스케줄관리 삭제 Service
	 *
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int deletePsnlWorkScheduleMgr(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.delete("deletePsnlWorkScheduleMgr", paramMap);
	}

	/**
	 * callP_TIM_WORK_HOUR_CHG 프로시저
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map callP_TIM_WORK_HOUR_CHG(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (Map) dao.excute("callP_TIM_WORK_HOUR_CHG", paramMap);
	}

	/**
	 * callP_TIM_MTN_SCHEDULE_CREATE 프로시저
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map callP_TIM_MTN_SCHEDULE_CREATE(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (Map) dao.excute("callP_TIM_MTN_SCHEDULE_CREATE", paramMap);
	}
	
	/**
	 * psnlWorkScheduleMgr 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getPsnlWorkScheduleMgrMemo(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getPsnlWorkScheduleMgrMemo", paramMap);
		Log.Debug();
		return resultMap;
	}
	
	/**
	 * psnlWorkScheduleMgr 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getPsnlWorkScheduleMgrEndYn(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getPsnlWorkScheduleMgrEndYn", paramMap);
		Log.Debug();
		return resultMap;
	}
}