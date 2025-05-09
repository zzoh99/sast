package com.hr.hrd.code.shrOfcWrkMgr;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

import org.springframework.stereotype.Service;

import javax.inject.Inject;
import javax.inject.Named;
import java.util.List;
import java.util.Map;

@Service("ShrOfcWrkMgrService")
public class ShrOfcWrkMgrService {
	@Inject
	@Named("Dao")
	private Dao dao;

	public List<?> getShrOfcWrkMgrList(Map<?, ?> paramMap) throws Exception {
		return (List<?>) dao.getList("getShrOfcWrkMgrList", paramMap);
	}

	public int saveShrOfcWrkMgrList(Map<?, ?> convertMap) throws Exception {
	int cnt=0;

		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteShrOfcWrkMgrList", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveShrOfcWrkMgrList", convertMap);
		}

		return cnt;
	}
	
	public Map prcShrOfcWrkMgr(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (Map) dao.excute("prcShrOfcWrkMgr", paramMap);
	}


}
