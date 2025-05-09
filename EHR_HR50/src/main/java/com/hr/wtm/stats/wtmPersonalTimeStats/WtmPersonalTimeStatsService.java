package com.hr.wtm.stats.wtmPersonalTimeStats;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import javax.inject.Named;
import java.util.List;
import java.util.Map;

/**
 * 부서원근태현황 Service
 *
 * @author bckim
 *
 */
@Service("WtmPersonalTimeStatsService")
public class WtmPersonalTimeStatsService {

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 부서원근태현황 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getWtmPersonalTimeStatsList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getWtmPersonalTimeStatsList", paramMap);
	}

	/**
	 * 근태코드(헤더) 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getWtmPersonalTimeStatsHeaderList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getWtmPersonalTimeStatsHeaderList", paramMap);
	}
	
	public List<?> getWtmPersonalTimeStatsOrgList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getWtmPersonalTimeStatsOrgList", paramMap);
	}	
}