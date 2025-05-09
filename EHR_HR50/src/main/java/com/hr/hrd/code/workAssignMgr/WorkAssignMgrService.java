package com.hr.hrd.code.workAssignMgr;

import com.hr.common.dao.Dao;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import javax.inject.Named;
import java.util.List;
import java.util.Map;

@Service("WorkAssignMgrService")
public class WorkAssignMgrService {
	@Inject
	@Named("Dao")
	private Dao dao;

	public List<?> getWorkAssignMgrList(Map<?, ?> paramMap) throws Exception {
		return (List<?>) dao.getList("getWorkAssignMgrList", paramMap);
	}

	public int saveWorkAssignMgrList(Map<?, ?> convertMap) throws Exception {
	int cnt=0;

		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteWorkAssignMgrList", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveWorkAssignMgrList", convertMap);
		}

		return cnt;
	}


}
