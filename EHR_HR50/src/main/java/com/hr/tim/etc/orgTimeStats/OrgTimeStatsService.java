package com.hr.tim.etc.orgTimeStats;
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
@Service("OrgTimeStatsService")
public class OrgTimeStatsService{

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
	public List<?> getOrgTimeStatsList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getOrgTimeStatsList", paramMap);
	}

	/**
	 * 근태코드(헤더) 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getOrgTimeStatsHeaderList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getOrgTimeStatsHeaderList", paramMap);
	}
}