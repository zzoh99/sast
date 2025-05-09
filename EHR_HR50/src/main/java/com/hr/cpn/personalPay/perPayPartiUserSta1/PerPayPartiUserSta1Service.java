package com.hr.cpn.personalPay.perPayPartiUserSta1;
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
@Service("PerPayPartiUserSta1Service")
public class PerPayPartiUserSta1Service{
	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 월별급여지급현황 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<String, Object> getPerPayPartiUserSta1Map(String queryId, Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return (Map<String, Object>) dao.getMap(queryId, paramMap);
	}

	/**
	 * 월별급여지급현황 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPerPayPartiUserSta1List(String queryId, Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return (List<?>) dao.getList(queryId, paramMap);
	}
}