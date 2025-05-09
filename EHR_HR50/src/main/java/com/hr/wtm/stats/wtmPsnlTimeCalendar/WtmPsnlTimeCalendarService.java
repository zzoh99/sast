package com.hr.wtm.stats.wtmPsnlTimeCalendar;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import javax.inject.Named;
import java.util.List;
import java.util.Map;

/**
 * 조직원근태현황 Service
 *
 * @author EW
 *
 */
@Service("WtmPsnlTimeCalendarService")
public class WtmPsnlTimeCalendarService {

	@Inject
	@Named("Dao")
	private Dao dao;
	
	/**
	 * getPsnlTimeCalendarList 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getWtmPsnlTimeCalendarList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getWtmPsnlTimeCalendarList", paramMap);
	}
	
}
