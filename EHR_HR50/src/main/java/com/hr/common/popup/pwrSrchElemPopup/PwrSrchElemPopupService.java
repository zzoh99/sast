package com.hr.common.popup.pwrSrchElemPopup;

import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

@Service("PwrSrchElemPopupService") 
public class PwrSrchElemPopupService{
 
	@Inject
	@Named("Dao")
	private Dao dao;
	
	public List<?> getPwrSrchElemPopupList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>)dao.getList("getPwrSrchElemPopupList", paramMap);
	}	
}