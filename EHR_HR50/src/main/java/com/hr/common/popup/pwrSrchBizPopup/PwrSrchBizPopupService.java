package com.hr.common.popup.pwrSrchBizPopup;
import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

@Service("PwrSrchBizPopupService") 
public class PwrSrchBizPopupService{
	
	@Inject
	@Named("Dao")
	private Dao dao;
	
	/**
	 * 검색조건 설정 팝업 Query Result 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List getPwrSrchBizPopupViewElemList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List)dao.getList("getPwrSrchBizPopupViewElemList", paramMap);
	}
	
	
	/**
	 * 검색조건 설정 팝업 Query Result 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List getPwrSrchBizPopupElemList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List)dao.getList("getPwrSrchBizPopupElemList", paramMap);
	}
	
	/**
	 * 검색조건 설정 팝업 Element 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPwrSrchBizPopupConditionList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getPwrSrchBizPopupConditionList", paramMap);
	}
	
	/**
	 * 검색조건 설정 팝업 SQL EMPTY 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public int updatePwrSrchBizPopupSqlEmpty(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.update("updatePwrSrchBizPopupSqlEmpty", paramMap);
	}
	
	/**
	 * 검색조건 설정 팝업팝업 SQL 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public int updatePwrSrchBizPopupSql(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.update("updatePwrSrchBizPopupSql", paramMap);
	}
	
	/**
	 * 검색조건 설정 팝업팝업 SQL DESC 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public int updatePwrSrchBizPopupSqlDesc(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.update("updatePwrSrchBizPopupSqlDesc", paramMap);
	}
	
	/**
	 * 검색조건 설정 팝업팝업 ELEM 저장 Service
	 * 
	 * @param convertMap
	 * @return List
	 * @throws Exception
	 */
	public int savePwrSrchBizPopupElem(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt = dao.delete("deletePwrSrchBizPopupElem", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("savePwrSrchBizPopupElem", convertMap);
		}
		Log.Debug();
		return cnt;
	}
	
	/**
	 * 검색조건 설정 팝업팝업 ELEM 저장 Service
	 * 
	 * @param convertMap
	 * @return List
	 * @throws Exception
	 */
	public int savePwrSrchBizPopupCondition(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt = dao.delete("deletePwrSrchBizPopupCondition", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("savePwrSrchBizPopupCondition", convertMap);
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
	public List getPwrSrchBizPopupResultList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List)dao.getList("getPwrSrchBizPopupResultList", paramMap);
	}
	
	/**
	 * 공통팝업 Result 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPwrSrchBizPopupList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getPwrSrchBizPopupList", paramMap);
	}
	
	

	
	/**
	 * 공통팝업 Query Result 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPwrSrchBizPopupQueryResultList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getPwrSrchBizPopupQueryResultList", paramMap);
	}
	
	/**
	 * 공통팝업 쿼리 조회 
	 * 
	 * @param queryId
	 * @return String
	 * @throws Exception
	 */
	public String getQueryInfo(String queryId) throws Exception {
		return dao.getStatement(queryId);
    }
}