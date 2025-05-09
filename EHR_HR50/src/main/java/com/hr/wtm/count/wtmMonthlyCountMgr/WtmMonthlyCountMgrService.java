package com.hr.wtm.count.wtmMonthlyCountMgr;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
import com.hr.common.util.StringUtil;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import javax.inject.Named;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 월근태/근무관리 Service
 *
 * @author JSG
 *
 */
@Service("WtmMonthlyCountMgrService")
public class WtmMonthlyCountMgrService {

	@Inject
	@Named("Dao")
	private Dao dao;
	
	/**
	 * 월근태일수 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getWtmMonthlyCountMgrGntDays(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getWtmMonthlyCountMgrGntDays", paramMap);
	}

	/**
	 * 월근태일수 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveWtmMonthlyCountMgrGntDays(Map<?, ?> convertMap) throws Exception {
		Log.DebugStart();

		int cnt = 0;
		// delete 후에 insert
		if ( ((List<?>)convertMap.get("deleteRows")).size() > 0 ) {
			cnt += dao.delete("deleteWtmMonthlyCountMgrGntDays", convertMap);
		}
		if ( ((List<?>)convertMap.get("mergeRows")).size() > 0 ) {
			cnt += dao.update("saveWtmMonthlyCountMgrGntDays", convertMap);
		}

		Log.DebugEnd();
		return cnt;
	}

	/**
	 * 월근무시간(근무코드별) 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getWtmMonthlyCountMgrWorkTimeByCodes(Map<String, Object> paramMap) throws Exception {
		Log.Debug();

		List<Map<String, Object>> titles = getWtmMonthlyCountMgrHeaders(paramMap);
		paramMap.put("titles", titles);
		return (List<?>) dao.getList("getWtmMonthlyCountMgrWorkTimeByCodes", paramMap);
	}

	/**
	 * 월근무시간(근무코드별) 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveWtmMonthlyCountMgrWorkTimeByCodes(Map<String, Object> convertMap) throws Exception {
		Log.DebugStart();

		int cnt = 0;
		// delete 후에 insert
		if ( ((List<?>)convertMap.get("deleteRows")).size() > 0 ) {
			cnt += dao.delete("deleteWtmMonthlyCountMgrWorkTimeByCodes", convertMap);
		}

		if (convertMap.containsKey("mergeRows") && convertMap.get("mergeRows") instanceof List && !(((List<?>)convertMap.get("mergeRows")).isEmpty())) {
			List<Map<String, Object>> mergeRows = (List<Map<String, Object>>) convertMap.get("mergeRows");
			List<Map<String, Object>> headers = getWtmMonthlyCountMgrHeaders(convertMap);
			List<Map<String, Object>> tempRows = new ArrayList<>();
			mergeRows.forEach(map -> {
				for (Map<String, Object> header : headers) {
					String code = StringUtil.stringValueOf(header.get("code"));
					if (map.containsKey(code)) {
						Map<String, Object> tempMap = new HashMap<>(map);
						tempMap.put("reportItemCd", header.get("code"));
						tempMap.put("totValue", map.get(code));
						tempRows.add(tempMap);
					}
				}
			});

			convertMap.put("mergeRows", tempRows);
			cnt += dao.update("saveWtmMonthlyCountMgrWorkTimeByCodes", convertMap);
		}

		Log.DebugEnd();
		return cnt;
	}

	/**
	 * 월근무시간 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getWtmMonthlyCountMgrWorkTime(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getWtmMonthlyCountMgrWorkTime", paramMap);
	}

	/**
	 * 월근무시간 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveWtmMonthlyCountMgrWorkTime(Map<?, ?> convertMap) throws Exception {
		Log.DebugStart();

		int cnt = 0;
		// delete 후에 insert
		if ( ((List<?>)convertMap.get("deleteRows")).size() > 0 ) {
			cnt += dao.delete("deleteWtmMonthlyCountMgrWorkTime", convertMap);
		}
		if ( ((List<?>)convertMap.get("mergeRows")).size() > 0 ) {
			cnt += dao.update("saveWtmMonthlyCountMgrWorkTime", convertMap);
		}

		Log.DebugEnd();
		return cnt;
	}

	/**
	 * 월근무일수 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getWtmMonthlyCountMgrWorkDays(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getWtmMonthlyCountMgrWorkDays", paramMap);
	}

	/**
	 * 월근무일수 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveWtmMonthlyCountMgrWorkDays(Map<?, ?> convertMap) throws Exception {
		Log.DebugStart();

		int cnt = 0;
		// delete 후에 insert
		if ( ((List<?>)convertMap.get("deleteRows")).size() > 0 ) {
			cnt += dao.delete("deleteWtmMonthlyCountMgrWorkDays", convertMap);
		}
		if ( ((List<?>)convertMap.get("mergeRows")).size() > 0 ) {
			cnt += dao.update("saveWtmMonthlyCountMgrWorkDays", convertMap);
		}

		Log.DebugEnd();
		return cnt;
	}

	/**
	 * 일근무시간(근무코드별) 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getWtmMonthlyCountMgrDailyWorkTimeByCodes(Map<String, Object> paramMap) throws Exception {
		Log.Debug();

		List<Map<String, Object>> titles = getWtmMonthlyCountMgrHeaders(paramMap);
		paramMap.put("titles", titles);
		return (List<?>) dao.getList("getWtmMonthlyCountMgrDailyWorkTimeByCodes", paramMap);
	}

	/**
	 * 일근무시간(근무코드별) 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveWtmMonthlyCountMgrDailyWorkTimeByCodes(Map<String, Object> convertMap) throws Exception {
		Log.DebugStart();

		int cnt = 0;
		// delete 후에 insert
		if ( ((List<?>)convertMap.get("deleteRows")).size() > 0 ) {
			cnt += dao.delete("deleteWtmMonthlyCountMgrDailyWorkTimeByCodes", convertMap);
		}

		if (convertMap.containsKey("mergeRows") && convertMap.get("mergeRows") instanceof List && !(((List<?>)convertMap.get("mergeRows")).isEmpty())) {
			List<Map<String, Object>> mergeRows = (List<Map<String, Object>>) convertMap.get("mergeRows");
			List<Map<String, Object>> headers = getWtmMonthlyCountMgrHeaders(convertMap);
			List<Map<String, Object>> tempRows = new ArrayList<>();
			mergeRows.forEach(map -> {
				for (Map<String, Object> header : headers) {
					String code = StringUtil.stringValueOf(header.get("code"));
					if (map.containsKey(code)) {
						Map<String, Object> tempMap = new HashMap<>(map);
						tempMap.put("reportItemCd", header.get("code"));
						tempMap.put("totValue", map.get(code));
						tempRows.add(tempMap);
					}
				}
			});

			convertMap.put("mergeRows", tempRows);
			cnt += dao.update("saveWtmMonthlyCountMgrWorkTimeByCodes", convertMap);
		}

		Log.DebugEnd();
		return cnt;
	}

	/**
	 * 집계된 근무코드 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<Map<String, Object>> getWtmMonthlyCountMgrHeaders(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<Map<String, Object>>) dao.getList("getWtmMonthlyCountMgrHeaders", paramMap);
	}
}