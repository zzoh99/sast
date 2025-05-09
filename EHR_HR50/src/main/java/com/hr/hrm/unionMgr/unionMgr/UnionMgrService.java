package com.hr.hrm.unionMgr.unionMgr;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * UnionMgr Service
 *
 * @author EW
 *
 */
@Service("UnionMgrService")
public class UnionMgrService{

	@Inject
	@Named("Dao")
	private Dao dao;
	
	/**
	 * 노조관리 저장
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveUnionMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteUnionMgr", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveUnionMgr", convertMap);
		}

		return cnt;
	}
}
