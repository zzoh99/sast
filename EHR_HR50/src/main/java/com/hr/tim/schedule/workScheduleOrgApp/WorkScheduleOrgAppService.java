package com.hr.tim.schedule.workScheduleOrgApp;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 부서근무스케쥴신청 Service
 *
 * @author
 *
 */
@Service("WorkScheduleOrgAppService")
public class WorkScheduleOrgAppService{
	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 부서근무스케쥴신청 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int deleteWorkScheduleOrgApp(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteWorkScheduleOrgApp1", convertMap);
			cnt += dao.delete("deleteWorkScheduleOrgApp2", convertMap);
			dao.delete("deleteApprovalMgrMaster", convertMap);
			dao.delete("deleteApprovalMgrAppLine", convertMap);
		}
		Log.Debug();
		return cnt;
	}
}