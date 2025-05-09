package com.hr.tim.request.vacationApr;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 근태승인관리 Service
 *
 * @author JSG
 *
 */
@SuppressWarnings("unchecked")
@Service("VacationAprService")
public class VacationAprService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 근태승인관리 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getVacationAprList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getVacationAprList", paramMap);
	}

	/**
	 * 근태승인관리 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	public int saveVacationApr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			dao.delete("deleteVacationApr103", convertMap);
			cnt += dao.delete("deleteVacationApr", convertMap);
		}
		Log.Debug();
		return cnt;
	}
	*/

	/**
	 * 근태승인관리 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveVacationApr(Map<String, Object> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;

		//결재상태 수정
		if( ((List<?>)convertMap.get("updateRows")).size() > 0){
			//update
			cnt += dao.update("saveVacationApr", convertMap);
			for(Map<String,Object> mp : ((List<Map<String,Object>>)convertMap.get("updateRows"))) {
				mp.put("ssnEnterCd", convertMap.get("ssnEnterCd") );
				mp.put("ssnSabun", convertMap.get("ssnSabun") );
				mp.put("searchApplSabun", mp.get("sabun")); // 신청자
				mp.put("sdate", mp.get("sYmd")); // 신청자
				// 연차 사용 내역 재계산
				dao.excute("prcP_TIM_VACATION_CLEAN", mp);
			}
			
			// P_HRI_AFTER_PROC_EXEC 호출 처리
			// 22(근태신청)의 PROC_EXEC_YN(후처리프로시져사용여부) 취득
			Map<String, Object> paramMap = new HashMap<String, Object>();
			paramMap.put("ssnEnterCd", convertMap.get("ssnEnterCd"));
			paramMap.put("searchApplCd", "22");
			Map<?, ?> uiInfo = (Map<?, ?>) dao.getMap("getUiInfo", paramMap);
			String procExecYn = (String)uiInfo.get("procExecYn");
			
			if ("Y".equals(procExecYn)) {
				for (Map<String,Object> mp : ((List<Map<String,Object>>)convertMap.get("updateRows"))) {
					mp.put("ssnEnterCd", convertMap.get("ssnEnterCd"));
					mp.put("ssnSabun", convertMap.get("ssnSabun"));
					mp.put("searchApplSabun", mp.get("sabun"));	// 신청자
					mp.put("searchApplSeq", mp.get("applSeq"));	// 신청서순번
					mp.put("searchApplCd", "22");	// 근태신청
					mp.put("afterProcStatusCd", mp.get("oldApplStatusCd"));	// 이전 결재상태코드
					// P_HRI_AFTER_PROC_EXEC 호출
					dao.excute("afterApprovalMgrResultProcCall", mp);
				}
			}
		}

		Log.Debug();
		return cnt;
	}
}