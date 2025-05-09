package com.hr.common.popup.empProfilePopup;

import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;


@Service("EmpProfilePopupService")
public class EmpProfilePopupService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 *  개인신상 단건 조회 Service 
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getEmpProfile(Map<?, ?> paramMap) throws Exception {
		Log.Debug("getEmpProfile");
		return dao.getMap("getEmpProfile", paramMap);
	}
}