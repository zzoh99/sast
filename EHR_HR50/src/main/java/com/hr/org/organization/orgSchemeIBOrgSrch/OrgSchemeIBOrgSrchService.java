package com.hr.org.organization.orgSchemeIBOrgSrch;

import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

@Service("OrgSchemeIBOrgSrchService")
public class OrgSchemeIBOrgSrchService{

	@Inject
	@Named("Dao")
	private Dao dao;


	public List<?> getOrgSchemeIBOrgSrchList(Map<?, ?> paramMap, String searchType) throws Exception {
		Log.DebugStart();
		return (List<?>)dao.getList("getOrgSchemeIBOrgSrchList"+searchType, paramMap);
	}

	/**
	 * 공동조직장 조회
	 * @param paramMap
	 * @param searchType
	 * @return
	 * @throws Exception
	 */
	public Map<?, ?> getOrgSchemeIBOrgSrchDualChief(Map<?, ?> paramMap) throws Exception {
		Log.DebugStart();
		return dao.getMap("getOrgSchemeIBOrgSrchDualChief", paramMap);
	}
	
	/**
	 * 팀원 조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public List<?> getOrgSchemeIBOrgSrchMemberList(Map<?, ?> paramMap) throws Exception {
		Log.DebugStart();
		return (List<?>) dao.getList("getOrgSchemeIBOrgSrchMemberList", paramMap);
	}
}