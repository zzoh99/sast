package com.hr.wtm.stats.wtmOrgDailyTimeStats;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import javax.inject.Named;
import java.util.List;
import java.util.Map;

/**
 * 부서원근태현황 Service
 *
 * @author bckim
 *
 */
@Service("WtmOrgDailyTimeStatsService")
public class WtmOrgDailyTimeStatsService {

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 부서원근태현황 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<Map<String, Object>> getWtmOrgDailyTimeStatsList(Map<String, Object> paramMap) throws Exception {
		Log.Debug();
		List<Map<String, Object>> titleList = (List<Map<String, Object>>) dao.getList("getWtmOrgDailyTimeStatsHeaderList", paramMap);
		paramMap.put("titles", titleList);
		return (List<Map<String, Object>>) dao.getList("getWtmOrgDailyTimeStatsList", paramMap);
	}

	/**
	 * 근태코드(헤더) 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getWtmOrgDailyTimeStatsHeaderList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getWtmOrgDailyTimeStatsHeaderList", paramMap);
	}
}