package com.hr.sys.system.requirement.reqDefinitionMgr;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 요구사항관리 Service
 *
 * @author EW
 *
 */
@Service("ReqDefinitionMgrService")
public class ReqDefinitionMgrService{ 

	@Inject
	@Named("Dao")
	private Dao dao; 

	/**
	 * 요구사항관리 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getReqDefinitionMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getReqDefinitionMgrList", paramMap);
	}
	
	/**
	 * 요구사항관리 팝업 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getReqDefinitionMgrPopList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getReqDefinitionMgrPopList", paramMap);
	}
	
	/**
	 * 요구사항관리 단건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getReqDefinitionMgrPopErrorAccYnMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getReqDefinitionMgrPopErrorAccYnMap", paramMap);
	}

	/**
	 * 요구사항관리 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveReqDefinitionMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteReqDefinitionMgr", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveReqDefinitionMgr", convertMap);
		}

		return cnt;
	}
	

	/**
	 * 요구사항관리 생성 프로시저
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map procP_SYS_REQ_CRE(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (Map) dao.excute("procP_SYS_REQ_CRE", paramMap);
	}

	/**
	 * PL, 개발자 리스트 가져오기
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public List<?> getReqManagerList(Map<String, Object> paramMap) throws Exception {
	    return (List<?>) dao.getList("getReqManagerList",paramMap);
	}
}
