package com.hr.sys.mail.mailSmsMgr;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * MailSmsMgr Service
 *
 * @author 이름
 *
 */
@Service("MailSmsMgrService")
public class MailSmsMgrService{
	@Inject
	@Named("Dao")
	private Dao dao;
	
	/**
	 * 단건 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?,?> getMailSmsMgrMap(String queryId, Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (Map<?,?>) dao.getMap(queryId, paramMap);
	}
	
	/**
	 * 저장 Service
	 * 
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveMailSmsMgr(String queryId, Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("delete"+queryId, convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("save"+queryId, convertMap);
		}
		
		return cnt;
	}
	
	/**
	 * 저장 Service
	 * 
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveMailSmsMgr1(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteMailSmsMgr1",  convertMap);
			cnt += dao.delete("deleteMailSmsMgr11", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveMailSmsMgr1", convertMap);
		}
		
		return cnt;
	}
	
	/**
	 * 저장 Service
	 * 
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int updateMailSmsMgr(String queryId, Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt = dao.update(queryId, convertMap);
		return cnt;
	}
	
	/**
	 * CLOB  저장 Service
	 * 
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int updateMailSmsMgrClob(String queryId, Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt = dao.updateClob(queryId, convertMap);
		
		return cnt;
	}	
	
	
	/**
	 * 프로시저호출
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?,?> prcMailSmsMgr(String queryId, Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (Map<?,?>) dao.excute(queryId, paramMap);
	}
	

}