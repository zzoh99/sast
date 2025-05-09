package com.hr.tim.schedule.workScheduleAppDet;
import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;
/**
 * 근무스케쥴신청 Service
 *
 * @author
 *
 */
@Service("WorkScheduleAppDetService")
public class WorkScheduleAppDetService{
	@Inject
	@Named("Dao")
	private Dao dao;
	
	
	/**
	 * 헤더 조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public List<?> getWorkScheduleAppDetHeaderList(Map<String, Object> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getWorkScheduleAppDetHeaderList", paramMap);
	}

	/**
	 * 근무스케쥴신청 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveWorkScheduleAppDet(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		cnt += dao.delete("deleteWorkScheduleAppDetList", convertMap);
		cnt += dao.update("saveWorkScheduleAppDet", convertMap);
		
		ParamUtils.mergeParams(convertMap, (List<Map<String, Object>>)convertMap.get("mergeRows"));
		dao.batchUpdate("saveWorkScheduleAppDetList", (List<Map<?,?>>)convertMap.get("mergeRows"));
		
		
		Log.Debug();
		return cnt;
	}

	
}