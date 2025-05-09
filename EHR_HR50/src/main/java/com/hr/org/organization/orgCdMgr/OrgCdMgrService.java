package com.hr.org.organization.orgCdMgr;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * orgCdMgr Service
 *
 * @author EW
 *
 */
@Service("OrgCdMgrService")
public class OrgCdMgrService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * orgCdMgr 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getOrgCdMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getOrgCdMgrList", paramMap);
	}

	/**
	 * orgCdMgr 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveOrgCdMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteOrgCdMgr", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveOrgCdMgr", convertMap);
		}

		return cnt;
	}

	/**
	 * orgCdMgr 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getOrgCdMgrMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getOrgCdMgrMap", paramMap);
		Log.Debug();
		return resultMap;
	}
}
