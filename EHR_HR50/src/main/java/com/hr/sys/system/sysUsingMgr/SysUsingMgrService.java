package com.hr.sys.system.sysUsingMgr;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 시스템사용기준관리 Service
 * 
 * @author CBS
 *
 */
@Service("SysUsingMgrService")  
public class SysUsingMgrService{
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
	public List<?> getSysUsingMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getSysUsingMgrList", paramMap);
	}
	
	/**
	 * 시스템사용기준관리 저장 Service
	 * 
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveSysUsingMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteSysUsingMgr", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveSysUsingMgr", convertMap);
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
	public int deleteSysUsingMgr(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.delete("deleteSysUsingMgr", paramMap);
	}
}