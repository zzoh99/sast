package com.hr.hrm.other.empInfoChangeTableMgr;

import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

@Service("EmpInfoChangeTableMgrService")
public class EmpInfoChangeTableMgrService {
	
	@Inject
	@Named("Dao")
	private Dao dao;
	
	public List<?> getEmpInfoChangeTableMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>)dao.getList("getEmpInfoChangeTableMgrList", paramMap);
	}
	
	public int saveEmpInfoChangeTableMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteEmpInfoChangeTableMgr", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveEmpInfoChangeTableMgr", convertMap);
		}
		Log.Debug();
		return cnt;
	}
	
}
