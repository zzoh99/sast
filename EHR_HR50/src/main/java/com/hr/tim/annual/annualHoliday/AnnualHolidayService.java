package com.hr.tim.annual.annualHoliday;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * annualHoliday Service
 *
 * @author EW
 *
 */
@Service("AnnualHolidayService")
public class AnnualHolidayService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * annualHoliday 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getAnnualHolidayList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getAnnualHolidayList", paramMap);
	}

	/**
	 * annualHoliday 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveAnnualHoliday(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteAnnualHoliday", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveAnnualHoliday", convertMap);
		}

		return cnt;
	}
	/**
	 * annualHoliday 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getAnnualHolidayMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getAnnualHolidayMap", paramMap);
		Log.Debug();
		return resultMap;
	}
}
