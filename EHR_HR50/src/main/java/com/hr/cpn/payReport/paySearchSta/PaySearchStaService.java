package com.hr.cpn.payReport.paySearchSta;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 급/상여대장검색(개인별) Service
 *
 * @author JM
 *
 */
@Service("PaySearchStaService")
public class PaySearchStaService{
	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 급/상여대장검색(개인별) 급여구분별 항목리스트 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPaySearchStaTitleList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return (List<?>) dao.getList("getPaySearchStaTitleList", paramMap);
	}

	/**
	 * 급/상여대장검색(개인별) 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPaySearchStaList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return (List<?>) dao.getList("getPaySearchStaList", paramMap);
	}

	/**
	 * 급/상여대장검색(개인별) 급여구분 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPaySearchStaCpnPayCdList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return (List<?>) dao.getList("getPaySearchStaCpnPayCdList", paramMap);
	}
}