package com.hr.tim.annual.annualPlanAgrApp;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 휴가계획신청 Service
 *
 * @author EW
 *
 */
@Service("AnnualPlanAgrAppService")
public class AnnualPlanAgrAppService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 휴가계획신청  반려삭제 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int deleteAnnualPlanAgrApp(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			// 반려삭제시, 동의여부 CLEAR
			cnt = dao.delete("saveAnnualPlanAgrApp", convertMap);

			// 결재쪽 테이블 삭제
			dao.delete("deleteApprovalMgrMaster", convertMap);
			dao.delete("deleteApprovalMgrAppLine", convertMap);
		}

		return cnt;
	}
}
