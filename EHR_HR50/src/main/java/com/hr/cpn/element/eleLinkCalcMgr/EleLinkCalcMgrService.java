package com.hr.cpn.element.eleLinkCalcMgr;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * eleLinkCalcMgr Service
 *
 * @author EW
 *
 */
@Service("EleLinkCalcMgrService")
public class EleLinkCalcMgrService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * eleLinkCalcMgr 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getEleLinkCalcMgrFirstList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getEleLinkCalcMgrFirstList", paramMap);
	}
	
	/**
	 * eleLinkCalcMgr 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getEleLinkCalcMgrSecondList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getEleLinkCalcMgrSecondList", paramMap);
	}

	/**
	 * eleLinkCalcMgr 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveEleLinkCalcMgrFirst(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteEleLinkCalcMgrFirst", convertMap);
			dao.delete("deleteEleLinkCalcMgrThird", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveEleLinkCalcMgrFirst", convertMap);
		}

		return cnt;
	}
	
	/**
	 * eleLinkCalcMgr 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveEleLinkCalcMgrSecond(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteEleLinkCalcMgrSecond", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveEleLinkCalcMgrSecond", convertMap);
		}
		
		return cnt;
	}
	
	/**
	 * eleLinkCalcMgr 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getEleLinkCalcMgrMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getEleLinkCalcMgrMap", paramMap);
		Log.Debug();
		return resultMap;
	}
}
