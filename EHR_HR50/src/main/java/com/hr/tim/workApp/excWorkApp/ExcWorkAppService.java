package com.hr.tim.workApp.excWorkApp;
import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 당직신청 Service
 *
 * @author
 *
 */
@Service("ExcWorkAppService")
public class ExcWorkAppService{
	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 당직신청 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int deleteExcWorkApp(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteExcWorkApp", convertMap);
			dao.delete("deleteApprovalMgrMaster", convertMap);
			dao.delete("deleteApprovalMgrAppLine", convertMap);
		}
		Log.Debug();
		return cnt;
	}


}