package com.hr.tim.month.monthWorkMgr;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;

import com.hr.common.com.ComService;
import com.hr.common.dao.Dao;
import com.hr.common.exception.HrException;
import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;

/**
 * 월근태/근무관리 Service
 *
 * @author JSG
 *
 */
@Service("MonthWorkMgrService")
public class MonthWorkMgrService{
	@Inject
	@Named("Dao")
	private Dao dao;

	@Inject
	@Named("ComService")
	private ComService comService;
	
	/**
	 * 월근무시간  다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getMonthWorkMgrList(String queryId, Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList(queryId, paramMap);
	}

	/**
	 * 월근태일수 (근무코드별) 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveMonthWorkTimeTab1(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		// delete 후에 insert
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0 || ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.delete("deleteMonthWorkTimeTab1", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveMonthWorkTimeTab1", convertMap);
		}
		Log.Debug("saveMonthWorkTimeTab1 End");
		return cnt;
	}
	
	/**
	 * monthWorkDayTab 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getMonthWorkDayTab(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getMonthWorkDayTab", paramMap);
	}

	/**
	 * monthWorkDayTab 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveMonthWorkDayTab(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteMonthWorkDayTab", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveMonthWorkDayTab", convertMap);
		}

		return cnt;
	}
	
	/**
	 * monthWorkTimeTab 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getMonthWorkTimeTab(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getMonthWorkTimeTab", paramMap);
	}

	/**
	 * monthWorkTimeTab 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveMonthWorkTimeTab(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteMonthWorkTimeTab", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveMonthWorkTimeTab", convertMap);
		}

		return cnt;
	}
	
	/**
	 * monthWorkTotalTab 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getMonthWorkTotalTab(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getMonthWorkTotalTab", paramMap);
	}

	/**
	 * monthWorkTotalTab 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveMonthWorkTotalTab(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteMonthWorkTotalTab", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveMonthWorkTotalTab", convertMap);
		}

		return cnt;
	}

	/**
	 * 일근무 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveMonthWorkTimeTab2(Map<?, ?> convertMap) throws Exception {
		Log.Debug();

		int cnt=0;

		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			ParamUtils.mergeParams(convertMap, (List<Map<String, Object>>)convertMap.get("deleteRows"));
			dao.batchUpdate("deleteMonthWorkTimeTab2", (List<Map<?,?>>)convertMap.get("deleteRows"));
			cnt = 1;
		}

		List<Map<String,Object>> mergeList = (List<Map<String,Object>>)convertMap.get("mergeRows");
		
		if( mergeList.size() > 0){

			List<Map<String,Object>> titleList= (List<Map<String,Object>>)convertMap.get("titles");
			
			for(Map<String,Object> mp : mergeList) {

				for(Map<String,Object> tit : titleList) {

					Map<String, Object> paramMap = new HashMap<String, Object>();

					paramMap.put("ssnEnterCd", String.valueOf(convertMap.get("ssnEnterCd")));
					paramMap.put("ssnSabun",   String.valueOf(convertMap.get("ssnSabun")));
					paramMap.put("searchYm",   String.valueOf(convertMap.get("searchYm")));
					paramMap.put("sabun", 	   String.valueOf(mp.get("sabun")));
					paramMap.put("ymd", 	   String.valueOf(mp.get("ymd")));
					
					paramMap.put("workCd",     String.valueOf(tit.get("code")));
					paramMap.put("workHour",   String.valueOf(mp.get(String.valueOf(tit.get("saveNameDisp")))));
					Log.Debug(cnt +":"+paramMap.toString());
					cnt += dao.update("saveMonthWorkTimeTab2", paramMap);
				}
				
			}
		}

		return cnt;
	}

}