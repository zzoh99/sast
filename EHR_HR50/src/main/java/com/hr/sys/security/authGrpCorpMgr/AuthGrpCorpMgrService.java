package com.hr.sys.security.authGrpCorpMgr;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 권한별회사관리 Service
 *
 * @author 이름
 *
 */
@Service("AuthGrpCorpMgrService")
public class AuthGrpCorpMgrService{
	@Inject
	@Named("Dao")
	private Dao dao;
	/**
	 * 권한별회사관리 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getAuthGrpCorpMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getAuthGrpCorpMgrList", paramMap);
	}
	/**
	 * 권한별회사관리 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveAuthGrpCorpMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteAuthGrpCorpMgr", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveAuthGrpCorpMgr", convertMap);
		}
		Log.Debug();
		return cnt;
	}
}