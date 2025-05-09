package com.hr.sys.security.outUserReg;

import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

@Service("OutUserRegService") 
public class OutUserRegService{
 
	@Inject
	@Named("Dao")
	private Dao dao;
	
	/**
	 * 외부사용자  다건 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getOutUserRegList(Map<String, Object> paramMap) throws Exception {
		Log.Debug();
		return (List<?>)dao.getList("getOutUserRegList", paramMap);
	}	
	
	/**
	 * 외부사용자-중복체크  단건 조회 Service
	 * 
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?,?> getOutUserRegPopMap(Map<String, Object> paramMap) throws Exception {
		Log.Debug();
		return (Map<?,?>) dao.getMap("getOutUserRegPopMap", paramMap);
	}
	
	/**
	 * 외부사용자  저장 Service
	 * 
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveOutUserReg(Map<String, Object> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			Log.Debug();
			cnt += dao.delete("deleteOutUserReg100", convertMap);
			cnt += dao.delete("deleteOutUserReg124", convertMap);
			cnt += dao.delete("deleteOutUserReg151", convertMap);
			cnt += dao.delete("deleteOutUserReg305", convertMap);
			cnt += dao.delete("deleteOutUserReg313", convertMap);
			cnt += dao.delete("deleteOutUserReg911", convertMap);
		}
		
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			Log.Debug();
			cnt += dao.update("saveOutUserReg100", convertMap);
			cnt += dao.update("saveOutUserReg124", convertMap);
			cnt += dao.update("saveOutUserReg151", convertMap);
			cnt += dao.update("saveOutUserReg305", convertMap);
			cnt += dao.update("saveOutUserReg313", convertMap);
			cnt += dao.update("saveOutUserReg911", convertMap);
		}
		
		return cnt;
	}	
}