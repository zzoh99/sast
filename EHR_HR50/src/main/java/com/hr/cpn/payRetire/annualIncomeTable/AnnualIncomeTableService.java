package com.hr.cpn.payRetire.annualIncomeTable;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 연간소득현황 Service
 *
 * @author EW
 *
 */
@Service("AnnualIncomeTableService")
public class AnnualIncomeTableService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 연간소득현황 헤더 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getAnnualIncomeCodeList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getAnnualIncomeCodeList", paramMap);
	}
	
	/**
	 * 연간소득현황 헤더 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getAnnualIncomeTableHeaderList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getAnnualIncomeTableHeaderList", paramMap);
	}

	/**
	 * 연간소득현황 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getAnnualIncomeTableList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getAnnualIncomeTableList", paramMap);
	}
}
