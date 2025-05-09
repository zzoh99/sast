package com.hr.hrm.successor.succPsnalEmp;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * succEmpMgr Service
 *
 * @author EW
 *
 */
@Service("SuccPsnalEmpService")
public class SuccPsnalEmpService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * getSuccPsnalEmpOrgList 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getSuccPsnalEmpOrgList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getSuccPsnalEmpOrgList", paramMap);
	}
	
	/**
	 * getSuccPsnalEmpUserList 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getSuccPsnalEmpUserList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getSuccPsnalEmpUserList", paramMap);
	}
	
	/**
	 * succEmpMgr 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getSuccPsnalEmpList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getSuccPsnalEmpList", paramMap);
	}

	/**
	 * succEmpMgr 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveSuccPsnalEmp(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteSuccPsnalEmp", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveSuccPsnalEmp", convertMap);
		}

		return cnt;
	}
	/**
	 * succEmpMgr 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getSuccPsnalEmpMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getSuccPsnalEmpMap", paramMap);
		Log.Debug();
		return resultMap;
	}
	/**
	 * succEmpMgr 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getSuccEmpMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getSuccPsnalEmpMap2", paramMap);
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
	public int saveSuccPsnalEmpUserList(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteSuccPsnalEmpUserList", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveSuccPsnalEmpUserList", convertMap);
		}

		return cnt;
	}
}
