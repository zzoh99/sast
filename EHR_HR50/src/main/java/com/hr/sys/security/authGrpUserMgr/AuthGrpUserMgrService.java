package com.hr.sys.security.authGrpUserMgr;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 권한그룹사용자관리 Service
 *
 * @author CBS
 *
 */
@Service("AuthGrpUserMgrService")
public class AuthGrpUserMgrService{
	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 권한그룹사용자관리 sheet1 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getAuthGrpUserMgrSheet1List(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getAuthGrpUserMgrSheet1List", paramMap);
	}

	/**
	 * 권한그룹사용자관리 sheet2 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getAuthGrpUserMgrSheet2List(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getAuthGrpUserMgrSheet2List", paramMap);
	}

	/**
	 * 권한그룹사용자관리 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveAuthGrpUserMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteAuthGrpUserMgr_TSYS313", convertMap);
			dao.delete("deleteAuthGrpUserMgr_TSYS319", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveAuthGrpUserMgr", convertMap);
		}
		Log.Debug();
		return cnt;
	}
	/**
	 * 권한그룹사용자관리 삭제 Service
	 *
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int deleteAuthGrpUserMgr(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.delete("deleteAuthGrpUserMgr", paramMap);
	}

	/**
	 * Tmp Result 조회 getTmpQueryMgr
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getTmpQueryMgr(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getTmpQueryMgr", paramMap);
	}

	/**
	 * 권한범위 설정 팝업 sheet1 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getAuthGrpUserMgrScopePopupSheet1List(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getAuthGrpUserMgrScopePopupSheet1List", paramMap);
	}

	/**
	 *  권한범위 SQL Syntax 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getAuthGrpUserMgrScopePopupSheet2Query(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getAuthGrpUserMgrScopePopupSheet2Query", paramMap);
	}

	/**
	 * 권한범위항목 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getAuthGrpUserMgrScopePopupSheet2List(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getAuthGrpUserMgrScopePopupSheet2List", paramMap);
	}


	/**
	 * 권한범위 설정 팝업 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveAuthGrpUserMgrScopePopup(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.update("deleteAuthGrpUserMgrScopePopup", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("insertAuthGrpUserMgrScopePopup", convertMap);
		}
		Log.Debug();
		return cnt;
	}

	/**
	 * 권한범위 설정(조직) 팝업 sheet1 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getAuthGrpUserMgrScopeOrgPopupList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getAuthGrpUserMgrScopeOrgPopupList", paramMap);
	}

	/**
	 * 권한범위 설정(사원) - 평가범위설정 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getAuthGrpUserMgrPopList4(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getAuthGrpUserMgrPopList4", paramMap);
	}

	/**
	 * 권한범위 설정(사원) - 평가범위설정 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getAuthGrpUserMgrPopList5(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getAuthGrpUserMgrPopList5", paramMap);
	}

	/**
	 * 권한범위 설정(사원) - 평가범위설정 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getAuthGrpUserMgrPopList6(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getAuthGrpUserMgrPopList6", paramMap);
	}
	
	/**
	 * 대상자 선택 팝업 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getAuthGrpUserMgrTargetPopupList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getAuthGrpUserMgrTargetPopupList", paramMap);
	}
}