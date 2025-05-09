package com.hr.cpn.payCalculate.payAggrSta;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 급여집계(직급/부서별) Service
 *
 * @author JM
 *
 */
@Service("PayAggrStaService")
public class PayAggrStaService{
	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 급여집계(직급/부서별) 수당집계TAB 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPayAggrStaAllowanceTotalList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return (List<?>) dao.getList("getPayAggrStaAllowanceTotalList", paramMap);
	}

	/**
	 * 급여집계(직급/부서별) 공제집계TAB 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPayAggrStaDeductionTotalList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return (List<?>) dao.getList("getPayAggrStaDeductionTotalList", paramMap);
	}

	/**
	 * 급여집계(직급/부서별) 직급집계TAB 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPayAggrStaJikgubTotalList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return (List<?>) dao.getList("getPayAggrStaJikgubTotalList", paramMap);
	}
	
	/**
	 * 급여집계(직급/부서별) 부서집계TAB 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPayAggrStaOrgTotalList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return (List<?>) dao.getList("getPayAggrStaOrgTotalList", paramMap);
	}
}