package com.hr.ben.club.clubrefApp;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import javax.inject.Named;
import java.util.List;
import java.util.Map;

/**
 * 동호회 재 신청 Service
 *
 * @author EW
 *
 */
@Service("ClubrefAppService")
public class ClubrefAppService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 동호회 재 신청 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int deleteClubrefApp(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteClubrefApp", convertMap);
			dao.delete("deleteApprovalMgrMaster", convertMap);
			dao.delete("deleteApprovalMgrAppLine", convertMap);
		}

		return cnt;
	}
}
