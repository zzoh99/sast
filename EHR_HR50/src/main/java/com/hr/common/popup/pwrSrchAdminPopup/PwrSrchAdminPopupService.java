package com.hr.common.popup.pwrSrchAdminPopup;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import javax.inject.Named;
import java.util.List;
import java.util.Map;

@Service("PwrSrchAdminPopupService") 
public class PwrSrchAdminPopupService{
	
	@Inject
	@Named("Dao")
	private Dao dao;
	
	/**
	 * 검색조건 결과 팝업 ElemDetail 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List getPwrSrchAdminPopupElemDetailList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List) dao.getList("getPwrSrchAdminPopupElemDetailList", paramMap);
	}
	
	/**
	 * 검색조건 결과 팝업 Query Result 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List getPwrSrchAdminPopupElemList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List)dao.getList("getPwrSrchAdminPopupElemList", paramMap);
	}
	
	/**
	 * 검색조건 결과 팝업 Condition 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPwrSrchAdminPopupConditionList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getPwrSrchAdminPopupConditionList", paramMap);
	}
	
	/**
	 * 검색조건 결과 팝업 Condition 조회 -- @@ OR && 변수 중 선택해서 조회할 수 있도록 처리 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPwrSrchAdminPopupConditionListVar(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getPwrSrchAdminPopupConditionListVar", paramMap);
	}
	
	/**
	 * 검색조건 결과 팝업 SQL EMPTY 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public int updatePwrSrchAdminPopupSqlEmpty(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		dao.update("insertPwrSrchAdminPopupSqlHist", paramMap); //2020.09.01 SQL이력 저장
		return dao.update("updatePwrSrchAdminPopupSqlEmpty", paramMap);
	}
	
	/**
	 * 검색조건 결과 팝업팝업 SQL 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public int updatePwrSrchAdminPopupSql(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.updateClob("updatePwrSrchAdminPopupSql", paramMap);
	}
	
	/**
	 * 검색조건 결과 팝업팝업 SQL DESC 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public int updatePwrSrchAdminPopupSqlDesc(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.update("updatePwrSrchAdminPopupSqlDesc", paramMap);
	}
	
	/**
	 * 검색조건 결과 팝업팝업 ELEM 저장 Service
	 * 
	 * @param convertMap
	 * @return Int
	 * @throws Exception
	 */
	public int savePwrSrchAdminPopupElem(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt = dao.delete("deletePwrSrchAdminPopupElem", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("savePwrSrchAdminPopupElem", convertMap);
		}
		Log.Debug();
		return cnt;
	}
	
	/**
	 * 검색조건 결과 팝업팝업 ELEM 저장 Service
	 * 
	 * @param convertMap
	 * @return List
	 * @throws Exception
	 */
	public int savePwrSrchAdminPopupCondition(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt = dao.delete("deletePwrSrchAdminPopupCondition", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("savePwrSrchAdminPopupCondition", convertMap);
		}
		Log.Debug();
		return cnt;
	}
	
	/**
	 * 공통팝업 Query Result 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	//20240717 jyp 193라인까지 주석
//	public List getPwrSrchAdminPopupResultList(Map<?, ?> paramMap) throws Exception {
//		Log.Debug();
//		return (List)dao.getList("getPwrSrchAdminPopupResultList", paramMap);
//	}
	
	/**
	 * 공통팝업 Result 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
//	public List<?> getPwrSrchAdminPopupList(Map<?, ?> paramMap) throws Exception {
//		Log.Debug();
//		return (List<?>) dao.getList("getPwrSrchAdminPopupList", paramMap);
//	}
	
	

	
	/**
	 * 공통팝업 Query Result 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
//	public List<?> getPwrSrchAdminPopupQueryResultList(Map<?, ?> paramMap) throws Exception {
//		Log.Debug();
//		return (List<?>) dao.getList("getPwrSrchAdminPopupQueryResultList", paramMap);
//	}
	
	/**
	 * 공통팝업 쿼리 조회 
	 * 
	 * @param queryId
	 * @return String
	 * @throws Exception
	 */
//	public String getQueryInfo(String queryId) throws Exception {
//		return dao.getStatement(queryId);
//    }
}