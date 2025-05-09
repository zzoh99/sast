package com.hr.common.popup.payAllowanceElementPropertyPopup;

import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;


@Service("PayAllowanceElementPropertyPopupService") 
public class PayAllowanceElementPropertyPopupService{
 
	@Inject
	@Named("Dao")
	private Dao dao;
	
	/**
	 * 공통팝업 PayAllowanceElementPropertyPopupService 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPayAllowanceElementPropertyPopupListFirst(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getPayAllowanceElementPropertyPopupListFirst", paramMap);
	}
	
	/**
	 * 공통팝업 PayAllowanceElementPropertyPopupService 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPayAllowanceElementPropertyPopupListSecond(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getPayAllowanceElementPropertyPopupListSecond", paramMap);
	}
	
	/**
	 * 공통팝업 PayAllowanceElementPropertyPopupService 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPayAllowanceElementPropertyPopupListThird(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getPayAllowanceElementPropertyPopupListThird", paramMap);
	}
}