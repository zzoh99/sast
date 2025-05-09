package com.hr.sys.system.processMap;
import java.util.*;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 프로세스맵 Service
 * 
 * @author jin
 *
 */
@Service("ProcessMapService")  
public class ProcessMapService{
	@Inject
	@Named("Dao")
	private Dao dao;
	
	
	
	/**
	 * 메인메뉴 목록 조회
	 * @param session
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, Object>> getMainMenuList(HttpSession session) throws Exception {
		Log.DebugStart();
		Map<String,Object> paramMap = new HashMap<>();
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		
		List<Map<String,Object>> mainMenuList = (List<Map<String, Object>>) dao.getList("getProcessMapMainMenuList", paramMap);
		
		Log.DebugEnd();
		return mainMenuList;
	}



	/**
	 * 프로세스맵 및 프로세스 조회
	 * @param session
	 * @param mainMenuCd
	 * @return
	 * @throws Exception 
	 */
	public Map<String,Object> getProcessList(HttpSession session, String mainMenuCd) throws Exception {
		Log.DebugStart();	
		Map<String,Object> resultMap = new HashMap<>();
		List<Map<String,Object>> procMapListResult = new ArrayList();

		Map<String,Object> paramMap = new HashMap<>();
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnEncodedKey", session.getAttribute("ssnEncodedKey"));
		paramMap.put("ssnLocaleCd", session.getAttribute("ssnLocaleCd"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));		
		paramMap.put("ssnGrpCd", session.getAttribute("ssnGrpCd"));
		paramMap.put("mainMenuCd", mainMenuCd);

	
		//프로세스맵 목록 조회
		List<Map<String,Object>> processMapList = (List<Map<String, Object>>) dao.getList("getProcessMapList", paramMap);
				
		for(Map<String,Object> process : processMapList){
			List<Map<String,Object>> procChildrenList = new ArrayList();
			paramMap.put("procMapSeq", process.get("procMapSeq"));
						
			//processMapMgr-sql재사용
			List<Map<String,Object>> allProcList = (List<Map<String, Object>>) dao.getList("getProcessList", paramMap);			
			List<Map<String,Object>> menuLocationList = new ArrayList<>();
			
			if(allProcList.size() > 0){
				//프로세스(메뉴)에 해당하는 mainMenu의 전체 목록을 1번만 조회하기 위해 처리
				//사용자 화면에서 mainMenuCd를 기준으로 조회하고, 프로세스맵 저장 시 작업중인 프로세스들과 다른 권한 혹은 프로세스(메뉴)를 추가하는 것이 불가하기 때문에 다음과 같이 처리
				Set<String> mainMenus = new HashSet<>();
				for (Map<String, Object> map : allProcList) {
					String mainMenu = (String) map.get("mainMenuCd");
					mainMenus.add(mainMenu);
				}

				for (String menuCd : mainMenus) {
					paramMap.put("procMainMenuCd", menuCd);
					paramMap.put("procGrpCd",  allProcList.get(0).get("grpCd"));
					//프로세스(메뉴)에 해당하는 mainMenu의 전체 목록 조회 , processMapMgr-sql재사용
					menuLocationList.addAll((List<Map<String, Object>>) dao.getList("getMenuLocationList", paramMap));
				}
			}
				
			
			for(Map<String,Object> proc : allProcList){
				paramMap.put("procMainMenuCd", proc.get("mainMenuCd"));
				paramMap.put("priorMenuCd", proc.get("priorMenuCd"));
				paramMap.put("procGrpCd", proc.get("grpCd"));

				if(menuLocationList.size() > 0){
					String location ="";
					
					//lvl(level)이 1인경우는 제일 첫번째 대메뉴, 그 외에는 하위 메뉴들로 location목록을 조합/생성
					for(Map<String,Object> menuInfo : menuLocationList){
						if("1".equals(menuInfo.get("lvl").toString())){
							location = menuInfo.get("mainMenuNm").toString() + " > " + menuInfo.get("menuNm").toString();
						}
						else{
							location += " > " + menuInfo.get("menuNm").toString();

							if(proc.get("mainMenuCd").toString().equals(menuInfo.get("mainMenuCd").toString())
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
				procChildrenList.add(proc);
			}
	
			process.put("children",procChildrenList);
			procMapListResult.add(process);
		}
		
		resultMap.put("procMapList", procMapListResult);
		
		Log.DebugEnd();	
		return resultMap;
	}
	
	
	
}