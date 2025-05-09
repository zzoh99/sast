package com.hr.cpn.payRetire.sepCalcResultSta;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 퇴직금결과내역 Service
 *
 * @author JM
 *
 */
@Service("SepCalcResultStaService")
public class SepCalcResultStaService{
	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 퇴직금결과내역 기본사항TAB 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getSepCalcResultStaBasicMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return dao.getMap("getSepCalcResultStaBasicMap", paramMap);
	}

	/**
	 * 퇴직금결과내역 평균임금TAB 급여 항목리스트 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getSepCalcResultStaAverageIncomePayTitleList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return (List<?>) dao.getList("getSepCalcResultStaAverageIncomePayTitleList", paramMap);
	}

	/**
	 * 퇴직금결과내역 평균임금TAB 급여 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getSepCalcResultStaAverageIncomePayList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return (List<?>) dao.getList("getSepCalcResultStaAverageIncomePayList", paramMap);
	}

	/**
	 * 퇴직금결과내역 평균임금TAB 상여 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getSepCalcResultStaAverageIncomeBonusList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return (List<?>) dao.getList("getSepCalcResultStaAverageIncomeBonusList", paramMap);
	}

	/**
	 * 퇴직금결과내역 평균임금TAB 연차 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getSepCalcResultStaAverageIncomeAnnualList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return (List<?>) dao.getList("getSepCalcResultStaAverageIncomeAnnualList", paramMap);
	}

	/**
	 * 퇴직금결과내역 퇴직금계산내역TAB 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getSepCalcResultStaSeverancePayCalcList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return (List<?>) dao.getList("getSepCalcResultStaSeverancePayCalcList", paramMap);
	}

	/**
	 * 퇴직금결과내역 퇴직종합정산TAB 지급내역 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getSepCalcResultStaRetireCalcPayList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return (List<?>) dao.getList("getSepCalcResultStaRetireCalcPayList", paramMap);
	}

	/**
	 * 퇴직금결과내역 퇴직종합정산TAB 공제내역 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getSepCalcResultStaRetireCalcDeductionList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return (List<?>) dao.getList("getSepCalcResultStaRetireCalcDeductionList", paramMap);
	}

	/**
	 * 퇴직금결과내역 전근무지사항TAB 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getSepCalcResultStaBeforeWorkMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return dao.getMap("getSepCalcResultStaBeforeWorkMap", paramMap);
	}
}