package com.hr.wtm.stats.wtmWorkTimeDayStats;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import javax.inject.Named;
import java.util.List;
import java.util.Map;
/**
 * 일별근무현황 Service
 *
 * @author
 *
 */
@Service("WtmWorkTimeDayStatsService")
public class WtmWorkTimeDayStatsService {
	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * GetDataList 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getDataList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return (List<?>) dao.getList(paramMap.get("cmd").toString(), paramMap);
	}
	
	public List<?> getWtmWorkTimeDayStatsHeaderList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getWtmWorkTimeDayStatsHeaderList", paramMap);
	}

	/**
	 *  GetDataMap 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getDataMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap(paramMap.get("cmd").toString(), paramMap);
		Log.Debug();
		return resultMap;
	}
}