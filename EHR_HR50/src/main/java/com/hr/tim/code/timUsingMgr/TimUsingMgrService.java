package com.hr.tim.code.timUsingMgr;
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
@Service("TimUsingMgrService")  
public class TimUsingMgrService{
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
	public List<?> getTimUsingMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getTimUsingMgrList", paramMap);
	}
	
	/**
	 * 시스템사용기준관리 저장 Service
	 * 
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveTimUsingMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteTimUsingMgr", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveTimUsingMgr", convertMap);
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
	public int deleteTimUsingMgr(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.delete("deleteTimUsingMgr", paramMap);
	}
}