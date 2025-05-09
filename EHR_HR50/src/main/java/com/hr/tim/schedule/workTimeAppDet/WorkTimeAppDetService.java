package com.hr.tim.schedule.workTimeAppDet;
import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;
/**
 * 조직근무시간신청 Service
 *
 * @author
 *
 */
@Service("WorkTimeAppDetService")
public class WorkTimeAppDetService{
	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 조직근무시간신청 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getWorkTimeAppDet(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getWorkTimeAppDet", paramMap);
		Log.Debug();
		return resultMap;
	}
	
	/**
	 * 조직근무시간신청 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getWorkTimeAppDetDupCnt(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getWorkTimeAppDetDupCnt", paramMap);
		Log.Debug();
		return resultMap;
	}
	
	/**
	 * "getWorkTimeAppDetList" 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getWorkTimeAppDetList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getWorkTimeAppDetList", paramMap);
	}
	
	/**
	 * 조직근무시간신청 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveWorkTimeAppDet(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		cnt += dao.delete("deleteWorkTimeAppDetList", convertMap);
		cnt += dao.update("saveWorkTimeAppDet", convertMap);
		
		ParamUtils.mergeParams(convertMap, (List<Map<String, Object>>)convertMap.get("mergeRows"));
		dao.batchUpdate("saveWorkTimeAppDetList", (List<Map<?,?>>)convertMap.get("mergeRows"));
		
		
		Log.Debug();
		return cnt;
	}


}