package com.hr.sys.system.processMapMgr;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import com.hr.common.logger.Log;
/**
 * 프로세스맵 관리 Controller 
 * 
 * @author jin
 *
 */


@RestController
@RequestMapping(value="/ProcessMapMgr.do", method=RequestMethod.POST ) 
public class ProcessMapMgrController {

	@Inject
	@Named("ProcessMapMgrService")
	private ProcessMapMgrService processMapMgrService;
	
	
	/**
	 * 불필요하게 생성되었던 프로세스 데이터 삭제
	 * @param session
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=clearProcessMapData", method = RequestMethod.POST )
	public ModelAndView clearProcessMapData(HttpSession session, HttpServletRequest request) throws Exception{
		Log.DebugStart();
		ModelAndView mv = new ModelAndView();
		String resultMessage="";
		int resultCnt=-1;
		
		try{
			resultCnt = processMapMgrService.clearProcessMapData(session);
			resultMessage = (resultCnt > 0)? "SUCCESS" : "SUCCESS, NO SAVED";
			mv.addObject("status",resultMessage);
		}catch(Exception e){
			Log.Debug(e.getMessage());
			Log.Debug(e.getStackTrace().toString());
			mv.addObject("status","FAIL");
		}
		
		mv.setViewName("jsonView");
		return mv;
	}
	
	
	
	
	
	

	/**
	 * 프로세스맵 관리 View 및 초기데이터 조회
	 * @param session
	 * @param request
	 * @return
	 * @throws Exception
	 */	
	@RequestMapping(params="cmd=viewProcessMapMgr", method = RequestMethod.GET )
	public ModelAndView viewProcessMapMgr(HttpSession session,  HttpServletRequest request) throws Exception{
		Log.DebugStart();
		ModelAndView mv = new ModelAndView();
		List<Map<String,Object>> authGrpList = new ArrayList<>();

		try{
			authGrpList = processMapMgrService.getGrpList(session);
			mv.addObject("status","SUCCESS");
		}catch(Exception e){
			Log.Debug(e.getMessage());
			Log.Debug(e.getStackTrace().toString());
			mv.addObject("status","FAIL");
		}

		mv.setViewName("sys/system/processMapMgr/processMapMgr");
		mv.addObject("authGrpList",authGrpList);


		Log.DebugEnd();
		return mv;
	}
	
	
	
	/**
	 * 프로세스맵 리스트
	 * @param session
	 * @param request
	 * @return
	 * @throws Exception
	 */	
	@RequestMapping(params="cmd=getProcessMapList", method = RequestMethod.GET )
	public ModelAndView viewProcessMapList(HttpSession session,  HttpServletRequest request,
			@RequestParam(required = false) String grpCd) throws Exception{
		Log.DebugStart();
		ModelAndView mv = new ModelAndView();
		Map<String,Object> processMapList = new HashMap<>();
	
		try{
			processMapList = processMapMgrService.getProcessMapList(session,grpCd);
			mv.addObject("status","SUCCESS");
		}catch(Exception e){
			Log.Debug(e.getMessage());
			Log.Debug(e.getStackTrace().toString());
			mv.addObject("status","FAIL");
		}
		
		mv.setViewName("jsonView");
		mv.addObject("authGrpList", processMapList.get("authGrpList"));
		mv.addObject("processMapList", processMapList.get("processMapList"));

	
		Log.DebugEnd();
		return mv;
	}


	
	/**
	 * 프로세스맵 관리 > "즐겨찾기" 모달 View 및 초기데이터 조회
	 * @param session
	 * @param request
	 * @return
	 * @throws Exception
	 */	
	@RequestMapping(params="cmd=viewFavoriteList", method = RequestMethod.GET )
	public ModelAndView viewProcessMapFavoriteList(HttpSession session,  HttpServletRequest request) throws Exception{
		
		Log.DebugStart();
		ModelAndView mv = new ModelAndView();
		List<Map<String,Object>> authGrpList = new ArrayList<>();

		try{
			authGrpList = processMapMgrService.getGrpList(session);
			mv.addObject("status","SUCCESS");
		}catch(Exception e){
			Log.Debug(e.getMessage());
			Log.Debug(e.getStackTrace().toString());
			mv.addObject("status","FAIL");
		}

		mv.setViewName("sys/system/processMapMgr/processMapMgrFavoritePopup");
		mv.addObject("authGrpList",authGrpList);
		
		Log.DebugEnd();
		return mv;
		
	}

	
	

	/**
	 * 프로세스맵 관리 > "즐겨찾기" 모달 프로세스맵 및 즐겨찾기 목록 조회
	 * @param session
	 * @param request
	 * @param grpCd
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getFavoriteList", method = RequestMethod.GET )
	public ModelAndView getFavoriteList(HttpSession session,  HttpServletRequest request,
			@RequestParam(required = false) String grpCd) throws Exception{
		Log.DebugStart();
		ModelAndView mv = new ModelAndView();
		Map<String,Object> favoriteModalList = new HashMap<>();
	
		try{
			favoriteModalList = processMapMgrService.getProcessMapFavoriteList(session,grpCd);
			mv.addObject("status","SUCCESS");
			
		}catch(Exception e){
			Log.Debug(e.getMessage());
			Log.Debug(e.getStackTrace().toString());
			mv.addObject("status","FAIL");
		}
		
		mv.setViewName("jsonView");
		mv.addObject("processMapList", favoriteModalList.get("processMapList"));
		mv.addObject("favoriteList", favoriteModalList.get("favoriteList"));
	
		Log.DebugEnd();
		return mv;
	}

	
	
	

	/**
	 * 프로세스맵 관리 > "즐겨찾기" 수정/저장
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return
	 */
	@RequestMapping(params="cmd=saveFavorite", method = RequestMethod.POST )
	public ModelAndView saveFavoriteList(HttpSession session, HttpServletRequest request,
			@RequestBody Map<String,Object> paramMap){
		Log.DebugStart();
		ModelAndView mv = new ModelAndView();
		int resultCnt =-1;
		String resultMessage = "";
		
		try{
			resultCnt = processMapMgrService.saveProcessMapFavorite(session,paramMap);
			resultMessage = (resultCnt > 0)? "SUCCESS" : "SUCCESS, NO SAVED";
			
		}catch(Exception e){
			Log.Debug(e.getMessage());
			Log.Debug(e.getStackTrace().toString());
			resultMessage = "FAIL";
			mv.addObject("status",resultMessage);
		}
		
		mv.setViewName("jsonView");
		mv.addObject("status", resultMessage);
		
		Log.DebugEnd();
		return mv;
	}
	
	
	
	
	/**
	 * 프로세스맵 생성/수정  에디터  View 및 초기데이터 조회
	 * @param session
	 * @param request
	 * @param procMapSeq
	 * @param grpCd
	 * @param mainMenuCd
	 * @param procMapNm
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewEditProcessMap", method = {RequestMethod.POST, RequestMethod.GET } )
	public ModelAndView viewEditProcessMap(HttpSession session,  HttpServletRequest request,
			@RequestParam(required = false) String procMapSeq,
			@RequestParam(required = false) String grpCd,
			@RequestParam(required = false) String mainMenuCd,
			@RequestParam(required = false) String procMapNm
			) throws Exception{
		Log.DebugStart();
		ModelAndView mv = new ModelAndView();
		Map<String,Object> processMapSet = new HashMap<>();
		
		try{
			//신규생성
			if(procMapSeq == null || ("").equals(procMapSeq)){
				processMapSet = processMapMgrService.getNewViewEditProcessMap("NEW",session,procMapSeq);
				mv.addObject("procMapSeq",processMapSet.get("procMapSeq"));
			}
			//수정
			else if(procMapSeq != null){
				processMapSet = processMapMgrService.getNewViewEditProcessMap("EDIT",session,procMapSeq);
				mv.addObject("procMapSeq",procMapSeq);
				mv.addObject("selectedGrpCd",grpCd);
				mv.addObject("selectedMainMenuCd",mainMenuCd);
				mv.addObject("selectedProcMapNm",procMapNm);
			}
			
			mv.addObject("status","SUCCESS");

		}catch(Exception e){
			Log.Debug(e.getMessage());
			Log.Debug(e.getStackTrace().toString());
			mv.addObject("status","FAIL");
		}


		mv.setViewName("sys/system/processMapMgr/processMapEdit");
		mv.addObject("authGrpList",processMapSet.get("authGrpList"));
		mv.addObject("mainMenuList",processMapSet.get("mainMenuList"));
		
		
		Log.DebugEnd();
		return mv;
	}

	
	
		
	/**
	 * 프로세스맵 상세조회뷰어  View 및 초기데이터 조회
	 * @param session
	 * @param request
	 * @param procMapSeq
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewViewerProcessMap", method = { RequestMethod.POST, RequestMethod.GET } )
	public ModelAndView viewViewerProcessMap(HttpSession session,  HttpServletRequest request,
			@RequestParam(required = true) String procMapSeq
			) throws Exception{
		Log.DebugStart();
		ModelAndView mv = new ModelAndView();
		Map<String,Object> processMapSet = new HashMap<>();
		
		try{
			processMapSet = processMapMgrService.getViewerProcessMap(procMapSeq);
			mv.addObject("status","SUCCESS");
		} catch(Exception e) {
			Log.Debug(e.getMessage());
			Log.Debug(e.getStackTrace().toString());
			mv.addObject("status","FAIL");
		}

		mv.setViewName("sys/system/processMapMgr/processMapViewer");
		if(processMapSet != null) {
			mv.addObject("procMapSeq",processMapSet.get("procMapSeq"));
			mv.addObject("procMapNm",processMapSet.get("procMapNm"));
			mv.addObject("viewerGrpCd",processMapSet.get("grpCd"));
			mv.addObject("mainMenuCd",processMapSet.get("mainMenuCd"));
			mv.addObject("grpNm",processMapSet.get("grpNm"));
			mv.addObject("mainMenuNm",processMapSet.get("mainMenuNm"));
		}
		
		Log.DebugEnd();
		return mv;
	}
	
	
	
	
	
	
	/**
	 * 프로세스맵 생성 시, 왼쪽 메인메뉴 및 하위 메뉴 목록 조회 
	 * @param session
	 * @param request
	 * @param grpCd
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getMenuList", method = RequestMethod.GET )
	public ModelAndView getMenuList(HttpSession session,  HttpServletRequest request,
			@RequestParam(required = true) String grpCd,
			@RequestParam(required = true) String mainMenuCd,
			@RequestParam(required = true) String procMapSeq
			) throws Exception{
		Log.DebugStart();
		ModelAndView mv = new ModelAndView();
		List<Map<String,Object>> allMenuList = new ArrayList<>();
	
		try{
			allMenuList = processMapMgrService.getProcessMapMenuList(session,grpCd,mainMenuCd,procMapSeq);
			mv.addObject("status","SUCCESS");
			
		}catch(Exception e){
			Log.Debug(e.getMessage());
			Log.Debug(e.getStackTrace().toString());
			mv.addObject("status","FAIL");
		}
		
		mv.setViewName("jsonView");
		mv.addObject("menuList", allMenuList);
	
		Log.DebugEnd();
		return mv;
	}
	
	
	
	
	
	/**
	 * 프로세스맵에 해당하는 프로세스 목록 조회
	 * @param session
	 * @param request
	 * @param procMapSeq
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getProcessList", method = RequestMethod.GET )
	public ModelAndView getProcessList(HttpSession session,  HttpServletRequest request,
			@RequestParam(required = true) String procMapSeq ) throws Exception{
		Log.DebugStart();
		ModelAndView mv = new ModelAndView();
		Map<String,Object> processList = new HashMap<>();
	
		try{
			processList = processMapMgrService.getProcessList(session,procMapSeq);
			mv.addObject("status","SUCCESS");
			
		}catch(Exception e){
			Log.Debug(e.getMessage());
			Log.Debug(e.getStackTrace().toString());
			mv.addObject("status","FAIL");
		}
		
		mv.setViewName("jsonView");
		mv.addObject("procList", processList.get("procList"));
		mv.addObject("procMapNm", processList.get("procMapNm"));
	
		Log.DebugEnd();
		return mv;
	}
	
	
	
	
	
	
	
	/**
	 * 프로세스맵 관리 > 프로세스 도움말 모달 View
	 * @param session
	 * @param request
	 * @return
	 * @throws Exception
	 */	
	@RequestMapping(params="cmd=viewProcessMapHelpPop", method = RequestMethod.GET )
	public ModelAndView viewProcessMapHelpPop(HttpSession session,  HttpServletRequest request) throws Exception{
		
		Log.DebugStart();
		ModelAndView mv = new ModelAndView();

		try{
			mv.addObject("status","SUCCESS");
		}catch(Exception e){
			Log.Debug(e.getMessage());
			Log.Debug(e.getStackTrace().toString());
			mv.addObject("status","FAIL");
		}

		mv.setViewName("sys/system/processMapMgr/processMapMgrHelpPopup");
	
		Log.DebugEnd();
		return mv;
		
	}
	
	
	/**
	 * 프로세스맵 관리 > 프로세스 도움말 에디터 모달 View
	 * @param session
	 * @param request
	 * @return
	 * @throws Exception
	 */	
	@RequestMapping(params="cmd=viewProcessMapHelpEditorPop", method = RequestMethod.GET )
	public ModelAndView viewProcessMapHelpEditorPop(HttpSession session,  HttpServletRequest request) throws Exception{
		
		Log.DebugStart();
		ModelAndView mv = new ModelAndView();
		
		try{
			mv.addObject("status","SUCCESS");
		}catch(Exception e){
			Log.Debug(e.getMessage());
			Log.Debug(e.getStackTrace().toString());
			mv.addObject("status","FAIL");
		}
		
		mv.setViewName("sys/system/processMapMgr/processMapMgrHelpEditorPopup");
	
		Log.DebugEnd();
		return mv;
		
	}

	
	
	
	

	/**
	 * 프로세스 도움말  수정/저장
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return
	 */
	@RequestMapping(params="cmd=saveProcessMapHelpPop", method = RequestMethod.POST )
	public ModelAndView saveProcessMapHelpPop(HttpSession session, HttpServletRequest request,
			@RequestBody Map<String,Object> paramMap){
		Log.DebugStart();
		ModelAndView mv = new ModelAndView();
		int resultCnt =-1;
		String resultMessage = "";
		
		try{
			resultCnt = processMapMgrService.saveProcessMapHelp(session,paramMap);
			resultMessage = (resultCnt > 0)? "SUCCESS" : "SUCCESS, NO SAVED";
			
		}catch(Exception e){
			Log.Debug(e.getMessage());
			Log.Debug(e.getStackTrace().toString());
			resultMessage = "FAIL";
			mv.addObject("status",resultMessage);
		}
		
		mv.setViewName("jsonView");
		mv.addObject("status", resultMessage);
	
		
		Log.DebugEnd();
		return mv;
	}
	
	
	

	/**
	 * 프로세스 메모  수정/저장
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return
	 */
	@RequestMapping(params="cmd=saveProcessMapMemo", method = RequestMethod.POST )
	public ModelAndView saveProcessMapMemo(HttpSession session, HttpServletRequest request,
			@RequestBody Map<String,Object> paramMap){
		Log.DebugStart();
		ModelAndView mv = new ModelAndView();
		int resultCnt =-1;
		String resultMessage = "";
		
		try{
			resultCnt = processMapMgrService.saveProcessMapMemo(session,paramMap);
			resultMessage = (resultCnt > 0)? "SUCCESS" : "SUCCESS, NO SAVED";
			
		}catch(Exception e){
			Log.Debug(e.getMessage());
			Log.Debug(e.getStackTrace().toString());
			resultMessage = "FAIL";
			mv.addObject("status",resultMessage);
		}
		
		mv.setViewName("jsonView");
		mv.addObject("status", resultMessage);
		
		Log.DebugEnd();
		return mv;
	}
	
	
	
	
	

	/**
	 * 프로세스 생성
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return
	 */
	@RequestMapping(params="cmd=createProcess", method = RequestMethod.POST )
	public ModelAndView createProcess(HttpSession session, HttpServletRequest request,
			@RequestBody Map<String,Object> paramMap){
		Log.DebugStart();
		ModelAndView mv = new ModelAndView();
		Map<String,Object> resultMap = new HashMap<>();
		String resultMessage = "";
		
		try{
			resultMap = processMapMgrService.createProcess(session,paramMap);
			resultMessage = (Integer.parseInt(resultMap.get("cnt").toString()) > 0)? "SUCCESS" : "SUCCESS, NO SAVED";
			
		}catch(Exception e){
			Log.Debug(e.getMessage());
			Log.Debug(e.getStackTrace().toString());
			resultMessage = "FAIL";
			mv.addObject("status",resultMessage);
		}
		
		mv.setViewName("jsonView");
		mv.addObject("procSeq", resultMap.get("procSeq"));
		mv.addObject("status", resultMessage);
		
		Log.DebugEnd();
		return mv;
	}
	
	
	
	
	
	
	
	

	/**
	 * 프로세스맵 저장
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(params="cmd=saveProcessMap", method = RequestMethod.POST )
	public ModelAndView saveProcessMap(HttpSession session, HttpServletRequest request,
			@RequestBody Map<String,Object> paramMap){
		Log.DebugStart();
		ModelAndView mv = new ModelAndView();
		int resultCnt =-1;
		String resultMessage = "";

		try {
			resultCnt = processMapMgrService.saveProcessMap(session,paramMap);
			resultMessage = (resultCnt > 0)? "SUCCESS" : "SUCCESS, NO SAVED";
		} catch(Exception e) {
			Log.Debug(e.getMessage());
			Log.Debug(e.getStackTrace().toString());
			resultMessage = "FAIL";
			mv.addObject("status",resultMessage);
		}
		
		mv.setViewName("jsonView");
		mv.addObject("status", resultMessage);
		
		Log.DebugEnd();
		return mv;
	}
	
	
	
	
	
	

	/**
	 * 프로세스맵 삭제
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return
	 */
	@RequestMapping(params="cmd=delProcessMap", method = RequestMethod.POST )
	public ModelAndView delProcessMap(HttpSession session, HttpServletRequest request,
			@RequestBody Map<String,Object> paramMap){
		Log.DebugStart();
		ModelAndView mv = new ModelAndView();
		int resultCnt =-1;
		String resultMessage = "";
		
		try{
			resultCnt = processMapMgrService.delProcessMap(session,paramMap);
			resultMessage = (resultCnt > 0)? "SUCCESS" : "SUCCESS, NO SAVED";
			
		}catch(Exception e){
			Log.Debug(e.getMessage());
			Log.Debug(e.getStackTrace().toString());
			resultMessage = "FAIL";
			mv.addObject("status",resultMessage);
		}
		
		mv.setViewName("jsonView");
		mv.addObject("status", resultMessage);
		
		Log.DebugEnd();
		return mv;
	}
	
}
