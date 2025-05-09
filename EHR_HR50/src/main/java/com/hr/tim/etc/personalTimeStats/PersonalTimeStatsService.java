package com.hr.tim.etc.personalTimeStats;
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
@Service("PersonalTimeStatsService")
public class PersonalTimeStatsService{

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
	public List<?> getPersonalTimeStatsList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getPersonalTimeStatsList", paramMap);
	}

	/**
	 * 근태코드(헤더) 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPersonalTimeStatsHeaderList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getPersonalTimeStatsHeaderList", paramMap);
	}
	
	public List<?> getPersonalTimeStatsOrgList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getPersonalTimeStatsOrgList", paramMap);
	}	
}