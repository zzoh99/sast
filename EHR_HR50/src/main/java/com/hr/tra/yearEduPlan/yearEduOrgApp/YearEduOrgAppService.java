package com.hr.tra.yearEduPlan.yearEduOrgApp;

import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 연간교육계획신청 Service
 *
 * @author EW
 *
 */
@Service("YearEduOrgAppService")
public class YearEduOrgAppService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 연간교육계획신청 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int deleteYearEduOrgApp(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteYearEduOrgApp", convertMap);
			dao.delete("deleteApprovalMgrMaster", convertMap);
			dao.delete("deleteApprovalMgrAppLine", convertMap);
		}

		return cnt;
	}
}
