package com.hr.sys.security.athGrpMenuMgr;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 권한그룹프로그램관리 Service
 * 
 * @author ParkMoohun
 *
 */
@Service("AthGrpMenuMgrService")  
public class AthGrpMenuMgrService{
	@Inject
	@Named("Dao")
	private Dao dao;
	/**
	 * 권한그룹프로그램관리 등록메인메뉴 다건 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getAthGrpMenuMgrLeftList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getAthGrpMenuMgrLeftList", paramMap);
	}	
	
	/**
	 * 권한그룹프로그램관리 등록가능메인메뉴 다건 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getAthGrpMenuMgrRightList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getAthGrpMenuMgrRightList", paramMap);
	}	
	/**
	 * 권한그룹프로그램관리 저장 Service
	 * 
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int insertAthGrpMenuMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.update("insertAthGrpMenuMgr", convertMap);
		}
		Log.Debug();
		return cnt;
	}
	/**
	 * 권한그룹프로그램관리 삭제 Service
	 * 
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int deleteAthGrpMenuMgr(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.delete("deleteAthGrpMenuMgr", paramMap);
	}
	/**
	 * 권한그룹프로그램관리 등록메인메뉴 다건 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getAthGrpMenuMgrRegPopupList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getAthGrpMenuMgrRegPopupList", paramMap);
	}	
	/**
	 * 권한그룹프로그램관리 등록메인메뉴 저장
	 * 
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	
	public int saveAthGrpMenuMgrRegPopup(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
/*		
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteAthGrpMenuMgrRegPopup", convertMap);
		}
*/		
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.create("saveAthGrpMenuMgrRegPopup", convertMap);
		}
		Log.Debug();
		return cnt;
	}	
	
	
	/**
	 * 권한그룹프로그램관리 등록메인메뉴 다건 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getAthGrpMenuMgrNoneRegPopupList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getAthGrpMenuMgrNoneRegPopupList", paramMap);
	}
	
	/**
	 * 권한그룹프로그램관리 그룹간 복사 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int copyAthGrpMenuMgr(Map<String, Object> paramMap) throws Exception {
		Log.Debug();
		dao.delete("deleteAthGrpMenuMgrAll", paramMap);
		int cnt = dao.create("copyAthGrpMenuMgrAll", paramMap);
		
		return cnt;
	}
}