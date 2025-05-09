package com.hr.main.sub;

import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 메뉴 서비스
 *
 * @author ParkMoohun
 *
 */
@Service("SubService")
public class SubService{

	@Inject
	@Named("Dao")
	private Dao dao;


	/**
	 * 하위 분류 조회
	 *
	 * @param searchMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getSubLowMenuList(Map<?, ?> searchMap) throws Exception {
		Log.Debug();
		String mainMenuCd 	= searchMap.get("mainMenuCd").toString();
		if (mainMenuCd.equals("20"))
			return (List<?>)dao.getList("getSubLowBoardList", searchMap);
		else if(mainMenuCd.equals("21"))
			return (List<?>)dao.getList("getSubLowWorkflowList", searchMap);
		else
			return (List<?>)dao.getList("getSubLowMenuList", searchMap);
	}

	/**
	 *  Sub Menu Direct Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getDirectSubMenuMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getDirectSubMenuMap", paramMap);
	}

	/**
	 *  Sub Menu Direct Map
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> geSubDirectMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("geSubDirectMap", paramMap);
	}

	/**
	 * 나의메뉴 조회
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public  List<?> tsys331SelectMyMenuList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("tsys331SelectMyMenuList", paramMap);
	}



	/**
	 * 나의메뉴 관리 Service
	 *
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int tsys331saveMyMenuMgr(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		String myMenuCd 	= paramMap.get("prgCd").toString();
		String myMenuSt 	= paramMap.get("status").toString();
		int delCnt = 0;
		int insertCnt = 0;
		if(!myMenuCd.equals("")){
			delCnt = dao.delete("tsys331DeleteMyMenu", paramMap);
			if(!myMenuSt.equals("D")){
				insertCnt = dao.create("tsys331InsertMyMenu", paramMap);
			}
		}
		return delCnt + insertCnt;
	}

	/**
	 *  대메뉴 클릭시 컨텐츠 화면.
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getSubMenuContents(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getSubMenuContents", paramMap);
	}


	/**
	 *  메뉴 리스트 검색
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getSearchMenuList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>)dao.getList("getSearchMenuList", paramMap);
	}
	/**
	 *  알림 리스트 검색
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getAlertInfoList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>)dao.getList("getAlertInfoList", paramMap);
	}
	public Map<?,?> getAlertInfoCnt(Map<String, Object> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getAlertInfoCnt", paramMap);
	}
	/**
	 *  알림 조회여부 수정
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public int updateAlertInfoReadYn(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.update("updateAlertInfoReadYn", paramMap);
	}
	
	/**
	 *  알림 전체 삭제
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public int deleteAllAlert(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.delete("deleteAllAlert", paramMap);
	}
	
	
	/**
	 *  최근 알림 조회
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?,?> getRecentAlert(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getRecentAlert", paramMap);
	}
	


}
