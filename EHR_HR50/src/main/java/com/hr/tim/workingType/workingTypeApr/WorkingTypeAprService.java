package com.hr.tim.workingType.workingTypeApr;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
import com.hr.common.other.OtherService;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import javax.inject.Named;
import java.util.List;
import java.util.Map;

/**
 * 근로시간단축 승인관리 Service
 *
 * @author bckim
 *
 */
@Service("WorkingTypeAprService")
public class WorkingTypeAprService{

	@Inject
	@Named("Dao")
	private Dao dao;

	@Inject
	@Named("OtherService")
	private OtherService otherService;

	public List<?> getWorkingTypeAprList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getWorkingTypeAprList", paramMap);
	}

	/**
	 * 근로시간단축 승인관리 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveWorkingTypeApr(Map<String, Object> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		
		List<Map<String,Object>> updateList = (List<Map<String,Object>>)convertMap.get("updateRows");
		List<Map<String,Object>> insertList = (List<Map<String,Object>>)convertMap.get("insertRows");

		// 신청결재 상태가 바뀐 경우	
		if( updateList.size() > 0){
			for(Map<String,Object> mp : updateList) {
				mp.put("ssnEnterCd", convertMap.get("ssnEnterCd") );
				mp.put("ssnSabun", convertMap.get("ssnSabun") );

				cnt += dao.update("updateWorkingTypeAprMaster", mp);
				//cnt += dao.update("updatePersonnelFormatApr", mp);
			}
		}
		
		// 결재신청 담당자가 대결
		if( insertList.size() > 0 ) {
			
			for(Map<String,Object> mp : insertList) {
				mp.put("ssnEnterCd", convertMap.get("ssnEnterCd") );
				mp.put("ssnSabun", convertMap.get("ssnSabun") );
				
				convertMap.put("seqId", "APPL");
				mp.put("searchApplSeq", ((Map)otherService.getSequence(convertMap)).get("getSeq").toString() );
				
				//TBEN401 INSERT
				cnt += dao.create("insertWorkingTypeApr", mp);
				
				//THRI103 INSERT
				mp.put("applStatusCd", "99"); // 처리완료
				mp.put("searchApplSabun", mp.get("sabun")); // 신청자
				mp.put("searchSabun", mp.get("ssnSabun")); // 신청 입력자(담당자)
				mp.put("searchApplCd", mp.get("applCd")); // 신청서 종류
				
				dao.create("saveApprovalMgrMaster", mp);
			}
		}

		Log.Debug();
		return cnt;
	}

	/**
	 * 근로시간단축 승인관리 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveWorkingTypeAprStatus(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;

		List<Map<String,Object>> updateList = (List<Map<String,Object>>)convertMap.get("updateRows");

		if( updateList.size() > 0){
			for(Map<String,Object> mp : updateList) {
				mp.put("ssnEnterCd", convertMap.get("ssnEnterCd") );
				mp.put("ssnSabun", convertMap.get("ssnSabun") );
				mp.put("applStatusCd", "99" );

				cnt += dao.update("updateWorkingTypeAprMaster", mp);
			}
		}

		Log.Debug();
		return cnt;
	}
}