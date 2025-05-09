package com.hr.tim.etc.orgYearStats;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 부서원연차사용현황 Service
 *
 * @author bckim
 *
 */
@Service("OrgYearStatsService")
public class OrgYearStatsService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 부서원연차사용현황(조직 코드) 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getOrgYearStatsOrgList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getOrgYearStatsOrgList", paramMap);
	}
	
	/**
	 * 부서원연차사용현황(조직 코드) 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getOrgYearStatsOrgListAdmin(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getOrgYearStatsOrgListAdmin", paramMap);
	}	
}