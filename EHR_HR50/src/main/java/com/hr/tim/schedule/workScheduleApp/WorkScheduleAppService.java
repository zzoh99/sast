package com.hr.tim.schedule.workScheduleApp;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 근무스케쥴신청 Service
 *
 * @author
 *
 */
@Service("WorkScheduleAppService")
public class WorkScheduleAppService{
	@Inject
	@Named("Dao")
	private Dao dao;

	
	/**
	 * 부서근무스케쥴 헤더 조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public List<?> getWorkScheduleAppHeaderList(Map<String, Object> paramMap) throws Exception {
		Log.Debug();
		
		return (List<?>) dao.getList("getWorkScheduleAppHeaderList", paramMap);
	}
	/**
	 * 근무스케쥴신청 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int deleteWorkScheduleApp(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteWorkScheduleApp1", convertMap);
			cnt += dao.delete("deleteWorkScheduleApp2", convertMap);
			dao.delete("deleteApprovalMgrMaster", convertMap);
			dao.delete("deleteApprovalMgrAppLine", convertMap);
		}
		Log.Debug();
		return cnt;
	}
}