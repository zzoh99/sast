package com.hr.hrm.successor.succEmpProfile;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * succEmpProfile Service
 *
 * @author EW
 *
 */
@Service("SuccEmpProfileService")
public class SuccEmpProfileService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * getSuccEmpProfileOrgList 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getSuccEmpProfileOrgList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getSuccEmpProfileOrgList", paramMap);
	}
	
	/**
	 * getSuccEmpProfileUserList 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getSuccEmpProfileUserList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getSuccEmpProfileUserList", paramMap);
	}
	
	/**
	 * succEmpProfile 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getSuccEmpProfileList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getSuccEmpProfileList", paramMap);
	}

	/**
	 * succEmpProfile 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveSuccEmpProfile(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteSuccEmpProfile", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveSuccEmpProfile", convertMap);
		}

		return cnt;
	}
	/**
	 * succEmpProfile 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getSuccEmpProfileMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getSuccEmpProfileMap", paramMap);
		Log.Debug();
		return resultMap;
	}
	/**
	 * succEmpProfile 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getSuccEmpMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getSuccEmpMap", paramMap);
		Log.Debug();
		return resultMap;
	}
	
	/**
	 * 퇴직설문항목관리 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveSuccEmpProfileUserList(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteSuccEmpProfileUserList", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveSuccEmpProfileUserList", convertMap);
		}

		return cnt;
	}
}
