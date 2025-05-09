package com.hr.sys.system.dbItemMgr;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * DB Item관리 Service
 * 
 * @author CBS
 *
 */
@Service("DbItemMgrService")  
public class DbItemMgrService{
	@Inject
	@Named("Dao")
	private Dao dao;
	/**
	 * DB Item관리 다건 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getDbItemMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getDbItemMgrList", paramMap);
	}
	
	/**
	 * DB Item관리 저장 Service
	 * 
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveDbItemMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteDbItemMgr", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveDbItemMgr", convertMap);
		}
		Log.Debug();
		return cnt;
	}
	
	/**
	 * DB Item관리 삭제 Service
	 * 
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int deleteDbItemMgr(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.delete("deleteDbItemMgr", paramMap);
	}
}