package com.hr.hrm.empContract.empContractMgr;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 근로계약서관리 Service
 *
 * @author sjk
 *
 */
@Service("EmpContractMgrService")
public class EmpContractMgrService{
	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * getEmpContractMgrList 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getEmpContractMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getEmpContractMgrList", paramMap);
	}
	
	/**
	 * 근로계약서관리 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveEmpContractMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt = 0;
		
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteEmpContractMgr", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveEmpContractMgr", convertMap);
		}
		
		Log.Debug();
		return cnt;
	}
	
	
	/**
	 * 검색조건 결과 팝업 SQL EMPTY 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public int saveEmpContractMgrContentsEmpty(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.update("saveEmpContractMgrContentsEmpty", paramMap);
	}
	
	/**
	 * 근로계약서관리 Contents 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveEmpContractMgrContents(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt = dao.updateClob("saveEmpContractMgrContents", convertMap);
		Log.Debug();
		return cnt;
	}
}