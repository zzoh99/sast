package com.hr.tim.schedule.workScheduleOrgAppDet;
import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;
/**
 * 부서근무스케쥴신청 Service
 *
 * @author
 *
 */
@Service("WorkScheduleOrgAppDetService")
public class WorkScheduleOrgAppDetService{
	@Inject
	@Named("Dao")
	private Dao dao;
	
	
	/**
	 * 헤더 조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public List<?> getWorkScheduleOrgAppDetHeaderList(Map<String, Object> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getWorkScheduleOrgAppDetHeaderList", paramMap);
	}

	/**
	 * 부서근무스케쥴신청 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveWorkScheduleOrgAppDet(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		cnt += dao.delete("deleteWorkScheduleOrgAppDetList", convertMap);
		cnt += dao.update("saveWorkScheduleOrgAppDet", convertMap);
		
		ParamUtils.mergeParams(convertMap, (List<Map<String, Object>>)convertMap.get("mergeRows"));
		dao.batchUpdate("saveWorkScheduleOrgAppDetList", (List<Map<?,?>>)convertMap.get("mergeRows"));
		
		
		Log.Debug();
		return cnt;
	}

	
}