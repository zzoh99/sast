package com.hr.sys.loginMenu.loginMenuMgr;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 로그인메뉴관리 Service
 *
 * @author EW
 *
 */
@Service("LoginMenuMgrService")
public class LoginMenuMgrService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 로그인메뉴관리 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getLoginMenuMgrFirstList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getLoginMenuMgrFirstList", paramMap);
	}
	
	/**
	 * 로그인메뉴관리 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getLoginMenuMgrSecondList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getLoginMenuMgrSecondList", paramMap);
	}

	/**
	 * 로그인메뉴관리 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getLoginMenuMgrThirdList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getLoginMenuMgrThirdList", paramMap);
	}

	/**
	 * 로그인메뉴관리 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveLoginMenuMgrFirst(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteLoginMenuMgrFirstFirst", convertMap);
			//cnt += dao.delete("deleteLoginMenuMgrFirstSecond", convertMap);
			//cnt += dao.delete("deleteLoginMenuMgrFirstThird", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveLoginMenuMgrFirst", convertMap);
		}

		return cnt;
	}

	/**
	 * 로그인메뉴관리 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveLoginMenuMgrSecond(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteLoginMenuMgrSecondFirst", convertMap);
			cnt += dao.delete("deleteLoginMenuMgrSecondSecond", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveLoginMenuMgrSecond", convertMap);
		}

		return cnt;
	}
	
	/**
	 * 로그인메뉴관리 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveLoginMenuMgrThird(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteLoginMenuMgrThird", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveLoginMenuMgrThird", convertMap);
		}
		
		return cnt;
	}

	/**
	 * 메인관리 그룹간 복사 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int copyLoginMenuMgr(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		dao.delete("deleteLoginMenuMgrAllThird", paramMap);
		dao.delete("deleteLoginMenuMgrAllSecond", paramMap);
		dao.delete("deleteLoginMenuMgrAllFirst", paramMap);
		int cnt1 = dao.create("copyLoginMenuMgrAllFirst", paramMap);
		int cnt2 = dao.create("copyLoginMenuMgrAllSecond", paramMap);
		int cnt3 = dao.create("copyLoginMenuMgrAllThird", paramMap);
		
		return cnt1+cnt2+cnt3;
	}
}
