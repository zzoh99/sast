package com.hr.hrm.psnalInfo.psnalSchoolMgr;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * PsnalSchoolMgr Service
 *
 * @author jy
 *
 */
@Service("PsnalSchoolMgrService")
public class PsnalSchoolMgrService{

	@Inject
	@Named("Dao")
	private Dao dao;
	
	/**
	 * 개인별학력사항관리 저장
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int savePsnalSchoolMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deletePsnalSchoolMgr", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("savePsnalSchoolMgr", convertMap);
		}

		return cnt;
	}

	
}
