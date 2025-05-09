package com.hr.ben.club.clubpayApp;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import javax.inject.Named;
import java.util.List;
import java.util.Map;

/**
 * 동호회 지원금 Service
 *
 * @author EW
 *
 */
@Service("ClubpayAppService")
public class ClubpayAppService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 동호회 지원금 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int deleteClubpayApp(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteClubpayApp", convertMap);
			dao.delete("deleteApprovalMgrMaster", convertMap);
			dao.delete("deleteApprovalMgrAppLine", convertMap);
		}

		return cnt;
	}
}
