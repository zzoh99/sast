package com.hr.org.capacity.orgJikgubCapaMgr;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * orgJikgubCapaMgr Service
 *
 * @author EW
 *
 */
@Service("OrgJikgubCapaMgrService")
public class OrgJikgubCapaMgrService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * orgJikgubCapaMgr 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getOrgJikgubCapaMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getOrgJikgubCapaMgrList", paramMap);
	}

	/**
	 * getOrgJikgubCapaMgrSheet1List 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getOrgJikgubCapaMgrSheet1List(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getOrgJikgubCapaMgrSheet1List", paramMap);
	}
	
	/**
	 * getOrgJikgubCapaMgrSheet2List 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getOrgJikgubCapaMgrSheet2List(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getOrgJikgubCapaMgrSheet2List", paramMap);
	}	
	
	/**
	 * orgJikgubCapaMgr 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveOrgJikgubCapaMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteOrgJikgubCapaMgr", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveOrgJikgubCapaMgr", convertMap);
		}

		return cnt;
	}
	/**
	 * orgJikgubCapaMgr 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getOrgJikgubCapaMgrMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getOrgJikgubCapaMgrMap", paramMap);
		Log.Debug();
		return resultMap;
	}
	
	/**
	 *  조직별 직급별 현인원 조회 Service 
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getNowCnt(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getNowCnt", paramMap);
	}		
}
