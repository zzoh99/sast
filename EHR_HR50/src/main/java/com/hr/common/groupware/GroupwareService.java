package com.hr.common.groupware;

import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * Groupware Service
 * 
 * @author 이름
 *
 */
@Service("GroupwareService")
public class GroupwareService {
	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getGroupwareAppRcvMap(Map<?, ?> paramMap) throws Exception {
		Log.DebugStart();
		return dao.getMap("getGroupwareAppRcvMap", paramMap);
	}
	
	/**
	 * 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getGroupwareAppSndMap_HLOANApply(Map<?, ?> paramMap) throws Exception {
		Log.DebugStart();
		
		Map<?, ?> rtn = dao.getMap("getGroupwareAppSndMap_HLOANApply", paramMap);
		
		return rtn;
	}
	
	/**
	 * 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getGroupwareAppSndMap_HWI_HLOANAPPLY(Map<?, ?> paramMap) throws Exception {
		Log.DebugStart();
		return dao.getMap("getGroupwareAppSndMap_HWI_HLOANAPPLY", paramMap);
	}

	/**
	 * 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getGroupwareAppSndMap_HWI_HLOANCREDIT(Map<?, ?> paramMap) throws Exception {
		Log.DebugStart();
		return dao.getMap("getGroupwareAppSndMap_HWI_HLOANCREDIT", paramMap);
	}

	/**
	 * 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getGroupwareAppSndMap_HWI_HLOANMST(Map<?, ?> paramMap) throws Exception {
		Log.DebugStart();
		
		// 기존대여정보 조회
		return dao.getMap("getGroupwareAppSndMap_HWI_HLOANMST", paramMap);
	}

	/**
	 * 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getGroupwareAppSndMap_HHI_PERMST01(Map<?, ?> paramMap) throws Exception {
		Log.DebugStart();
		return dao.getMap("getGroupwareAppSndMap_HHI_PERMST01", paramMap);
	}

	/**
	 * 저장(로그) Service
	 *
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public int saveGroupwareLog(Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		int cnt = 0;
		
		paramMap.putAll((Map<String, Object>) dao.getMap("getGroupwareLogSeq", paramMap));
		
		cnt += dao.update("saveGroupwareLog", paramMap);
		cnt += dao.updateClob("updateGroupwareLog", paramMap);
		
		Log.DebugEnd();
		return cnt;
	}

}