package com.hr.pap.evaluation.appEval;

import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;
import org.springframework.util.ObjectUtils;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 평가수행 Service
 * 
 * @author JCY
 *
 */
@Service("AppEvalService")  
public class AppEvalService{
 
	@Inject
	@Named("Dao")
	private Dao dao;
	
	
	/**
	 * getAppEvalComboList 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getAppEvalComboList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getAppEvalComboList", paramMap);
	}
	
	/**
	 * getAppSelfEvalList 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getAppSelfEvalList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getAppSelfEvalList", paramMap);
	}
	
	/**
	 * getAppOtherEvalList 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getAppOtherEvalList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getAppOtherEvalList", paramMap);
	}	
	
	/**
	 * getAppEvalSrhList 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getAppEvalList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getAppEvalList", paramMap);
	}
	
	/**
	 * getOtherEvalListPopupList1 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getOtherEvalListPopupList1(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getOtherEvalListPopupList1", paramMap);
	}	
	
	/**
	 * getOtherEvalDetailPopupUserList 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getOtherEvalDetailPopupUserList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getOtherEvalDetailPopupUserList", paramMap);
	}
	
	/**
	 * getAppEvalComboList 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getAppGuideList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getAppGuideList", paramMap);
	}
	
	/**
	 * getOtherEvalDetailPopupItemList 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getOtherEvalDetailPopupItemList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getOtherEvalDetailPopupItemList", paramMap);
	}
	
	/**
	 * getOtherEvalDetailPopupSchList 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getOtherEvalDetailPopupSchList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getOtherEvalDetailPopupSchList", paramMap);
	}
	
	/**
	 * getAppSelfEvalAppClassList 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getAppSelfEvalAppClassList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getAppSelfEvalAppClassList", paramMap);
	}
	
	/**
	 * 상세팝업 저장
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveOtherEvalDetailPopup(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		
		if ("05".equalsIgnoreCase(String.valueOf(convertMap.get("appTypeCd")))) { // 평가자평가 1차
			if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
				cnt += dao.update("saveAppEvalOtherEvalBySelfEvalItem", convertMap);
			}
			cnt += dao.update("saveOtherEvalDetailPopup", convertMap);
			dao.update("updateOtherEvalAppGroupByApp1stRk", convertMap);
		} else {
			cnt += dao.update("saveOtherEvalDetailPopup", convertMap);
		}
		
		if ("agree".equalsIgnoreCase(String.valueOf(convertMap.get("action")))) { // 합의 다음상태로
			dao.update("saveAppEvalUserAppStatusAgree", convertMap);
			dao.update("saveAppEvalUserEvalItemHistMap", convertMap);
		} else if ("reject".equalsIgnoreCase(String.valueOf(convertMap.get("action")))) { // 반려 이전상태로
			dao.update("saveAppEvalUserAppStatusReject", convertMap);
		}
		
		return cnt;
	}
	
	
	/**
	 * 상세팝업 저장(평가자평가2차)
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveOtherEvalDetailPopup2(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		List<Map<String, Object>> tempList = ((List<Map<String, Object>>)convertMap.get("mergeRows"));
		if (!ObjectUtils.isEmpty(tempList) && tempList.size() > 0) {
			for (int i=0; i<tempList.size(); i++) {
				Map<String, Object> tempMap = tempList.get(i);
				tempMap.put("appTypeCd", convertMap.get("appTypeCd"));
				cnt += dao.update("saveOtherEvalDetailPopup", tempMap);
			}
		}
		
		if ("agree".equalsIgnoreCase(String.valueOf(convertMap.get("action")))) { // 합의 다음상태로 2차평가완료시 그룹에 해당하는 피평가자를 업데이트	
			cnt += dao.update("saveAppEvalUserAppStatusAgree2", convertMap);
		} 
		return cnt;		
	}
	
	/**
	 * getSelfEvalListPopupList1 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getSelfEvalListPopupList1(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getSelfEvalListPopupList1", paramMap);
	}	
	

	/**
	 * getSelfEvalDetailPopupUserList 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getSelfEvalDetailPopupUserList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getSelfEvalDetailPopupUserList", paramMap);
	}


	/**
	 * getSelfEvalDetailPopupSchList 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getSelfEvalDetailPopupSchList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getSelfEvalDetailPopupSchList", paramMap);
	}
	
	/**
	 * getSelfEvalDetailPopupItemList 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getSelfEvalDetailPopupItemList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getSelfEvalDetailPopupItemList", paramMap);
	}	
	
	/**
	 * 자기평가 상세팝업 저장
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveSelfEvalDetailPopup(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
				
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.update("deleteAppEvalSelfEvalItem", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt = dao.update("saveAppEvalSelfEvalItem", convertMap);

			List<Map<String, Object>> tempMerge = ((List<Map<String, Object>>)convertMap.get("mergeRows"));
			List<Map<String, Object>> tempItem = (List<Map<String, Object>>) getSelfEvalDetailPopupItemList(convertMap);

			for (int i=0; i<tempMerge.size(); i++) {
				Map<String, Object> merge = tempMerge.get(i);
				merge.put("ssnEnterCd", convertMap.get("ssnEnterCd"));
				merge.put("ssnSabun", convertMap.get("ssnSabun"));
				for (int j=0; j<tempItem.size(); j++) {
					Map<String, Object> item = tempItem.get(j);
					if (String.valueOf(merge.get("weight")).equals(String.valueOf(item.get("weight"))) && 
							String.valueOf(merge.get("compGrpNm")).equalsIgnoreCase(String.valueOf(item.get("compGrpNm"))) &&
							String.valueOf(merge.get("compNm")).equalsIgnoreCase(String.valueOf(item.get("compNm")))) {
						merge.put("seq", item.get("seq"));
					}
				}
				
				String clobSql = "";
				if ("A0".equalsIgnoreCase(String.valueOf(convertMap.get("appStatus")))) {
					clobSql = "saveAppEvalSelfEvalItemMboTarget";
					merge.put("clobText", String.valueOf(merge.get("mboTarget")));
				} else if ("D0".equalsIgnoreCase(String.valueOf(convertMap.get("appStatus")))) {
					clobSql = "saveAppEvalSelfEvalItemAppMidResult";
					merge.put("clobText", String.valueOf(merge.get("appMidResult")));
				} else if ("C0".equalsIgnoreCase(String.valueOf(convertMap.get("appStatus")))) {
					clobSql = "saveAppEvalSelfEvalItemMboAppFinResult";
					merge.put("clobText", String.valueOf(merge.get("appFinResult")));
				}
				cnt += dao.updateClob(clobSql, merge);
			}
			// 자기평가 - 본평가일시 평가관리마스터 테이블의 자기평가점수를 업데이트 한다.
			if ("C0".equalsIgnoreCase(String.valueOf(convertMap.get("appStatus")))) {
				dao.update("updateSelfEvalAppSelfScrTotal", convertMap);
			}
		}
	
		if ("agree".equalsIgnoreCase(String.valueOf(convertMap.get("action")))) { // 합의 다음상태로
			cnt += dao.update("saveAppEvalUserAppStatusAgree", convertMap);
			dao.update("saveAppEvalUserEvalItemHistMap", convertMap);
		} else if ("reject".equalsIgnoreCase(String.valueOf(convertMap.get("action")))) { // 반려 해당진행반려상태로
			cnt +=dao.update("saveAppEvalUserAppStatusReject", convertMap);
		} else if ("update".equalsIgnoreCase(String.valueOf(convertMap.get("action")))) { // 목표수정 목표작성중으로
			cnt +=dao.update("saveAppEvalUserAppStatusUpdate", convertMap);
		} 
		
		return cnt;
	}	
}