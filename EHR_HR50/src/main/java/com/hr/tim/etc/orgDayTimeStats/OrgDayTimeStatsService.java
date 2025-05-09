package com.hr.tim.etc.orgDayTimeStats;
import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 부서원근태현황 Service
 *
 * @author bckim
 *
 */
@Service("OrgDayTimeStatsService")
public class OrgDayTimeStatsService{

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
	public List<?> getOrgDayTimeStatsList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getOrgDayTimeStatsList", paramMap);
	}

	/**
	 * 근태코드(헤더) 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getOrgDayTimeStatsHeaderList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getOrgDayTimeStatsHeaderList", paramMap);
	}
	
	public List<?> getOrgDayTimeStatsOrgList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getOrgDayTimeStatsOrgList", paramMap);
	}	
}