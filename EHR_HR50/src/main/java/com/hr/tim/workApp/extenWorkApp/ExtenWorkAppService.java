package com.hr.tim.workApp.extenWorkApp;
import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 연장근무추가신청 Service
 *
 * @author
 *
 */
@Service("ExtenWorkAppService")
public class ExtenWorkAppService{
	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 연장근무추가신청 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int deleteExtenWorkApp(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteExtenWorkApp", convertMap);
			cnt += dao.delete("deleteExtenWorkApp2", convertMap);
			dao.delete("deleteApprovalMgrMaster", convertMap);
			dao.delete("deleteApprovalMgrAppLine", convertMap);
		}
		Log.Debug();
		return cnt;
	}


}