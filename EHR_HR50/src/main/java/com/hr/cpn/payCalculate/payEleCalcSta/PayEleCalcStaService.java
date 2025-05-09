package com.hr.cpn.payCalculate.payEleCalcSta;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 항목별계산내역 Service
 *
 * @author JM
 *
 */
@Service("PayEleCalcStaService")
public class PayEleCalcStaService{
	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 항목별계산내역 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPayEleCalcStaList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return (List<?>) dao.getList("getPayEleCalcStaList", paramMap);
	}
	
	/**
	 * 항목별계산내역 (Report명) 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPayEleCalcStaByReportNmList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return (List<?>) dao.getList("getPayEleCalcStaByReportNmList", paramMap);
	}
}