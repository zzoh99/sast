package com.hr.tim.etc.workTimeDayStats;
import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 일별근무현황 Service
 *
 * @author
 *
 */
@Service("WorkTimeDayStatsService")
public class WorkTimeDayStatsService{
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
	
	public List<?> getWorkTimeDayStatsHeaderList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getWorkTimeDayStatsHeaderList", paramMap);
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