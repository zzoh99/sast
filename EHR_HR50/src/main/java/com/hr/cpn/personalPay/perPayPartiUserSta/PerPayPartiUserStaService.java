package com.hr.cpn.personalPay.perPayPartiUserSta;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 월별급여지급현황 Service
 *
 * @author JM
 *
 */
@Service("PerPayPartiUserStaService")
public class PerPayPartiUserStaService{
	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 월별급여지급현황 최근급여일자 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getLatestPaymentInfoMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return dao.getMap("getLatestPaymentInfoMap", paramMap);
	}

	/**
	 * 월별급여지급현황 계산내역TAB 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPerPayPartiUserStaList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return (List<?>) dao.getList("getPerPayPartiUserStaList", paramMap);
	}

	/**
	 * 월별급여지급현황 계산내역TAB 지급/공제항목 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPerPayPartiUserStaCalcList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return (List<?>) dao.getList("getPerPayPartiUserStaCalcList", paramMap);
	}

	/**
	 * 월별급여지급현황 계산내역TAB 과표항목 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPerPayPartiUserStaCalcTaxList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return (List<?>) dao.getList("getPerPayPartiUserStaCalcTaxList", paramMap);
	}

	/**
	 * 월별급여지급현황 계산내역TAB 비과세항목 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPerPayPartiUserStaCalcTaxFreeList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return (List<?>) dao.getList("getPerPayPartiUserStaCalcTaxFreeList", paramMap);
	}

	/**
	 * 월별급여지급현황 계산내역TAB 세금내역 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getPerPayPartiUserStaTaxMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return dao.getMap("getPerPayPartiUserStaTaxMap", paramMap);
	}

	/**
	 * 월별급여지급현황 기타내역TAB 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPerPayPartiUserStaEtcList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return (List<?>) dao.getList("getPerPayPartiUserStaEtcList", paramMap);
	}

	/**
	 * 월별급여지급현황 항목세부내역TAB 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPerPayPartiUserStaDtlList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return (List<?>) dao.getList("getPerPayPartiUserStaDtlList", paramMap);
	}
}