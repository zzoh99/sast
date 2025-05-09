package com.hr.wtm.stats.wtmWorkTime;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import javax.inject.Named;
import java.util.List;
import java.util.Map;
/**
 * 일근무관리 Service
 *
 * @author JSG
 *
 */
@Service("WtmWorkTimeService")
public class WtmWorkTimeService {
	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 일근무관리 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getWtmWorkTimeList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getWtmWorkTimeList", paramMap);
	}
	
	/**
	 * 일근무관리 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getWtmWorkTimeList2(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getWtmWorkTimeList2", paramMap);
	}
	
	/**
	 * 일근무관리 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getWorkStatusInfo(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getWorkStatusInfo", paramMap);
	}

	
	/**
	 * 일근무관리 헤더 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getWtmWorkTimeHeaderList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getWtmWorkTimeHeaderList", paramMap);
	}

	public int saveWorkTime(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			dao.delete("deleteApprovalMgrMaster", convertMap);   // ApprovalMgr-mapping-query.xml 쿼리
			cnt += dao.delete("deleteWorkTimep", convertMap);
		}
		Log.Debug();
		return cnt;
	}
	
	/**
	 * workTime 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getUserIntervalDate(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getUserIntervalDate", paramMap);
		Log.Debug();
		return resultMap;
	}
	
	/**
	 * workTime 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getUserAuthCheck(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getUserAuthCheck", paramMap);
		Log.Debug();
		return resultMap;
	}
	
}