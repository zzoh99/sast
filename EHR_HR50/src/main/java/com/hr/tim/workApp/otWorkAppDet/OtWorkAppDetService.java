package com.hr.tim.workApp.otWorkAppDet;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 특근신청 Service
 * 
 * @author JSG
 *
 */
@Service("OtWorkAppDetService")  
public class OtWorkAppDetService{
	@Inject
	@Named("Dao")
	private Dao dao;
	
	/**
	 * 연장근무 기신청건 조회
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getOtWorkAppCheck(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getOtWorkAppCheck", paramMap);
	}
	
	
	/**
	 * 연장근무대상자여부 조회(연장근무대상자이면 연장근무 신청 할 수 없다.)
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getOtWorkAppDetSabun(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getOtWorkAppDetSabun", paramMap);
	}
	
	
	/**
	 *  특근신청 단건 조회 Service 
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getOtWorkAppDetMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getOtWorkAppDetMap", paramMap);
	}	
	
	/**
	 * 특근신청 다건 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getOtWorkAppDetList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getOtWorkAppDetList", paramMap);
	}	
	/**
	 * 특근신청 헤더 다건 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getOtWorkAppDetHeaderList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getOtWorkAppDetHeaderList", paramMap);
	}
	
	/**
	 * 특근신청 헤더 다건 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getOtWorkAppDetWokrTimeList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getOtWorkAppDetWokrTimeList", paramMap);
	}


	
	/**
	 * 특근신청 저장 Service
	 * 
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveOtWorkAppDet(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		dao.update("deleteOtWorkAppDet340", convertMap);
		dao.update("deleteOtWorkAppDet342", convertMap);
		
		cnt += dao.update("saveOtWorkAppDet340", convertMap);
		cnt += dao.update("saveOtWorkAppDet342", convertMap);
		
		return cnt;
	}
}