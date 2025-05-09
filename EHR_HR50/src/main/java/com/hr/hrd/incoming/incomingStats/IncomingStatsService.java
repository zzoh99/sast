package com.hr.hrd.incoming.incomingStats;

import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

@Service("IncomingStatsService")
public class IncomingStatsService{

	@Inject
	@Named("Dao")
	private Dao dao;


	public List<?> getIncomingStatsList(Map<?, ?> paramMap, String searchType) throws Exception {
		Log.DebugStart();

		String queryId = "getIncomingStatsList" + searchType;
		return (List<?>)dao.getList(queryId, paramMap);
	}

	/**
	 * 공동조직장 조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public Map<?, ?> getIncomingStatsDualChief(Map<?, ?> paramMap) throws Exception {
		Log.DebugStart();
		return dao.getMap("getOrgSchemeIBOrgSrchDualChief", paramMap);
	}
}