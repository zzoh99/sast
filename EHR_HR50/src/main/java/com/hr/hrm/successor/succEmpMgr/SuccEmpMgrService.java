package com.hr.hrm.successor.succEmpMgr;
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
@Service("SuccEmpMgrService")
public class SuccEmpMgrService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * getSuccEmpMgrOrgList 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getSuccEmpMgrOrgList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getSuccEmpMgrOrgList", paramMap);
	}
	
	/**
	 * getSuccEmpMgrUserList 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getSuccEmpMgrUserList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getSuccEmpMgrUserList", paramMap);
	}
	
	/**
	 * succEmpMgr 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getSuccEmpMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getSuccEmpMgrList", paramMap);
	}

	/**
	 * succEmpMgr 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveSuccEmpMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteSuccEmpMgr", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveSuccEmpMgr", convertMap);
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
	public Map<?, ?> getSuccEmpMgrMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getSuccEmpMgrMap", paramMap);
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
	public int saveSuccEmpMgrUserList(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteSuccEmpMgrUserList", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveSuccEmpMgrUserList", convertMap);
		}

		return cnt;
	}
	
    
    /**
    * 대상자생성 프로시저 Service
    *
    * @param paramMap
    * @return Map
    * @throws Exception
    */
   public Map<?, ?> callP_HRM_SUCCESSOR_EMP_CRE(Map<?, ?> paramMap) throws Exception {
       Log.Debug();
       return (Map<?, ?>) dao.excute("callP_HRM_SUCCESSOR_EMP_CRE", paramMap);
   }
}
