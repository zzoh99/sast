package com.hr.sys.security.authority;
import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 권한그룹관리 Service
 * 
 * @author 이름
 *
 */
@Service("AuthorityService")  
public class AuthorityService{
	@Inject
	@Named("Dao")
	private Dao dao;
	/**
	 * 권한그룹관리 다건 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getAuthorityList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getAuthorityList", paramMap);
	}	
	/**
	 *  권한그룹관리 단건 조회 Service 
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getAuthorityMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getAuthorityMap", paramMap);
	}
	/**
	 * 권한그룹관리 저장 Service
	 * 
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveAuthority(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteAuthority", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveAuthority", convertMap);
		}
		Log.Debug();
		return cnt;
	}
	/**
	 * 권한그룹관리 생성 Service
	 * 
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int insertAuthority(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.create("insertAuthority", paramMap);
	}
	/**
	 * 권한그룹관리 수정 Service
	 * 
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int updateAuthority(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.update("updateAuthority", paramMap);
	}
	/**
	 * 권한그룹관리 삭제 Service
	 * 
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int deleteAuthority(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.delete("deleteAuthority", paramMap);
	}
	
	
	/* 팝업 1 */
	/**
	 * 권한범위설정  다건 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getAthRangeMgrLeftList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getAthRangeMgrLeftList", paramMap);
	}	
	
	/**
	 * 권한범위설정 다건 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getAthRangeMgrRightList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getAthRangeMgrRightList", paramMap);
	}	
	/**
	 * 권한범위설정 저장 Service
	 * 
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int insertAthRangeMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.update("insertAthRangeMgr", convertMap);
		}
		Log.Debug();
		return cnt;
	}
	/**
	 * 권한범위설정 삭제 Service
	 * 
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int deleteAthRangeMgr(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.delete("deleteAthRangeMgr", paramMap);
	}	
	
	
	/* 팝업 2 */
	/**
	 * 권한그룹 View 설정 다건 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getAthViewMgrLeftList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getAthViewMgrLeftList", paramMap);
	}	
	
	/**
	 * 권한그룹 View 설정 다건 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getAthViewMgrRightList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getAthViewMgrRightList", paramMap);
	}	
	/**
	 * 권한그룹 View 설정 저장 Service
	 * 
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int insertAthViewMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.update("insertAthViewMgr", convertMap);
		}
		Log.Debug();
		return cnt;
	}
	/**
	 * 권한그룹 View 설정 삭제 Service
	 * 
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int deleteAthViewMgr(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.delete("deleteAthViewMgr", paramMap);
	}	
	
}