package com.hr.tim.month.monthWorkHourUpload;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * monthWorkHourUpload Service
 *
 * @author EW
 *
 */
@Service("MonthWorkHourUploadService")
public class MonthWorkHourUploadService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * monthWorkHourUpload 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getMonthWorkHourUploadList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getMonthWorkHourUploadList", paramMap);
	}

	/**
	 * monthWorkHourUpload 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveMonthWorkHourUpload(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteMonthWorkHourUpload", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveMonthWorkHourUpload", convertMap);
		}

		return cnt;
	}
	/**
	 * monthWorkHourUpload 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getMonthWorkHourUploadMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getMonthWorkHourUploadMap", paramMap);
		Log.Debug();
		return resultMap;
	}
}
