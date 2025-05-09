package com.hr.pap.config.appElementMgr;

import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 평가차수반영비율 Service
 * 
 * @author JCY
 *
 */
@Service("AppElementMgrService")  
public class AppElementMgrService{
 
	@Inject
	@Named("Dao")
	private Dao dao;
	
	/**
	 *  평가차수반영비율 단건 조회 Service 
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getAppElementMgrMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getAppElementMgrMap", paramMap);
		Log.Debug();
		return resultMap;
	}
	/**
	 * 평가차수반영비율 저장 Service
	 * 
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveAppElementMgrTab1(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteAppElementMgrTab1", convertMap);
			cnt += dao.delete("deleteAppElementMgrTab1_1", convertMap);
			
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveAppElementMgrTab1", convertMap);
		}
		Log.Debug();
		return cnt;
	}
		


	
	/**
	 * 평가차수반영비율 저장 Service
	 * 
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveAppElementMgrTab2(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteAppElementMgrTab2", convertMap);
			cnt += dao.delete("deleteAppElementMgrTab2_1", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveAppElementMgrTab2", convertMap);
		}
		Log.Debug();
		return cnt;
	}

}