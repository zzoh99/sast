package com.hr.hrm.empContract.empContractEleMgr;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 계약서항목관리 Service
 *
 * @author EW
 *
 */
@Service("EmpContractEleMgrService")
public class EmpContractEleMgrService{

	@Inject
	@Named("Dao")
	private Dao dao;
	
	/**
	 * 계약서항목 조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public List<?> getEmpContractEleMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getEmpContractEleMgrList", paramMap);
	}

	/**
	 * 계약서항목관리 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveEmpContractEleMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteEmpContractEleMgr", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveEmpContractEleMgr", convertMap);
		}

		return cnt;
	}
}
