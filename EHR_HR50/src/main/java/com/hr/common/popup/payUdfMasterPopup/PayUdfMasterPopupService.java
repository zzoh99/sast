package com.hr.common.popup.payUdfMasterPopup;

import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;


@Service("PayUdfMasterPopupService") 
public class PayUdfMasterPopupService{
 
	@Inject
	@Named("Dao")
	private Dao dao;
	
	/**
	 * 공통팝업 PayUdfMasterPopup 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPayUdfMasterList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getPayUdfMasterList", paramMap);
	}
}