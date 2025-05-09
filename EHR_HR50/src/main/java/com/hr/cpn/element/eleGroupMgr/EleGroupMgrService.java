package com.hr.cpn.element.eleGroupMgr;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 텍스트파일생성목록 Service
 * 
 * @author 이름
 *
 */
@Service("EleGroupMgrService")  
public class EleGroupMgrService{
	@Inject
	@Named("Dao")
	private Dao dao;
	/**
	 * 텍스트파일생성목록 다건 조회 Service First
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getEleGroupMgrListFirst(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getEleGroupMgrListFirst", paramMap);
	}	
	
	/**
	 * 텍스트파일생성목록 다건 조회 Service Second
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getEleGroupMgrListSecond(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getEleGroupMgrListSecond", paramMap);
	}
	/**
	 *  텍스트파일생성목록 단건 조회 Service 
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getEleGroupMgrMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getEleGroupMgrMap", paramMap);
	}
	/**
	 * 텍스트파일생성목록 저장 Service
	 * 
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveEleGroupMgrFirst(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteEleGroupMgrFirst", convertMap);
			cnt += dao.delete("deleteEleGroupMgrSecondCasCading", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveEleGroupMgrFirst", convertMap);
		}
		Log.Debug();
		return cnt;
	}
	
	/**
	 * 텍스트파일생성목록 저장 Service
	 * 
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveEleGroupMgrSecond(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteEleGroupMgrSecond", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveEleGroupMgrSecond", convertMap);
		}
		Log.Debug();
		return cnt;
	}
	

}