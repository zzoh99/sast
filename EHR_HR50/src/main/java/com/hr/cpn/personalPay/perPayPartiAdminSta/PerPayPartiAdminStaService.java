package com.hr.cpn.personalPay.perPayPartiAdminSta;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 개인별급여세부내역(관리자) Service
 *
 * @author JM
 *
 */
@Service("PerPayPartiAdminStaService")
public class PerPayPartiAdminStaService{
	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 개인별급여세부내역(관리자) 최근급여일자 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getAdminLatestPaymentInfoMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return dao.getMap("getAdminLatestPaymentInfoMap", paramMap);
	}

	/**
	 * 개인별급여세부내역(관리자) 계산내역TAB 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPerPayPartiAdminStaList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return (List<?>) dao.getList("getPerPayPartiAdminStaList", paramMap);
	}

	/**
	 * 개인별급여세부내역(관리자) 계산내역TAB 세금내역 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getPerPayPartiAdminStaTaxMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return dao.getMap("getPerPayPartiAdminStaTaxMap", paramMap);
	}

	/**
	 * 개인별급여세부내역(관리자) 기타내역TAB 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPerPayPartiAdminStaEtcList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return (List<?>) dao.getList("getPerPayPartiAdminStaEtcList", paramMap);
	}

	/**
	 * 개인별급여세부내역(관리자) 항목세부내역TAB 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPerPayPartiAdminStaDtlList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return (List<?>) dao.getList("getPerPayPartiAdminStaDtlList", paramMap);
	}
}