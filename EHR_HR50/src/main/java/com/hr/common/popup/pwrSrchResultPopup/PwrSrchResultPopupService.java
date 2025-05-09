package com.hr.common.popup.pwrSrchResultPopup;

import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;


@Service("PwrSrchResultPopupService") 
public class PwrSrchResultPopupService{
 
	@Inject
	@Named("Dao")
	private Dao dao;
	
	/**
	 * 공통팝업 IBSheetCols 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPwrSrchResultPopupIBSheetColsList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getPwrSrchResultPopupIBSheetColsList", paramMap);
	}
	
	
	/**
	 * 공통팝업 Query Result 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getPwrSrchResultPopupQueryMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getPwrSrchResultPopupQueryMap", paramMap);
	}
	
	/**
	 * 공통팝업 Query Result 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getPwrSrchResultPopupResulCntMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getPwrSrchResultPopupResulCntMap", paramMap);
	}
	
	/**
	 * 공통팝업 Query Result 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPwrSrchResultPopupResultList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getPwrSrchResultPopupResultList", paramMap);
	}
	
	/**
	 * 공통팝업 Query Result Down Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPwrSrchResultPopupResultDown(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>)dao.getList("getPwrSrchResultPopupResultDown", paramMap);
	}
	
	/**
	 * 공통팝업 Result 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPwrSrchResultPopupList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getPwrSrchResultPopupList", paramMap);
	}
	
	/**
	 * 공통팝업 ElemDetail 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getPwrSrchResultPopupElemDetailList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getPwrSrchResultPopupElemDetailList", paramMap);
	}
	
	/**
	 * 공통팝업 Condition 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPwrSrchResultPopupConditionList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getPwrSrchResultPopupConditionList", paramMap);
	}
	
	/**
	 * 공통팝업 Query Result 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPwrSrchResultPopupQueryResultList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getPwrSrchResultPopupQueryResultList", paramMap);
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