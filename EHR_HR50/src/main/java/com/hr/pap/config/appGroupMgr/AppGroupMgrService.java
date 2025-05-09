package com.hr.pap.config.appGroupMgr;

import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 평가그룹설정 Service
 * 
 * @author JSG
 *
 */
@Service("AppGroupMgrService")  
public class AppGroupMgrService{
 
	@Inject
	@Named("Dao")
	private Dao dao;
	
	/**
	 * 평가그룹설정 다건 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getAppGroupMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		List<?> resultList = (List<?>)dao.getList("getAppGroupMgrList", paramMap);
		Log.Debug();
		return resultList;
	}	
	
	/**
	 *  평가그룹설정 단건 조회 Service 
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getAppGroupMgrMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getAppGroupMgrMap", paramMap);
		Log.Debug();
		return resultMap;
	}
	
	/**
	 *  평가그룹설정 단건 조회 Service 
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getAppGroupMgrCreateChk(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getAppGroupMgrCreateChk", paramMap);
		Log.Debug();
		return resultMap;
	}
	
	/**
	 * 평가그룹설정 저장 Service
	 * 
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveAppGroupMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteAppGroupMgr", convertMap);
			cnt += dao.delete("deleteAppGroupMgr991", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveAppGroupMgr", convertMap);
		}
		Log.Debug();
		return cnt;
	}
	/**
	 * 평가그룹설정 생성 Service
	 * 
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int insertAppGroupMgr(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		int cnt = dao.create("insertAppGroupMgr", paramMap);
		Log.Debug();
		return cnt;
	}
	/**
	 * 평가그룹설정 수정 Service
	 * 
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int updateAppGroupMgr(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		int cnt = dao.update("updateAppGroupMgr", paramMap);
		Log.Debug();
		return cnt;
	}
	/**
	 * 평가그룹설정 삭제 Service
	 * 
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int deleteAppGroupMgr(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		int cnt = dao.delete("deleteAppGroupMgr", paramMap);
		Log.Debug();
		return cnt;
	}
	
	/**
	 * 평가그룹설정 - 기초평가그룹생성 - 프로시저
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map prcAppGroupMgr(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (Map) dao.excute("prcAppGroupMgr", paramMap);
	}
	
	/**
	 * 면접조관리 -면접조 생성 - 프로시저
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map prcAppGroupMgrCopyPop(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (Map) dao.excute("prcAppGroupMgrCopyPop", paramMap);
	}
	
	public List<?> getAppGroupMgrScopeCd(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		List<?> resultList = (List<?>)dao.getList("getAppGroupMgrScopeCd", paramMap);
		Log.Debug();
		return resultList;
	}
	
	public List<?> getAppGroupMgrTblNm(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		List<?> resultList = (List<?>)dao.getList("getAppGroupMgrTblNm", paramMap);
		Log.Debug();
		return resultList;
	}
	
	/**
	 * getAppGroupMgrOrgSchemeList 다건 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getAppGroupMgrOrgSchemeList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		List<?> resultList = (List<?>)dao.getList("getAppGroupMgrOrgSchemeList", paramMap);
		Log.Debug();
		return resultList;
	}	
	
	/**
	 * getAppGroupMgrScopeList 다건 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getAppGroupMgrScopeList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		List<?> resultList = (List<?>)dao.getList("getAppGroupMgrScopeList", paramMap);
		Log.Debug();
		return resultList;
	}	
	
	/**
	 * getAppGroupMgrScopeList 다건 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getAppGroupMgrScopeList2(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		List<?> resultList = (List<?>)dao.getList("getAppGroupMgrScopeList2", paramMap);
		Log.Debug();
		return resultList;
	}	
	
	/**
	 * getAppGroupMgrScopeEmpList 다건 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getAppGroupMgrScopeEmpList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		List<?> resultList = (List<?>)dao.getList("getAppGroupMgrScopeEmpList", paramMap);
		Log.Debug();
		return resultList;
	}	
	
	/**
	 *  getAppGroupMgrTempQueryMap 단건 조회 Service 
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getAppGroupMgrTempQueryMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getAppGroupMgrTempQueryMap", paramMap);
		Log.Debug();
		return resultMap;
	}
	
	/**
	 * getAppGroupMgrScopeCodeList 다건 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getAppGroupMgrScopeCodeList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		List<?> resultList = (List<?>)dao.getList("getAppGroupMgrScopeCodeList", paramMap);
		Log.Debug();
		return resultList;
	}	
	
	/**
	 * 평가그룹설정(업적) - 평가범위설정 조직범위 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveAppGroupMgrOrgScheme(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;

		cnt += dao.delete("deleteAppGroupMgrOrgScheme", convertMap);
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			// saveAppGroupMgrOrgScheme 명칭의 쿼리가 존재하지 않음. saveAppGroupMgrScope 쿼리로 변경.
			//cnt += dao.update("saveAppGroupMgrOrgScheme", convertMap);
			cnt += dao.update("saveAppGroupMgrScope", convertMap);
		}
		Log.Debug();
		return cnt;
	}


	/**
	 * 평가그룹설정(업적) - 평가범위설정 초기화 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int deleteAppGroupMgrScopeAll(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;

		cnt += dao.delete("deleteAppGroupMgrScopeAll", convertMap);
		Log.Debug();
		return cnt;
	}

	/**
	 * 평가그룹설정(업적) - 평가범위설정 초기화 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int deleteAppGroupMgrScopeAll3(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;

		cnt += dao.delete("deleteAppGroupMgrScopeAll3", convertMap);
		Log.Debug();
		return cnt;
	}

	/**
	 * 평가그룹설정(업적) - 평가범위설정 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveAppGroupMgrScope(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteAppGroupMgrScope", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveAppGroupMgrScope", convertMap);
		}
		Log.Debug();
		return cnt;
	}
}