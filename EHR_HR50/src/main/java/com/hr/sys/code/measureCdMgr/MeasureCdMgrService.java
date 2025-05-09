package com.hr.sys.code.measureCdMgr;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 척도관리 Service
 * 
 * @author CBS
 *
 */
@Service("MeasureCdMgrService")  
public class MeasureCdMgrService{
	@Inject
	@Named("Dao")
	private Dao dao;
	/**
	 * 척도관리 다건 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getMeasureCdMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getMeasureCdMgrList", paramMap);
	}
	
	/**
	 * 척도관리 저장 Service
	 * 
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveMeasureCdMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteMeasureCdMgr", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveMeasureCdMgr", convertMap);
		}
		Log.Debug();
		return cnt;
	}
	
	/**
	 * 척도관리 삭제 Service
	 * 
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int deleteMeasureCdMgr(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.delete("deleteMeasureCdMgr", paramMap);
	}
	
	/**
	 * 척도세부코드관리 다건 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getMeasureDetailCdMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getMeasureDetailCdMgrList", paramMap);
	}
	
	/**
	 * 척도세부코드관리 저장 Service
	 * 
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveMeasureDetailCdMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteMeasureDetailCdMgr", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveMeasureDetailCdMgr", convertMap);
		}
		Log.Debug();
		return cnt;
	}
	
	/**
	 * 척도세부코드관리 삭제 Service
	 * 
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int deleteMeasureDetailCdMgr(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.delete("deleteMeasureDetailCdMgr", paramMap);
	}	
}