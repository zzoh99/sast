package com.hr.hri.applyApproval.approvalMgrResult;

import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.hr.common.dao.Dao;
import com.hr.common.exception.HrException;
import com.hr.common.logger.Log;
import com.hr.common.util.SessionUtil;
import com.hr.hri.applyApproval.approvalAfterJob.ApprovalAfterJobService;

@SuppressWarnings("unchecked")
@Service("ApprovalMgrResultService")
public class ApprovalMgrResultService{

	@Inject
	@Named("Dao")
	private Dao dao;

	@Autowired
	private ApprovalAfterJobService approvalAfterJobService;

	/**
	 * 화면구성 정보 조회 Serivce
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getUiInfo(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (Map<?, ?>)dao.getMap("getUiInfo", paramMap);
	}

	/**
	 * 결재자 정보 조회 Serivce
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getAgreeSabun(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (Map<?, ?>)dao.getMap("getAgreeSabun", paramMap);
	}

	/**
	 * 결재자 Gubun 정보 조회 Serivce
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public String getApprovalMgrThri107Gubun(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		String gubun = "";

		Map<String, Object> rtn = (Map<String, Object>) dao.getMap("getApprovalMgrThri107Gubun", paramMap);

		if( rtn != null && !"".equals(rtn.get("gubun")) )
			gubun = (String)rtn.get("gubun");

		Log.Debug("gubun : " + gubun);
		return gubun;
	}

	/**
	 * 신청자 정보 조회 Serivce
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getApprovalMgrResultUserInfoMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (Map<?, ?>)dao.getMap("getApprovalMgrResultUserInfoMap", paramMap);
	}
	/**
	 * 결재 단계 조회 Serivce
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getApprovalMgrResultLevelCodeList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>)dao.getList("getApprovalMgrResultLevelCodeList", paramMap);
	}
	/**
	 * 내부결자선 조회 Serivce
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getApprovalMgrResultInList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>)dao.getList("getApprovalMgrResultInList", paramMap);
	}
	/**
	 * 내부결자선 조회 Serivce
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getApprovalMgrResultReferUserList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>)dao.getList("getApprovalMgrResultReferUserList", paramMap);
	}
	/**
	 * 내부결자선 변경 조회 Serivce
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getApprovalMgrResultReferUserChgList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>)dao.getList("getApprovalMgrResultReferUserChgList", paramMap);
	}

	/**
	 * 결재선 조회 Serivce
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getApprovalMgrResultApplOrgLvl(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getApprovalMgrResultApplOrgLvl", paramMap);
	}

	/**
	 * 결재선 조회 Serivce
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getApprovalMgrResultApplList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>)dao.getList("getApprovalMgrResultApplList", paramMap);
	}
	/**
	 * 결재선 조회 Serivce
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getApprovalMgrResultApplChgList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>)dao.getList("getApprovalMgrResultApplChgList", paramMap);
	}

	/**
	 * 대결자 조회 Serivce
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getApprovalMgrResultDeputyUserChgList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>)dao.getList("getApprovalMgrResultDeputyUserChgList", paramMap);
	}

	/**
	 * 임시저장 신성서 마스터 조회 Serivce
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getApprovalMgrResultTHRI103(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getApprovalMgrResultTHRI103", paramMap);
	}
	/**
	 * 임시저장 신성서 결재자 조회 Serivce
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getApprovalMgrResultTHRI107(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>)dao.getList("getApprovalMgrResultTHRI107", paramMap);
	}
	/**
	 * 임시저장 신성서 참조자 조회 Serivce
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getApprovalMgrResultTHRI125(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>)dao.getList("getApprovalMgrResultTHRI125", paramMap);
	}

	@Transactional(transactionManager ="phrTransactionManager", rollbackFor = Exception.class)
	public int saveApprovalMgrResult(String applSave,String referSave, Map<String, Object> paramMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if(applSave.equals("Save"))	cnt += dao.delete("deleteApprovalMgrResultAgreeUser", paramMap);
//		if(referSave.equals("Save"))cnt += dao.delete("deleteApprovalMgrResultReferUser", convertMap);

		if(applSave.equals("Save")) cnt += dao.update("insertApprovalMgrResultAgreeUser", 		paramMap);
		if(referSave.equals("Save"))cnt += dao.update("insertApprovalMgrResultReferUser", 		paramMap);


		Map<?, ?> agtimemap = dao.getMap("getAgreeDateMap", paramMap);
		
		String agreeTime = agtimemap != null && agtimemap.get("agreeTime") != null ?  agtimemap.get("agreeTime").toString():null;
		paramMap.put("agreeTime", agreeTime);
		paramMap.put("deputyAdminYn", "N"); //승인화면에서 관리자가 상태를 변경 했을 때만 "Y"넘김 2020.01.15
		
		Map<?, ?> prcRtn = (Map<?, ?>) dao.excute("approvalMgrResultProcCall",paramMap);
		if ("Y".equals(paramMap.get("procExecYn"))) {
			dao.excute("afterApprovalMgrResultProcCall",paramMap);
		}

		// 결재후처리 작업
		approvalAfterJobService.approvalAfterJob(paramMap);

		Log.Debug(prcRtn.toString());
		Object outCode		= prcRtn.get("outCode");
		Object outErrorMsg	= prcRtn.get("outErrorMsg");
		if(null == outCode || "OK".equals(outCode)){
			cnt++;
		}else{
			cnt = -1;
			throw new HrException(outErrorMsg.toString());
		}
		Log.Debug();
		return cnt;
	}

	public List<?> getApprovalMgrResultPopupList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>)dao.getList("getApprovalMgrResultPopupList", paramMap);
	}

	public int saveApprovalMgrResultPopup(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteApprovalMgrResultPopup", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveApprovalMgrResultPopup", convertMap);
		}
		Log.Debug();
		return cnt;
	}
	public Map<?, ?> getAgreeMaxCntMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getAgreeMaxCntMap", paramMap);
	}

	public int updateStatusCd(Map<String, Object> paramMap) throws Exception {
		Log.Debug();
		//Map<?, ?> afterProc = null;
		Map<?, ?> agtimemap = dao.getMap("getAgreeDateMap", paramMap);
		String agreeTime = agtimemap != null && agtimemap.get("agreeTime") != null ? agtimemap.get("agreeTime").toString():null;
		paramMap.put("agreeTime", agreeTime);

		int cnt= dao.update("updateStatusCd", paramMap); //신청서 결재 상태 변경
		
		//임시저장일 때
		if (paramMap.get("statusCd").equals("11")){
			
			dao.update("updateThir107StatusCd", paramMap); //결재라인 CLEAR
			
		//결재완료일 때	
		} else if (paramMap.get("statusCd").equals("99")) { 
			
			paramMap.put("deputyAdminYn", "Y"); //승인화면에서 관리자가 상태를 변경 했을 때만 "Y"넘김 2020.01.15
			
			Map<?, ?> prcRtn = (Map<?, ?>) dao.excute("approvalMgrResultProcCall",paramMap);
			
			Log.Debug("prcRtn.toString()=====> Call "+ prcRtn.toString());
			Object outCode		= prcRtn.get("outCode");
			Object outErrorMsg	= prcRtn.get("outErrorMsg");
			
			if(null == outCode){
				cnt++;
			}else{
				cnt = -1;
				throw new HrException(outErrorMsg.toString());
			}
			
		} else {
			
			//처리완료에서 다른 상태코드로 변경 시 담당자 대결 정보 삭제 2020.01.15
			if (paramMap.get("applStatusCd").equals("99") ) {
				dao.update("deleteDeputyAdminInfo1", paramMap);
				dao.update("deleteDeputyAdminInfo2", paramMap); 
				
			}	
		}
	
		/* 2018-06-21 결재완료일때만 호출하던거 무조건 호출하도록 변경*/
		if ("Y".equals(paramMap.get("procExecYn"))) {
			//afterProc = (Map<?, ?>) 
			dao.excute("afterApprovalMgrResultProcCall",paramMap);
		}

		Log.Debug();
		return cnt;
	}
	
	public int updateCancelStatusCd(Map<String, Object> paramMap) throws Exception {
		Log.Debug();
		int cnt= 0;
		//cnt= dao.update("updateStatusCd", paramMap);
		paramMap.put( "ssnEnterCd" , (String) SessionUtil.getRequestAttribute("ssnEnterCd"));
		paramMap.put( "ssnSabun" , (String) SessionUtil.getRequestAttribute("ssnSabun"));
		Map<?, ?> prcRtn = (Map<?, ?>) dao.excute("approvalMgrResultCancelProcCall",paramMap);

		Log.Debug(prcRtn.toString());
		Object outCode		= prcRtn.get("outCode");
		Object outErrorMsg	= prcRtn.get("outErrorMsg");
		if(null == outCode){
			cnt++;
		}else{
			cnt = -1;
			throw new HrException(outErrorMsg.toString());
		}
		

		Log.Debug();
		return cnt;
	}
	public int insertApprovalMgrResultReferAddUser(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=dao.create("insertApprovalMgrResultReferAddUser", convertMap);
		Log.Debug();
		return cnt;
	}
	public List<?> getApprovalMgrResultReferAllList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>)dao.getList("getApprovalMgrResultReferAllList", paramMap);
	}
	public Map<?, ?> getCancelButtonMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getCancelButtonMap", paramMap);
	}
	
	/**
	 * 의견댓글 저장 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public int saveComment(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		int cnt=0;
		cnt += dao.update("saveComment", paramMap);
		return cnt;
	}
	
	/**
	 *  의견댓글 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getCommentList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>)dao.getList("getCommentList", paramMap);
	}
	
	/**
	 * 의견댓글 삭제 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public int delComment(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		int cnt=0;
		cnt +=dao.update("delComment", paramMap);
		return cnt;
	}
	
	public List<?> getApprovalPushSabun(Map<?,?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>)dao.getList("getApprovalPushSabun", paramMap);
	}

	public List<?> getApprovalNotiSabun(Map<?,?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>)dao.getList("getApprovalNotiSabun", paramMap);
	}
}