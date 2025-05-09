package com.hr.pap.intern.internEval;

import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 수습평가 Service
 *
 * @author JSG
 *
 */
@Service("InternEvalService")
public class InternEvalService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * getInternEvalComboList 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getInternEvalComboList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getInternEvalComboList", paramMap);
	}
	
	/**
	 * getInternGuideList 다건 조회 Service 
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getInternGuideList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getInternGuideList", paramMap);
	}
	
	/**
	 * getAppSelfEvalList 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getInternSelfEvalList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getInternSelfEvalList", paramMap);
	}
	
	/**
	 * getAppOtherEvalList 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getInternOtherEvalList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getInternOtherEvalList", paramMap);
	}
	
	/**
	 * getInternSelfEvalDetailPopupList 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getInternSelfEvalDetailPopupList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getInternSelfEvalDetailPopupList", paramMap);
	}
	
	/**
	 * getInternSelfEvalDetailPopupList 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getInternSelfEvalDetailPopupList2(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getInternSelfEvalDetailPopupList2", paramMap);
	}
	
	/**
	 * getInternSelfEvalDetailPopupList 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getInternOtherEvalObservePopupList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getInternOtherEvalObservePopupList", paramMap);
	}
	
	/**
	 * getInternSelfEvalDetailPopupList2 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getInternOtherEvalObservePopupList2(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getInternOtherEvalObservePopupList2", paramMap);
	}
	
	/**
	 * getInternSelfEvalDetailPopupList2 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getInternOtherEvalObservePopupList2Default(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getInternOtherEvalObservePopupList2Default", paramMap);
	}
	
	/**
	 * getInternOtherEvalSheetUserMap 다건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getInternOtherEvalSheetUserMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getInternOtherEvalSheetUserMap", paramMap);
	}
	
	/**
	 * getInternOtherEvalSheetSchMap 다건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getInternOtherEvalSheetSchMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getInternOtherEvalSheetSchMap", paramMap);
	}
	
	
	/**
	 * getInternOtherEvalSheetListPopupList 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getInternOtherEvalSheetListPopupList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getInternOtherEvalSheetListPopupList", paramMap);
	}
	
	/**
	 * getInternOtherEvalSheetListPopupListDefault 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getInternOtherEvalSheetListPopupListDefault(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getInternOtherEvalSheetListPopupListDefault", paramMap);
	}	
	
	/**
	 * 주간일지 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveInternSelfEvalDetailPopup(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveInternSelfEvalDetailPopup", convertMap);
			
			List<Map<String, Object>> tempMerge = ((List<Map<String, Object>>)convertMap.get("mergeRows"));
			for (int i=0; i<tempMerge.size(); i++) {
				Map<String, Object> merge = tempMerge.get(i);
				merge.put("ssnEnterCd", convertMap.get("ssnEnterCd"));
				merge.put("ssnSabun", convertMap.get("ssnSabun"));				
				dao.updateClob("saveInternSelfEvalDetailPopupClob", merge);
			}
			cnt += dao.update("saveInternSelfEvalDetailPopupAppStatCd", convertMap);
		}

		Log.Debug();
		return cnt;
	}
	
	/**
	 * 주간일지확인 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveInternSelfEvalDetailPopup2(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveInternSelfEvalDetailPopup2", convertMap);
			cnt += dao.update("saveInternSelfEvalDetailPopupAppStatCd2", convertMap);
		}

		Log.Debug();
		return cnt;
	}
	
	/**
	 * 수습평가 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveInternEval(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteInternEval", convertMap);
			//cnt += dao.delete("deleteAppEvaluateeMng1Sub", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveInternEval", convertMap);
		}

		Log.Debug();
		return cnt;
	}
	
	/**
	 * 관찰표 및 종합의견 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveInternOtherEvalObservePopup(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveInternOtherEvalObservePopup", convertMap);
		}
		cnt += dao.update("saveInternOtherEvalObservePopupAppStatCd", convertMap);

		Log.Debug();
		return cnt;
	}
	
	/**
	 * 수습평가표 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveInternOtherEvalSheetListPopup(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveInternOtherEvalSheetListPopup", convertMap);
		}
		cnt += dao.update("saveInternOtherEvalSheetListPopupAppStatCd", convertMap);
		if ("Agree".equals(convertMap.get("action"))) { // 최종확정시 피평가자 업데이트
			dao.excute("prcInternAppFinUpdate", convertMap);
		}
		Log.Debug();
		return cnt;
	}
}
