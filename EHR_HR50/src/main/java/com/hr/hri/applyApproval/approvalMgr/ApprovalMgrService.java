package com.hr.hri.applyApproval.approvalMgr;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.stream.Collectors;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpSession;

import com.hr.common.appPush.PushServiceImpl;
import com.hr.common.notification.NotificationService;
import com.hr.common.util.StringUtil;
import com.hr.hri.applyApproval.approvalAfterJob.ApprovalAfterJobService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.exception.HrException;
import com.hr.common.logger.Log;
import org.springframework.transaction.annotation.Transactional;

@Service("ApprovalMgrService") 
public class ApprovalMgrService{
 
	@Inject
	@Named("Dao")
	private Dao dao;

	@Autowired
	private NotificationService notificationService;

	@Autowired
	private PushServiceImpl pushService;

	private final ExecutorService executorService = Executors.newCachedThreadPool();

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
	 * 신청자 정보 조회 Serivce
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getR10052CodeList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>)dao.getList("getR10052CodeList", paramMap);
	}
	/**
	 * 신청자 정보 조회 Serivce
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getApprovalMgrUserInfoMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (Map<?, ?>)dao.getMap("getApprovalMgrUserInfoMap", paramMap);
	}
	/**
	 * 결재 단계 조회 Serivce
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getApprovalMgrLevelCodeList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>)dao.getList("getApprovalMgrLevelCodeList", paramMap);
	}
	/**
	 * 내부결자선 조회 Serivce
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getApprovalMgrInList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>)dao.getList("getApprovalMgrInList", paramMap);
	}
	/**
	 * 내부결자선 조회 Serivce
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getApprovalMgrReferUserList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>)dao.getList("getApprovalMgrReferUserList", paramMap);
	}
	/**
	 * 내부결자선 변경 조회 Serivce
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getApprovalMgrReferUserChgList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>)dao.getList("getApprovalMgrReferUserChgList", paramMap);
	}
	
	/**
	 * 결재선 조회 Serivce
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getApprovalMgrApplOrgLvl(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getApprovalMgrApplOrgLvl", paramMap);
	}
	
	/**
	 * 결재선 조회 Serivce
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getApprovalMgrApplList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>)dao.getList("getApprovalMgrApplList", paramMap);
	}
	/**
	 * 결재선 조회 Serivce
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getApprovalMgrApplChgList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>)dao.getList("getApprovalMgrApplChgList", paramMap);
	}
	
	/**
	 * 대결자 조회 Serivce
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getApprovalMgrDeputyUserChgList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>)dao.getList("getApprovalMgrDeputyUserChgList", paramMap);
	}
	
	/**
	 * 임시저장 신성서 마스터 조회 Serivce
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getApprovalMgrTHRI103(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getApprovalMgrTHRI103", paramMap);
	}
	/**
	 * 임시저장 신성서 결재자 조회 Serivce
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getApprovalMgrTHRI107(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>)dao.getList("getApprovalMgrTHRI107", paramMap);
	}
	/**
	 * 임시저장 신성서 참조자 조회 Serivce
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getApprovalMgrTHRI125(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>)dao.getList("getApprovalMgrTHRI125", paramMap);
	}

	@Transactional(transactionManager ="phrTransactionManager", rollbackFor = Exception.class)
	public int saveApprovalMgr(Map<String, Object> convertMap) throws Exception {
		Log.Debug();
		Log.Debug(convertMap.toString());
		int cnt=0;
		cnt += dao.delete("deleteApprovalMgrMater", 	convertMap);
		cnt += dao.delete("deleteApprovalMgrAgreeUser", convertMap);
		cnt += dao.delete("deleteApprovalMgrReferUser", convertMap);
		cnt += dao.create("saveApprovalMgrMaster", 		convertMap);
		cnt += dao.create("saveApprovalMgrAgreeUser", 	convertMap);
		if( ((List<?>)convertMap.get("refers")).size() > 0)
			cnt += dao.create("saveApprovalMgrReferUser", 	convertMap);
		
		Map<?, ?> prcRtn = new HashMap<>((Map<?, ?>) dao.excute("approvalMgrProcCall", convertMap));

		Map<?, ?> afterProc  = null;
		if ("Y".equals(convertMap.get("procExecYn"))) {
			afterProc = new HashMap<>((Map<?, ?>) dao.excute("afterApprovalMgrResultProcCall",convertMap));
		}

		// 결재후처리 작업
		approvalAfterJobService.approvalAfterJob(convertMap);

		Log.Debug("##########################"+prcRtn.toString());
		Object outCode		= prcRtn.get("outCode");
		Object outErrorMsg	= prcRtn.get("outErrorMsg");
		if(null == outCode){
			cnt++;
		} else{
			cnt = -1;
			throw new HrException(outErrorMsg.toString());
		}
		
		Log.Debug();
		return cnt;
	}

	public List<?> getApprovalMgrPopupList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>)dao.getList("getApprovalMgrPopupList", paramMap);
	}
	
	public int saveApprovalMgrPopup(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteApprovalMgrPopup", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveApprovalMgrPopup", convertMap);
		}
		Log.Debug();
		return cnt;
	}
	
	public List<?> getApprovalPushSabun(Map<?,?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>)dao.getList("getApprovalPushSabun", paramMap);		
	}

	public List<?> getApprovalAppPushList(Map<?,?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>)dao.getList("getApprovalAppPushList", paramMap);
	}

	public List<?> getApprovalNotiSabun(Map<?,?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>)dao.getList("getApprovalNotiSabun", paramMap);
	}

	public void sendNotification(HttpSession session, Map<String, Object> params, String eventName) throws Exception {
		if (useNotification(session)) {
			String enterCd = session.getAttribute("ssnEnterCd").toString();
			List<Map<String, Object>> pushSabuns = (List<Map<String, Object>>) getApprovalNotiSabun(params);

			for(Map<String, Object> pushSabun : pushSabuns) {
				pushSabun.put("ssnEnterCd", enterCd);

				// 알림 내용 저장
				notificationService.saveNotification(pushSabun);
				//notificationService.notify(enterCd, (String) pushSabun.get("notiSabun"), eventName, pushSabun.get("content"));
			}
		}
	}


	public void sendAppPush(Map<String, Object> params, String message) throws Exception {
		List<Map<String, Object>> appPushList = (List<Map<String, Object>>) getApprovalAppPushList(params);
		List<String> empKeys = appPushList.stream()
				.map(map -> (String) map.get("empKey"))
				.collect(Collectors.toList());

		pushService.sendPushMessage("", empKeys, message);
	}

	private boolean useNotification(HttpSession session) {
		String ssnNotificationUseYn = StringUtil.nvl((String) session.getAttribute("ssnNotificationUseYn"), "N");
		return "Y".equals(ssnNotificationUseYn);
	}
}