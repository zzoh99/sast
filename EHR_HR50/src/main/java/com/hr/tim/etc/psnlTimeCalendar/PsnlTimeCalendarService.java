package com.hr.tim.etc.psnlTimeCalendar;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 조직원근태현황 Service
 *
 * @author EW
 *
 */
@Service("PsnlTimeCalendarService")
public class PsnlTimeCalendarService{

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
	public List<?> getPsnlTimeCalendarList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getPsnlTimeCalendarList", paramMap);
	}
	
}
