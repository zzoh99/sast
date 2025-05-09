package com.hr.sys.system.selfMgr;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
import com.nhncorp.lucy.security.xss.XssPreventer;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import javax.inject.Named;
import java.util.List;
import java.util.Map;
/**
 * 시스템사용기준관리 Service
 * 
 * @author CBS
 *
 */
@Service("SelfMgrService")
public class SelfMgrService {
	@Inject
	@Named("Dao")
	private Dao dao;
	/**
	 * 시스템사용기준관리 다건 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getSelfMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getSelfMgrList", paramMap);
	}
	
	/**
	 * 시스템사용기준관리 저장 Service
	 * 
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveSelfMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteSelfMgr", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveSelfMgr", convertMap);
		}
		Log.Debug();
		return cnt;
	}

	public int updateSelfMgrClob(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		int cnt = dao.update("updateSelfMgrClob", paramMap);
		return cnt;
	}

	public int saveSelfMgrClob(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveSelfMgrClob", convertMap);
		}
		Log.Debug();
		return cnt;
	}

	/**
	 * 시스템사용기준관리 삭제 Service
	 * 
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int deleteSelfMgr(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.delete("deleteSelfMgr", paramMap);
	}
}