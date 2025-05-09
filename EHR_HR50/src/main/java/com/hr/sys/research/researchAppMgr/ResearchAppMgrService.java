package com.hr.sys.research.researchAppMgr;

import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

@Service("ResearchAppMgrService")
public class ResearchAppMgrService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * getResearchAppMgrList 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getResearchAppMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getResearchAppMgrList", paramMap);
	}
	
}