package com.hr.hrm.empAccMgr;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * EmpAccMgr Service
 *
 * @author EW
 *
 */
@Service("EmpAccMgrService")
public class EmpAccMgrService{

	@Inject
	@Named("Dao")
	private Dao dao;
	
	/**
	 * 사우회관리 저장
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveEmpAccMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteEmpAccMgr", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveEmpAccMgr", convertMap);
		}

		return cnt;
	}
}
