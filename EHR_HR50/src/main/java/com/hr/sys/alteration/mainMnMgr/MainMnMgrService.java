package com.hr.sys.alteration.mainMnMgr;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 메인메뉴관리 Service
 * 
 * @author ParkMoohun
 *
 */
@Service("MainMnMgrService")  
public class MainMnMgrService{
	@Inject
	@Named("Dao")
	private Dao dao;
	/**
	 * 메인메뉴관리 다건 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getMainMnMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getMainMnMgrList", paramMap);
	}	
	/**
	 *  메인메뉴관리 단건 조회 Service 
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getMainMnMgrMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getMainMnMgrMap", paramMap);
	}
	/**
	 * 메인메뉴관리 저장 Service
	 * 
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveMainMnMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteMainMnMgr", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveMainMnMgr", convertMap);
		}
		Log.Debug();
		return cnt;
	}
//	/**
//	 * 메인메뉴관리 생성 Service
//	 * 
//	 * @param paramMap
//	 * @return int
//	 * @throws Exception
//	 */
//	public int insertMainMnMgr(Map<?, ?> paramMap) throws Exception {
//		Log.Debug();
//		return dao.create("insertMainMnMgr", paramMap);
//	}
//	/**
//	 * 메인메뉴관리 수정 Service
//	 * 
//	 * @param paramMap
//	 * @return int
//	 * @throws Exception
//	 */
//	public int updateMainMnMgr(Map<?, ?> paramMap) throws Exception {
//		Log.Debug();
//		return dao.update("updateMainMnMgr", paramMap);
//	}
//	/**
//	 * 메인메뉴관리 삭제 Service
//	 * 
//	 * @param paramMap
//	 * @return int
//	 * @throws Exception
//	 */
	public int deleteMainMnMgr(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.delete("deleteMainMnMgr", paramMap);
	}
}