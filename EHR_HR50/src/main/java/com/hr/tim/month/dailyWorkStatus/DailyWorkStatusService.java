package com.hr.tim.month.dailyWorkStatus;
import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 일근무관리 Service
 *
 * @author JSG
 *
 */
@Service("DailyWorkStatusService")
public class DailyWorkStatusService{
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
	public List<?> getDailyWorkStatusList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getDailyWorkStatusList", paramMap);
	}

	/**
	 * 입사지원서 해외경험 TOTAL COUNT 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?,?> getDailyWorkStatusCntMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getDailyWorkStatusCntMap", paramMap);
	}
	
	/**
	 * 일근무관리 헤더 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getDailyWorkStatusHeaderList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getDailyWorkStatusHeaderList", paramMap);
	}
	/**
	 * 일근무관리 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveDailyWorkStatus(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.update("deleteOtWorkAppDet335", convertMap);
		}
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0 || ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("deleteOtWorkAppDet337", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveOtWorkAppDet335", convertMap);
			cnt += dao.update("saveOtWorkAppDet337", convertMap);
		}

		return cnt;
	}
}