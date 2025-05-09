package com.hr.sys.system.requirement.reqDefinitionPopMgr;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 테스트관리 Service
 *
 * @author EW
 * 
 */
@Service("ReqDefinitionPopMgrService")
public class ReqDefinitionPopMgrService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 테스트관리 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getReqDefinitionPopMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getReqDefinitionPopMgrList", paramMap);
	}

	/**
	 * 테스트관리 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveReqDefinitionPopMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteReqDefinitionPopMgr", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveReqDefinitionPopMgr", convertMap);
		}

		return cnt;
	}
}
