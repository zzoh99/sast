package com.hr.cpn.payReport.payActionSta;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 급/상여대장검색(일자별) Service
 *
 * @author JM
 *
 */
@Service("PayActionStaService")
public class PayActionStaService{
	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 급/상여대장검색(일자별) 급여구분별 항목리스트 다건 조회 Service
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
	 * 급/상여대장검색(일자별) 급여구분별 항목리스트 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPayActionStaTitleList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		
		return (List<?>) dao.getList("getPayActionStaTitleList", paramMap);
	}

	/**
	 * 급/상여대장검색(일자별) 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPayActionStaList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return (List<?>) dao.getList("getPayActionStaList", paramMap);
	}
}