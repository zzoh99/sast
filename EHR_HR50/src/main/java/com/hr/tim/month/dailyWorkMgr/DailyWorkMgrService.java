package com.hr.tim.month.dailyWorkMgr;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;
/**
 * 일근무관리 Service
 *
 * @author JSG
 *
 */
@Service("DailyWorkMgrService")
public class DailyWorkMgrService{
	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 일근무관리 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getDailyWorkMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getDailyWorkMgrList", paramMap);
	}

	/**
	 * 입사지원서 해외경험 TOTAL COUNT 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?,?> getDailyWorkMgrCntMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getDailyWorkMgrCntMap", paramMap);
	}
	
	/**
	 * 일근무관리 헤더 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getDailyWorkMgrHeaderList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getDailyWorkMgrHeaderList", paramMap);
	}
	/**
	 * 일근무관리 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveDailyWorkMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=1;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			ParamUtils.mergeParams(convertMap, (List<Map<String, Object>>)convertMap.get("deleteRows"));
			dao.batchUpdate("deleteOtWorkAppDet335", (List<Map<?,?>>)convertMap.get("deleteRows"));
			dao.batchUpdate("deleteOtWorkAppDet337", (List<Map<?,?>>)convertMap.get("deleteRows"));
		}
		
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			ParamUtils.mergeParams(convertMap, (List<Map<String, Object>>)convertMap.get("mergeRows"));
			dao.batchUpdate("deleteOtWorkAppDet337", (List<Map<?,?>>)convertMap.get("mergeRows"));
			
			cnt += dao.update("saveOtWorkAppDet335", convertMap);
			cnt += dao.update("saveOtWorkAppDet337", convertMap);
		}

		return cnt;
	}
	
	public List<?> getDailyWorkMgrTimeList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getDailyWorkMgrTimeList", paramMap);
	}


}