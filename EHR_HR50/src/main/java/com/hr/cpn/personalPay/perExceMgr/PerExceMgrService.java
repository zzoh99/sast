package com.hr.cpn.personalPay.perExceMgr;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 개인별예외관리 Service
 * 
 * @author 이름
 *
 */
@Service("PerExceMgrService")  
public class PerExceMgrService{
	@Inject
	@Named("Dao")
	private Dao dao;
	/**
	 * 개인별예외관리 다건 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPerExceMgrFirstList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getPerExceMgrFirstList", paramMap);
	}	
	public List<?> getPerExceMgrSecondList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getPerExceMgrSecondList", paramMap);
	}	
	/**
	 *  개인별예외관리 단건 조회 Service 
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getPerExceMgrMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getPerExceMgrMap", paramMap);
	}
	/**
	 * 개인별예외관리 저장 Service
	 * 
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int savePerExceMgrFirst(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deletePerExceMgrFirst", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			
			// Detail TCPN110
			cnt += dao.update("savePerExceMgrFirstDetail", convertMap);
			
			// Master TCPN109
			cnt += dao.update("savePerExceMgrFirstMaster", convertMap);
		}
		Log.Debug();
		return cnt;
	}
	
	/**
	 * 개인별예외관리 저장 Service
	 * 
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int savePerExceMgrSecond(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deletePerExceMgrSecond", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			
			// Detail TCPN110
			cnt += dao.update("savePerExceMgrSecondDetail", convertMap);
			
			// Master TCPN109
			cnt += dao.update("savePerExceMgrSecondMaster", convertMap);
		}
		Log.Debug();
		return cnt;
	}
	


}