package com.hr.tim.workApp.otWorkOrgUpdApp;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 연장근무변경신청 Service
 *
 * @author EW
 *
 */
@Service("OtWorkOrgUpdAppService")
public class OtWorkOrgUpdAppService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 연장근무변경신청 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int deleteOtWorkOrgUpdApp(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteOtWorkOrgUpdApp", convertMap);
			dao.delete("deleteApprovalMgrMaster", convertMap);
			dao.delete("deleteApprovalMgrAppLine", convertMap);
		}

		return cnt;
	}
}
