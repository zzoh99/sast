package com.hr.sys.system.processMapMgr;
import java.util.*;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 프로세스맵 관리 Service
 * 
 * @author jin
 *
 */
@SuppressWarnings("unchecked")
@Service("ProcessMapMgrService")  
public class ProcessMapMgrService{
	@Inject
	@Named("Dao")
	private Dao dao;
	
	
	
	/**
	 * 권한그룹 목록 조회
	 * @param session
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, Object>> getGrpList(HttpSession session) throws Exception {
		Log.DebugStart();
		Map<String,Object> paramMap = new HashMap<>();
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		
		List<Map<String,Object>> authGrpList = (List<Map<String, Object>>) dao.getList("getProcessMapMgrAuthGrpList", paramMap);
		
		Log.DebugEnd();
		return authGrpList;
	}
	
	
	
	/**
	 * 프로세스맵 관리 조회(메인화면)
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public Map<String,Object> getProcessMapList(HttpSession session,String grpCd) throws Exception{
		Log.DebugStart();	
		Map<String,Object> resultMap = new HashMap<>();
		List<Map<String,Object>> mainMenuListResult = new ArrayList<>();

		Map<String,Object> paramMap = new HashMap<>();
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		
		if("".equals(grpCd) || grpCd != null){
			paramMap.put("grpCd", grpCd);
		}
	
		List<Map<String,Object>> authGrpList = (List<Map<String, Object>>) dao.getList("getProcessMapMgrAuthGrpList", paramMap);
		
		List<Map<String,Object>> mainMenuList = (List<Map<String, Object>>) dao.getList("getProcessMapMgrMainMenuList", paramMap);
		
		for(Map<String,Object> mainMenu : mainMenuList){
			paramMap.put("mainMenuCd", mainMenu.get("mainMenuCd"));
			List<Map<String,Object>> children = (List<Map<String, Object>>) dao.getList("getProcessMapMgrMainMenuChildrenList", paramMap);
			mainMenu.put("children",children);
			mainMenuListResult.add(mainMenu);
		}
		
		resultMap.put("authGrpList", authGrpList);
		resultMap.put("processMapList", mainMenuListResult);
		
		Log.DebugEnd();	
		return resultMap;
	}

	
	/**
	 * 프로세스맵 관리 > 프로세스맵 목록 및 즐겨찾기 조회(모달화면)
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public Map<String,Object> getProcessMapFavoriteList(HttpSession session,String grpCd) throws Exception{
		Log.DebugStart();		
		Map<String,Object> resultMap = new HashMap<>();
		List<Map<String,Object>> mainMenuListResult = new ArrayList<>();

		Map<String,Object> paramMap = new HashMap<>();
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("grpCd", grpCd);
		
				
		List<Map<String,Object>> mainMenuList = (List<Map<String, Object>>) dao.getList("getProcessMapMgrMainMenuList", paramMap);
		
		for(Map<String,Object> mainMenu : mainMenuList){
			List<Map<String,Object>> childrenList = new ArrayList<>();
			paramMap.put("mainMenuCd", mainMenu.get("mainMenuCd"));
			//프로세스맵 목록 조회조건을 위해서 즐겨찾기 화면에서 보일 때는 조건을 추가
			paramMap.put("isFavoriteCheck","Y"); 
			//mainMenu에 해당하는 프로세스맵 목록
			List<Map<String,Object>> procMapList = (List<Map<String, Object>>) dao.getList("getProcessMapMgrMainMenuChildrenList", paramMap);
			if(procMapList.size() > 0) {
				
				//프로세스맵의 세부 프로세스 목록 조회
				for(Map<String,Object> proc : procMapList){
					paramMap.put("procMapSeq", proc.get("procMapSeq"));
					List<Map<String,Object>> procList = (List<Map<String, Object>>) dao.getList("getProcessListForFavorite", paramMap);
					proc.put("procList", procList);
					childrenList.add(proc);
				}
			
				mainMenu.put("children",childrenList);
				mainMenuListResult.add(mainMenu);
			}
		}
		
		List<Map<String,Object>> procFavoriteList = new ArrayList<>();
		//즐겨찾기된 프로세스맵 목록
		List<Map<String,Object>> favoriteList = (List<Map<String, Object>>) dao.getList("getProcessMapMgrMainMenuFavoriteList", paramMap);
		if(favoriteList.size() > 0) {
			for(Map<String,Object> procFavorite : favoriteList){
				//프로세스맵의 세부 프로세스 목록 조회
				paramMap.put("procMapSeq", procFavorite.get("procMapSeq"));
				List<Map<String,Object>> procList = (List<Map<String, Object>>) dao.getList("getProcessListForFavorite", paramMap);
				procFavorite.put("procList", procList);
				procFavoriteList.add(procFavorite);
			}
		
		}
		
		resultMap.put("processMapList", mainMenuListResult);
		resultMap.put("favoriteList", procFavoriteList);
		

		Log.DebugEnd();
		return resultMap;
	}



	/**
	 * 프로세스맵 관리 > 프로세스맵 즐겨찾기 추가/수정(모달)
	 * @param session
	 * @param paramMap
	 * @return
	 * @throws Exception 
	 */
	public int saveProcessMapFavorite(HttpSession session, Map<String, Object> paramMap) throws Exception {
//TODO:에러가 났을 때 롤백처리?
		Log.DebugStart();
		
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));
		
		
		int cnt=0;
		
		//사전에 EnterCd, GrpCd에 해당하는 즐겨찾기 부분을 전체 N으로 update
		cnt += dao.update("savePreUpdateProcessMapFavorite", paramMap);
		
		if( ((List<?>)paramMap.get("favoriteProcMapSeqList")).size() > 0){	
			// 즐겨찾기할 프로세스맵을 Y로 update
			cnt += dao.update("saveProcessMapFavorite", paramMap);
		}
		
		Log.DebugEnd();
		return cnt;
	}



	/**
	 * 프로세스맵 생성/수정 에디터 View 및 초기대이터 조회
	 * 프로세스맵 신규 생성일 경우에는 프로세스맵ID를 새로 채번한다.
	 * @param string
	 * @param session
	 * @param procMapSeq
	 * @return
	 * @throws Exception 
	 */
	public Map<String, Object> getNewViewEditProcessMap(String type, HttpSession session, String procMapSeq) throws Exception {
		Log.DebugStart();
		Map<String,Object> resultMap = new HashMap<>();
		Map<String,Object> paramMap = new HashMap<>();
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		
		//신규 생성일 경우 새로 채번하기
		if("NEW".equals(type)){
			Map<String,Object> newProcId = (Map<String, Object>) dao.getMap("getProcessMapNewId",paramMap);
			if(newProcId != null) {
				resultMap.put("procMapSeq",newProcId.get("newProcId"));
			}
		}
		
		List<Map<String,Object>> authGrpList = (List<Map<String, Object>>) dao.getList("getProcessMapMgrAuthGrpList", paramMap);
		List<Map<String,Object>> mainMenuList = (List<Map<String, Object>>) dao.getList("getProcessMapMgrMainMenuList", paramMap);
		resultMap.put("authGrpList",authGrpList);
		resultMap.put("mainMenuList",mainMenuList);
		
		Log.DebugEnd();
		return resultMap;
	}


	/**
	 * 프로세스맵 상세조회뷰어  View 및 초기데이터 조회
	 * @param procMapSeq
	 * @return
	 * @throws Exception 
	 */
	public Map<String, Object> getViewerProcessMap(String procMapSeq) throws Exception {
		Log.DebugStart();
		Map<String,Object> paramMap = new HashMap<>();
		paramMap.put("procMapSeq", procMapSeq);

		Map<String,Object> resultMap = (Map<String, Object>) dao.getMap("getProcessMapSeqInfo", paramMap);	
		
		Log.DebugEnd();
		return resultMap;
	}



	/**
	 * 프로세스맵 생성 시, 왼쪽 메인메뉴 및 하위 메뉴 목록 조회
	 * @param session
	 * @param grpCd
	 * @param mainMenuCd
	 * @return
	 * @throws Exception 
	 */
	public List<Map<String, Object>> getProcessMapMenuList(HttpSession session, String grpCd, String mainMenuCd, String procMapSeq) throws Exception {
		Log.DebugStart();
		Map<String,Object> paramMap = new HashMap<>();
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("grpCd", grpCd);
		paramMap.put("mainMenuCd", mainMenuCd);
		paramMap.put("procMapSeq", procMapSeq);
		
		List<Map<String,Object>> allMenuList = (List<Map<String, Object>>) dao.getList("getProcessMapMenuList", paramMap);
		Log.DebugEnd();
		return allMenuList;
	}



	
	/**
	 * 프로세스맵에 해당하는 프로세스 목록 조회
	 * @param session
	 * @param procMapSeq
	 * @return
	 * @throws Exception 
	 */
	public Map<String, Object> getProcessList(HttpSession session, String procMapSeq) throws Exception {
		Log.DebugStart();
		Map<String,Object> paramMap = new HashMap<>();
		List<Map<String,Object>> resultList = new ArrayList<>();
		Map<String,Object> resultMap = new HashMap<>();
		String procMapNm = "";

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnEncodedKey", session.getAttribute("ssnEncodedKey"));
		paramMap.put("ssnLocaleCd", session.getAttribute("ssnLocaleCd"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));
		paramMap.put("procMapSeq", procMapSeq);
		
		
		//procMapSeq에 해당하는 프로세스 목록 조회
		List<Map<String,Object>> allProcList = (List<Map<String, Object>>) dao.getList("getProcessList", paramMap);
		List<Map<String,Object>> menuLocationList = new ArrayList<>();
		
		if(allProcList.size() > 0){
			Set<String> mainMenus = new HashSet<>();
			for (Map<String, Object> map : allProcList) {
				String mainMenu = (String) map.get("mainMenuCd");
				mainMenus.add(mainMenu);
			}

			//프로세스(메뉴)에 해당하는 mainMenu의 전체 목록을 1번만 조회하기 위해 처리
			//프로세스맵 저장 시, 작업중인 프로세스들과 다른 권한 혹은 프로세스(메뉴)를 추가하는 것이 불가하기 때문에 다음과 같이 처리
			procMapNm = allProcList.get(0).get("procMapNm").toString();

			for (String menuCd : mainMenus) {
				paramMap.put("procMainMenuCd", menuCd);
				paramMap.put("procGrpCd",  allProcList.get(0).get("grpCd"));
				//프로세스(메뉴)에 해당하는 mainMenu의 전체 목록 조회 , processMapMgr-sql재사용
				menuLocationList.addAll((List<Map<String, Object>>) dao.getList("getMenuLocationList", paramMap));
			}
		}
		
		
		for( Map<String,Object> proc : allProcList){

			if(menuLocationList.size() > 0){
				String location ="";
				
				//lvl(level)이 1인경우는 제일 첫번째 대메뉴, 그 외에는 하위 메뉴들로 location목록을 조합/생성
				for(Map<String,Object> menuInfo : menuLocationList){
					if("1".equals(menuInfo.get("lvl").toString())){
						location = menuInfo.get("mainMenuNm").toString() + " > " + menuInfo.get("menuNm").toString();
					}
					else{
						location += " > " + menuInfo.get("menuNm").toString();
						
						if( proc.get("mainMenuCd").toString().equals(menuInfo.get("mainMenuCd").toString())  
								&& proc.get("priorMenuCd").toString().equals(menuInfo.get("priorMenuCd").toString())
								&& proc.get("menuCd").toString().equals(menuInfo.get("menuCd").toString())){
							
							proc.put("location", location);
							proc.put("surl", menuInfo.get("surl"));
							proc.put("murl", menuInfo.get("murl"));
							proc.put("menuId", menuInfo.get("menuId"));
							break;
						}
					}

				}
			}
			
			resultList.add(proc);
		}
		
		resultMap.put("procList", resultList);
		resultMap.put("procMapNm", procMapNm);
		Log.DebugEnd();
		
		return resultMap;
	}


	/**
	 * 프로세스 도움말 수정/저장
	 * @param session
	 * @param paramMap
	 * @return
	 * @throws Exception 
	 */
	public int saveProcessMapHelp(HttpSession session, Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));	
		int cnt=0;

		
		if(paramMap != null){	
			cnt += dao.update("saveProcessMapHelp", paramMap);
		}
		
		Log.DebugEnd();
		return cnt;
	}
	
	
	
	
	/**
	 * 프로세스 메모 수정/저장
	 * @param session
	 * @param paramMap
	 * @return
	 * @throws Exception 
	 */
	public int saveProcessMapMemo(HttpSession session, Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));	
		int cnt=0;
		
		
		if(paramMap != null){	
			cnt += dao.update("saveProcessMapMemo", paramMap);
		}
		
		Log.DebugEnd();
		return cnt;
	}


	
	/**
	 * 프로세스 생성
	 * 프로세스 생성시, activeYn=N을 디폴트 값으로 데이터가 생성된다. 최종적으로 저장될 때는 생성되었던 프로세스들의 activeYn이 Y가 된다.
	 * @param session
	 * @param paramMap
	 * @return
	 */
	public Map<String,Object> createProcess(HttpSession session, Map<String, Object> paramMap) throws Exception{
		Log.DebugStart();
		Map<String,Object> resultMap = new HashMap<>();
		int cnt=0;

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));	
				
		if(paramMap != null){	
			
			//processSeq(프로세스ID)채번
			Map<String,Object> newProcessId = (Map<String, Object>) dao.getMap("getProcessNewId",paramMap);
			if(newProcessId != null) {
				paramMap.put("procSeq",newProcessId.get("newProcessId"));
				resultMap.put("procSeq",newProcessId.get("newProcessId"));
			}
			
			//생성한 프로세스ID기준으로 데이터 저장
			cnt += dao.update("createProcess", paramMap);
		}
		resultMap.put("cnt",cnt);
		Log.DebugEnd();
		return resultMap;
	}



	/**
	 * 프로세스맵 저장
	 * (즐겨찾기가 되어있던 프로세스맵이 임시저장이 될 경우에는 즐겨찾기 해제됨.)
	 * @param session
	 * @param paramMap
	 * @return
	 * @throws Exception 
	 */
	public int saveProcessMap(HttpSession session, Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));
		int cnt=0;
		
		
		if(paramMap != null){
			
			//프로세스맵 저장
			cnt += dao.update("saveProcessMap", paramMap);
			
			List<Map<String,Object>> tempProcessList = (List<Map<String, Object>>) paramMap.get("procSeqList");
			if(tempProcessList.size() > 0){
				//프로세스 데이터 저장
				for(Map<String,Object> processMap : tempProcessList){
					processMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
					processMap.put("ssnSabun", session.getAttribute("ssnSabun"));
					processMap.put("procMapSeq", paramMap.get("procMapSeq"));
					cnt += dao.update("saveProcessList", processMap);	
				}
			}
					
			List<String> tempDeleteList = (List<String>) paramMap.get("deleteProcSeqList");
			if( tempDeleteList.size() > 0){
				//임시 프로세스 데이터 삭제
				cnt += dao.delete("deleteTempProcess", paramMap);	
			}
		
		}
		
		Log.DebugEnd();
		return cnt;
	}
	
	
	
	
	/**
	 * 프로세스맵 삭제
	 * @param session
	 * @param paramMap
	 * @return
	 * @throws Exception 
	 */
	public int delProcessMap(HttpSession session, Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));	
		int cnt=0;		
		
		if(paramMap != null){
			cnt += dao.delete("deleteProcessMap", paramMap);			
			cnt += dao.delete("deleteProcessMapProcess", paramMap);			
		}
		
		Log.DebugEnd();
		return cnt;
	}



	/**
	 * 불필요한 프로세스맵 데이터 삭제
	 * @param session
	 * @return
	 * @throws Exception 
	 */
	public int clearProcessMapData(HttpSession session) throws Exception {
		Log.DebugStart();
		
		Map<String,Object> paramMap = new HashMap<>();
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		int cnt=0;		
		
		if(paramMap != null){
			cnt += dao.delete("deleteProcessMapDataForClear", paramMap);			
		}
		
		Log.DebugEnd();
		return cnt;
	}
	
	
}