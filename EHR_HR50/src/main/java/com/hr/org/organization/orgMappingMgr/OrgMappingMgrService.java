package com.hr.org.organization.orgMappingMgr;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.com.ComUtilService;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * orgMappingMgr Service
 *
 * @author EW
 *
 */
@Service("OrgMappingMgrService")
public class OrgMappingMgrService extends ComUtilService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * orgMappingMgr 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getOrgMappingMgrSheet1List(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getOrgMappingMgrSheet1List", paramMap);
	}

	/**
	 * orgMappingMgr 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getOrgMappingMgrSheet2List1(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getOrgMappingMgrSheet2List1", paramMap);
	}

	/**
	 * orgMappingMgr 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getOrgMappingMgrSheet2List2(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getOrgMappingMgrSheet2List2", paramMap);
	}

	/**
	 * orgMappingMgr 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveOrgMappingMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteOrgMappingMgr", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveOrgMappingMgr", convertMap);
		}

		//EDATE 자동생성 2020.06.03 
		prcComEdateCreate(convertMap, "TORG107", "orgCd", "mapTypeCd", "mapCd");

		return cnt;
	}
	/**
	 * orgMappingMgr 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getOrgMappingMgrDupCheckMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getOrgMappingMgrDupCheckMap", paramMap);
		Log.Debug();
		return resultMap;
	}
}
