package com.hr.tim.code.holidayOccurStd;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * holidayOccurStd Service
 *
 * @author EW
 *
 */
@Service("HolidayOccurStdService")
public class HolidayOccurStdService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * holidayOccurStd 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getHolidayOccurStdList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getHolidayOccurStdList", paramMap);
	}

	/**
	 * holidayOccurStd 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveHolidayOccurStd(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteHolidayOccurStd", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveHolidayOccurStd", convertMap);
		}

		return cnt;
	}
	/**
	 * holidayOccurStd 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getHolidayOccurStdMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getHolidayOccurStdMap", paramMap);
		Log.Debug();
		return resultMap;
	}
}
