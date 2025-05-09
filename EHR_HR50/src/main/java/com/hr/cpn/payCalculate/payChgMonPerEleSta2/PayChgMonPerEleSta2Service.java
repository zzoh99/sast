package com.hr.cpn.payCalculate.payChgMonPerEleSta2;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 급여변동내역(개인별-항목별) Service
 *
 * @author JM
 *
 */
@Service("PayChgMonPerEleSta2Service")
public class PayChgMonPerEleSta2Service{
	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 급여변동내역(개인별-항목별) 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPayChgMonPerEleSta2List(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return (List<?>) dao.getList("getPayChgMonPerEleSta2List", paramMap);
	}
	
	public List<Map<String, String>> getPayChgMonPerEleSta2TitleList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return (List<Map<String, String>>) dao.getList("getPayChgMonPerEleSta2TitleList", paramMap);
	}
	
	public List<?> getPayChgMonPerEleMltSta2List(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return (List<?>) dao.getList("getPayChgMonPerEleMltSta2List", paramMap);
	}
}