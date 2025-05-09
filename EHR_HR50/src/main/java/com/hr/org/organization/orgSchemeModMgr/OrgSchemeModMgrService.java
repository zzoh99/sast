package com.hr.org.organization.orgSchemeModMgr;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 조직도수정관리 Service
 *
 * @author EW
 *
 */
@Service("OrgSchemeModMgrService")
public class OrgSchemeModMgrService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 조직도수정관리 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getOrgSchemeModMgrLeftList(Map<?, ?> paramMap) throws Exception { 
		Log.Debug();
		return (List<?>) dao.getList("getOrgSchemeModMgrLeftList", paramMap);
	}

	/**
	 * 조직도수정관리 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveOrgSchemeModMgrLeft(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteOrgSchemeModMgrLeft", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveOrgSchemeModMgrLeft", convertMap);
		}

		return cnt;
	}
	/**
	 * 조직도수정관리 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getOrgSchemeModMgrLeftMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getOrgSchemeModMgrLeftMap", paramMap);
		Log.Debug();
		return resultMap;
	}
	/**
	 * 조직도수정관리 프로시저 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> orgSchemeModMgrPrc(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (Map<?, ?>) dao.excute("orgSchemeModMgrPrc", paramMap);
	}
}
