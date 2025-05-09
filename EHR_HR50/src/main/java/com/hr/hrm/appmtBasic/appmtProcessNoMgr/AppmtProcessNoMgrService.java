package com.hr.hrm.appmtBasic.appmtProcessNoMgr;

import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

@Service("AppmtProcessNoMgrService")
public class AppmtProcessNoMgrService {
	
	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public List<?> getAppmtProcessNoMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getAppmtProcessNoMgrList", paramMap);
	}
	
	/**
	 * 
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public Object getAppmtProcessNoSeq(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<String, ?> result =  (Map<String, ?>)dao.getMap("getAppmtProcessNoSeq", paramMap);
		Object resultObj = null;
		if(result != null) {
			resultObj = result.get("processNoSeq");
		}
		
		return resultObj;
	}
	
	/**
	 * 
	 * @param convertMap
	 * @return
	 * @throws Exception
	 */
	public int saveAppmtProcessNoMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteAppmtProcessNoMgr", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveAppmtProcessNoMgr", convertMap);
		}
		Log.Debug();
		return cnt;
	}

}
