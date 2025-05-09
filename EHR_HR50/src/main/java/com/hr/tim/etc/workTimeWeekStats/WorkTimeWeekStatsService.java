package com.hr.tim.etc.workTimeWeekStats;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 주단위근무현황 Service
 *
 * @author
 *
 */
@Service("WorkTimeWeekStatsService")
public class WorkTimeWeekStatsService{
	@Inject
	@Named("Dao")
	private Dao dao;
	
	/**
	 *  조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public List<?> getWorkTimeWeekStatsList(Map<String, Object> paramMap) throws Exception {
		Log.Debug();

		List<Map<String, Object>> titles = (List<Map<String, Object>>)dao.getList("getWorkTimeWeekStatsHeaderList", paramMap);
		paramMap.put("titles", titles);
				
		return (List<?>) dao.getList("getWorkTimeWeekStatsList", paramMap);
		
	}
	
	/**
	 * getWorkTimeWeekStatsMyWorkGrp 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getWorkTimeWeekStatsMyWorkGrp(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getWorkTimeWeekStatsMyWorkGrp", paramMap);
		Log.Debug();
		return resultMap;
	}
	
	/**
	 * getWorkTimeWeekStatsWeekList 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getWorkTimeWeekStatsWeekList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getWorkTimeWeekStatsWeekList", paramMap);
	}
	
	
	
	public List<?> getWorkTimeWeekPerList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getWorkTimeWeekPerList", paramMap);
	}
	
	/**
	 * getWorkTimeWeekStatsMonthWeekList 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getWorkTimeWeekStatsMonthWeekList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getWorkTimeWeekStatsMonthWeekList", paramMap);
	}
	
	/**
	 * 단위기간근무현황 조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public List<?> getWorkTimeWeekStatsList2(Map<String, Object> paramMap) throws Exception {
		Log.Debug();

		List<Map<String, Object>> titles = (List<Map<String, Object>>)dao.getList("getWorkTimeWeekStatsHeaderList", paramMap);
		paramMap.put("titles", titles);
				
		return (List<?>) dao.getList("getWorkTimeWeekStatsList2", paramMap);
		
	}
}