package com.hr.tim.psnlWork.psnlCalendar;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * psnlCalendar Service
 *
 * @author EW
 *
 */
@Service("PsnlCalendarService")
public class PsnlCalendarService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * psnlCalendar 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPsnlCalendarList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getPsnlCalendarList", paramMap);
	}

	/**
	 * psnlCalendar 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int savePsnlCalendar(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deletePsnlCalendar", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("savePsnlCalendar", convertMap);
		}

		return cnt;
	}
	/**
	 * psnlCalendar 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getPsnlCalendarMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getPsnlCalendarMap", paramMap);
		Log.Debug();
		return resultMap;
	}
}
