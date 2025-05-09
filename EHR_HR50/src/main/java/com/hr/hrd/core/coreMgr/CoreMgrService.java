package com.hr.hrd.core.coreMgr;

import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

@Service("CoreMgrService")
public class CoreMgrService{

	@Inject
	@Named("Dao")
	private Dao dao;

	public List<?> getCoreMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>)dao.getList("getCoreMgrList", paramMap);
	}

	/**
	 * 핵심인재관리 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveCoreMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();

		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteCoreMgr", convertMap);			
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveCoreMgr", convertMap);
		}

		Log.Debug();
		return cnt;
	}
}