package com.hr.tim.workApp.holWorkApp;
import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 휴일근무신청 Service
 *
 * @author
 *
 */
@Service("HolWorkAppService")
public class HolWorkAppService{
	@Inject
	@Named("Dao")
	private Dao dao;

	
	/**
	 * 휴일근무신청 임시저장 삭제 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int deleteHolWorkApp(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteHolWorkApp", convertMap);
			dao.delete("deleteApprovalMgrMaster", convertMap);
			dao.delete("deleteApprovalMgrAppLine", convertMap);
		}
		Log.Debug();
		return cnt;
	}



	/**
	 * 대체휴가신청 임시저장 삭제 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int deleteHolAlterApp(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteHolAlterApp", convertMap);
			dao.delete("deleteApprovalMgrMaster2", convertMap);
			dao.delete("deleteApprovalMgrAppLine2", convertMap);
		}
		Log.Debug();
		return cnt;
	}

}