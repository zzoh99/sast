package com.hr.common.popup.payElementPopup;

import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;


@Service("PayElementPopupService") 
public class PayElementPopupService{
 
	@Inject
	@Named("Dao")
	private Dao dao;
	
	/**
	 * 급여항목검색 팝업 PayElementPopup 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPayElementList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getPayElementList", paramMap);
	}

	/**
	 * 급여항목검색 팝업 PayElementPopup 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPayElementAllList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getPayElementAllList", paramMap);
	}

	/**
	 * 급여항목검색 팝업 PayElementPopup 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPayElement1List(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getPayElement1List", paramMap);
	}
	
	/**
	 * 급여항목검색(소급) 팝업 PayElementPopup 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getRetroElementList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getRetroElementList", paramMap);
	}

	/**
	 * 급여항목검색(퇴직) 팝업 PayElementPopup 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getSepElementList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getSepElementList", paramMap);
	}

	/**
	 * 급여항목검색 팝업 PayElementPopup 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPayElementCallPageList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getPayElementCallPageList", paramMap);
	}	
}