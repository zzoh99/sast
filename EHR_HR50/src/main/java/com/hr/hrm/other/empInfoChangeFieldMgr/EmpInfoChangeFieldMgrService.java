package com.hr.hrm.other.empInfoChangeFieldMgr;

import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

@Service("EmpInfoChangeFieldMgrService")
public class EmpInfoChangeFieldMgrService {
	
	@Inject
	@Named("Dao")
	private Dao dao;
	
	public List<?> getEmpInfoChangeFieldMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>)dao.getList("getEmpInfoChangeFieldMgrList", paramMap);
	}
	
	public int saveEmpInfoChangeFieldMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteEmpInfoChangeFieldMgr", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveEmpInfoChangeFieldMgr", convertMap);
		}
		Log.Debug();
		return cnt;
	}
}
