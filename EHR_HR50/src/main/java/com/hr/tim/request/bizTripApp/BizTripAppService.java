package com.hr.tim.request.bizTripApp;
import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 해외출장신청/보고서 Service
 *
 * @author EW
 *
 */
@Service("BizTripAppService")
public class BizTripAppService{

	@Inject
	@Named("Dao")
	private Dao dao;
	
	/**
	 * 해외출장신청 임시저장 삭제
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int deleteBizTripApp(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteBizTripApp", convertMap);
			dao.delete("deleteBizTripApp2", convertMap);
			dao.delete("deleteBizTripApp3", convertMap);
			dao.delete("deleteBizTripApp4", convertMap);
			dao.delete("deleteApprovalMgrMaster", convertMap);
			dao.delete("deleteApprovalMgrAppLine", convertMap);
		}

		return cnt;
	}
	
	/**
	 * 해외출장 보고서 임시저장 삭제
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int deleteBizTripApp2(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteBizTripApp", convertMap);
			dao.delete("deleteBizTripApp2", convertMap);
			dao.delete("deleteBizTripApp3", convertMap);
			dao.delete("deleteBizTripApp4", convertMap);
			dao.delete("deleteApprovalMgrMaster2", convertMap);
			dao.delete("deleteApprovalMgrAppLine2", convertMap);
		}

		return cnt;
	}
}
