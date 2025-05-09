package com.hr.hrm.other.empList;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import javax.inject.Named;
import java.util.List;
import java.util.Map;

/**
 * 인원명부항목정의 Service
 *
 * @author 이름
 *
 */
@Service("EmpListService")
public class EmpListService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 인원명부항목정의 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveEmpListColMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			for(Map paramMap : (List<Map<?,?>>) convertMap.get("deleteRows")) {
				cnt += dao.update("deleteEmpListColMgr", paramMap);
			}
		}
		
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			for(Map paramMap : (List<Map<?,?>>) convertMap.get("mergeRows")) {
				cnt += dao.update("saveEmpListColMgr", paramMap);
			}
		}
		Log.Debug();
		return cnt;
	}
	
	/**
	 * getEmpListColMgrTitleList 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getEmpListColMgrTitleList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getEmpListColMgrTitleList", paramMap);
	}
	
	/**
	 * getEmpListColMgrList 다건 조회 Service
	 * 사용안함 20240719 jyp
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
//	public List<?> getEmpListColMgrList(Map<?, ?> paramMap) throws Exception {
//		Log.Debug();
//		return (List<?>) dao.getList("getEmpListColMgrList", paramMap);
//	}
//
	/**
	 * getEmpListColAttrMgrList 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getEmpListColAttrMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getEmpListColAttrMgrList", paramMap);
	}
	
	/**
	 * 인원명부TITLE 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getEmpListTitleList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getEmpListTitleList", paramMap);
	}
	
	/**
	 * 인원명부 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getEmpListList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getEmpListList", paramMap);
	}

	/**
	 * saveEmpListColAttrMgr 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public int saveEmpListColAttrMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
				for(Map paramMap : (List<Map<?,?>>) convertMap.get("mergeRows")) {
					cnt += dao.update("saveEmpListColAttrMgr", paramMap);
				}
			}
		}
		return cnt;
	}
	
	/**
	 * 컬럼 추가 저장 Service
	 * @param convertMap
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public int addEmpListItem(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			for(Map paramMap : (List<Map<?,?>>) convertMap.get("mergeRows")) {
				paramMap.put("GRP_CD", convertMap.get("searchGrpCd"));
				paramMap.put("USE_YN", "Y");
				cnt += dao.update("saveEmpListColMgr", paramMap);
			}
		}
		Log.Debug();
		return cnt;
	}

	/**
	 * 인원명부항목관리 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public int saveEmpListItemMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			for(Map paramMap : (List<Map<?,?>>) convertMap.get("deleteRows")) {
				paramMap.put("GRP_CD", convertMap.get("searchGrpCd"));
				cnt += dao.update("deleteEmpListColMgr", paramMap);
			}
		}
		
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			for(Map paramMap : (List<Map<?,?>>) convertMap.get("mergeRows")) {
				cnt += dao.update("saveEmpListColAttrMgr", paramMap);
			}
		}
		Log.Debug();
		return cnt;
	}

}