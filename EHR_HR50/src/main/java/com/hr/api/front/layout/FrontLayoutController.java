package com.hr.api.front.layout;

import com.hr.common.logger.Log;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;

/**
 * 레이아웃 관리
 */
@RestController
@RequestMapping(value="/api/front/layout")
public class FrontLayoutController {

	@Inject
	@Named("FrontLayoutService")
	private FrontLayoutService frontLayoutService;

	/**
	 * 세션 테마 값 리턴
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(value="/getCurrentTheme", method=RequestMethod.POST )
	public Map<String, Object> getCurrentTheme(HttpSession session,
												  HttpServletRequest request,
												  @RequestBody Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		Map<String, Object> result = new HashMap<>();
		result.put("theme", session.getAttribute("theme"));
		return result;
	}

	/**
	 * 권한별 등록된 레이아웃 개수 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(value="/getLayoutMgrCount", method=RequestMethod.POST )
	public Map<String, Object> getLayoutMgrCount(HttpSession session,
			HttpServletRequest request,
			@RequestBody Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = frontLayoutService.getLayoutMgrCount(paramMap);
		}catch(Exception e){
			Message="조회에 실패 하였습니다.";
		}
		Map<String, Object> result = new HashMap<>();
		result.put("auths", list);
		result.put("Message", Message);
		Log.DebugEnd();
		return result;
	}

	/**
	 * 권한별 레이아웃 리스트 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(value="/getLayoutMgrList", method=RequestMethod.POST )
	public Map<String, Object> getLayoutMgrList(HttpSession session,
												 HttpServletRequest request,
												 @RequestBody Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = frontLayoutService.getLayoutMgrList(paramMap);
		}catch(Exception e){
			Message="조회에 실패 하였습니다.";
		}
		Map<String, Object> result = new HashMap<>();
		result.put("layouts", list);
		result.put("Message", Message);
		Log.DebugEnd();
		return result;
	}

	/**
	 * 레이아웃 설정 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(value="/getLayoutMgrConfig", method=RequestMethod.POST )
	public Map<String, Object> getLayoutMgrConfig(HttpSession session,
												HttpServletRequest request,
												  @RequestBody Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));

		Map<?, ?> map = new HashMap<>();
		String Message = "";
		try{
			map = frontLayoutService.getLayoutMgrConfig(paramMap);

		}catch(Exception e){
			Message="조회에 실패 하였습니다.";
		}
		Map<String, Object> result = new HashMap<>();
		result.put("Data", map);
		result.put("Message", Message);
		Log.DebugEnd();
		return result;
	}

	/**
	 * 레이아웃 설정 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(value="/getMainMenuLayout", method=RequestMethod.POST )
	public Map<String, Object> getMainMenuLayout(HttpSession session,
												  HttpServletRequest request,
												  @RequestBody Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));
		paramMap.put("grpCd", session.getAttribute("ssnGrpCd"));

		Map<?, ?> map = new HashMap<>();
		String Message = "";
		try{
			map = frontLayoutService.getLayoutMgrConfig(paramMap);

		}catch(Exception e){
			Message="조회에 실패 하였습니다.";
		}
		Map<String, Object> result = new HashMap<>();
		result.put("Data", map);
		result.put("Message", Message);
		Log.DebugEnd();
		return result;
	}


	/**
	 * 권한 리스트 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(value="/getAuthList", method=RequestMethod.POST )
	public Map<String, Object> getAuthList(HttpSession session,
													HttpServletRequest request,
													@RequestBody Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		List<?> auths  = new ArrayList<Object>();
		List<?> mainMenus  = new ArrayList<Object>();
		String Message = "";
		try{
			auths = frontLayoutService.getAuthList(paramMap);
			mainMenus = frontLayoutService.getMainMenuList(paramMap);
		}catch(Exception e){
			Message="조회에 실패 하였습니다.";
		}
		Map<String, Object> result = new HashMap<>();
		result.put("auths", auths);
		result.put("mainMenus", mainMenus);
		result.put("Message", Message);
		Log.DebugEnd();
		return result;
	}

	/**
	 * 레이아웃 리스트 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(value="/getLayoutList", method=RequestMethod.POST )
	public Map<String, Object> getLayoutList(HttpSession session,
												HttpServletRequest request,
												@RequestBody Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		List<?> layouts  = new ArrayList<Object>();
		String Message = "";
		try{
			layouts = frontLayoutService.getLayoutList(paramMap);
		}catch(Exception e){
			Message="조회에 실패 하였습니다.";
		}
		Map<String, Object> result = new HashMap<>();
		result.put("layouts", layouts);
		result.put("Message", Message);
		Log.DebugEnd();
		return result;
	}

	/**
	 * 레이아웃 배경 이미지 리스트 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(value="/getLayoutMgrImageList", method=RequestMethod.POST )
	public Map<String, Object> getLayoutMgrImageList(HttpSession session,
												HttpServletRequest request,
												@RequestBody Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = frontLayoutService.getLayoutMgrImageList(paramMap);
		}catch(Exception e){
			Message="조회에 실패 하였습니다.";
		}
		Map<String, Object> result = new HashMap<>();
		result.put("Data", list);
		result.put("Message", Message);
		Log.DebugEnd();
		return result;
	}

	/**
	 * 레이아웃 설정 저장
	 *
	 * @param session
	 * @param request
	 * @return Map
	 * @throws Exception
	 */
	@RequestMapping(value = "/saveLayoutMgrConfig")
	public Map<String, Object> saveLayoutMgrConfig(
			HttpSession session,  HttpServletRequest request,
			@RequestBody Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

		String layoutCd = paramMap.get("layoutCd").toString();
		if(layoutCd == null || layoutCd.isEmpty() ){
			LocalDateTime now = LocalDateTime.now();
			DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyyMMddHHmmssSSS");
			String uuid = UUID.randomUUID().toString();
			layoutCd = now.format(formatter) + uuid.substring(0, 8);
			paramMap.put("layoutCd", layoutCd);
		}

		String message = "";
		int resultCnt = -1;
		try{
			resultCnt = frontLayoutService.saveLayoutMgrConfig(paramMap);

			if(resultCnt > 0){ message=com.hr.common.language.LanguageUtil.getMessage("msg.alertSaveOkV1", null, "저장 되었습니다."); } else{ message=com.hr.common.language.LanguageUtil.getMessage("msg.alertSaveNoData", null, "저장된 내용이 없습니다."); }
		}catch(Exception e){
			Log.Error("Exception : "+e);
			Log.Error("resultCnt : "+resultCnt);
			resultCnt = -1; message=com.hr.common.language.LanguageUtil.getMessage("msg.alertSaveFail2", null, "저장에 실패하였습니다.");
		}

		Map<String, Object> result = new HashMap<String, Object>();
		result.put("Code", resultCnt);
		result.put("Message", message);
		result.put("LayoutCd", layoutCd);

		Log.DebugEnd();

 		return result;
	}

	/**
	 * 레이아웃 설정 삭제
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	@RequestMapping(value = "/deleteLayoutMgrConfig")
	public Map<String, Object> deleteLayoutMgrConfig(
			HttpSession session,  HttpServletRequest request,
			@RequestBody Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

		String message = "";
		int resultCnt = -1;
		try{
			resultCnt = frontLayoutService.deleteLayoutMgrConfig(paramMap);

			if(resultCnt > 0){ message=com.hr.common.language.LanguageUtil.getMessage("msg.alertSaveOkV1", null, "저장 되었습니다."); } else{ message=com.hr.common.language.LanguageUtil.getMessage("msg.alertSaveNoData", null, "저장된 내용이 없습니다."); }
		}catch(Exception e){
			Log.Error("Exception : "+e);
			Log.Error("resultCnt : "+resultCnt);
			resultCnt = -1; message=com.hr.common.language.LanguageUtil.getMessage("msg.alertSaveFail2", null, "저장에 실패하였습니다.");
		}

		Map<String, Object> result = new HashMap<String, Object>();
		result.put("Code", resultCnt);
		result.put("Message", message);

		Log.DebugEnd();

		return result;
	}

	/**
	 * 레이아웃 적용
	 *
	 * @param session
	 * @param request
	 * @return Map
	 * @throws Exception
	 */
	@RequestMapping(value = "/applyLayoutMgr")
	public Map<String, Object> applyLayoutMgr(
			HttpSession session,  HttpServletRequest request,
			@RequestBody Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

		String message = "";
		int resultCnt = -1;
		try{
			resultCnt = frontLayoutService.applyLayoutMgr(paramMap);

			if(resultCnt > 0){ message=com.hr.common.language.LanguageUtil.getMessage("msg.alertSaveOkV1", null, "저장 되었습니다."); } else{ message=com.hr.common.language.LanguageUtil.getMessage("msg.alertSaveNoData", null, "저장된 내용이 없습니다."); }
		}catch(Exception e){
			Log.Error("Exception : "+e);
			Log.Error("resultCnt : "+resultCnt);
			resultCnt = -1; message=com.hr.common.language.LanguageUtil.getMessage("msg.alertSaveFail2", null, "저장에 실패하였습니다.");
		}

		Map<String, Object> result = new HashMap<String, Object>();
		result.put("Code", resultCnt);
		result.put("Message", message);

		Log.DebugEnd();

		return result;
	}

	/**
	 * 레이아웃 배경 이미지 리스트 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(value="/getLayoutMgrWidgetList", method=RequestMethod.POST )
	public Map<String, Object> getLayoutMgrWidgetList(HttpSession session,
													 HttpServletRequest request,
													 @RequestBody Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = frontLayoutService.getLayoutMgrWidgetList(paramMap);
		}catch(Exception e){
			Message="조회에 실패 하였습니다.";
		}
		Map<String, Object> result = new HashMap<>();
		result.put("Data", list);
		result.put("Message", Message);
		Log.DebugEnd();
		return result;
	}

	/**
	 * 위젯 테스트 쿼리 검색결과 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(value="/execWidgetQuery", method=RequestMethod.POST )
	public Map<String, Object> execWidgetQuery(HttpSession session,
													 HttpServletRequest request,
													 @RequestBody Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			if(paramMap.get("query") != null && !paramMap.get("query").equals("")){
				list = frontLayoutService.execWidgetQuery(paramMap, session);
			}
		}catch(Exception e){
			Message="조회에 실패 하였습니다.";
		}
		Map<String, Object> result = new HashMap<>();
		result.put("Data", list);
		result.put("Message", Message);
		Log.DebugEnd();
		return result;
	}

	/**
	 * 위젯 설정 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(value="/getWidgetConfig", method=RequestMethod.POST )
	public Map<String, Object> getWidgetConfig(HttpSession session,
											 HttpServletRequest request,
											 @RequestBody Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));

		Map<String, Object> data  = new HashMap<>();
		String Message = "";
		try{
			data = frontLayoutService.getWidgetConfig(paramMap, session);
		}catch(Exception e){
			Message="조회에 실패 하였습니다.";
		}
		Map<String, Object> result = new HashMap<>();
		result.put("Data", data);
		result.put("Message", Message);
		Log.DebugEnd();
		return result;
	}

	/**
	 * 하위 위젯 데이터 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(value="/getSubWidgetData", method=RequestMethod.POST )
	public Map<String, Object> getSubWidgetData(HttpSession session,
											   HttpServletRequest request,
											   @RequestBody Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));

		Map<String, Object> data  = new HashMap<>();
		String Message = "";
		try{
			data = frontLayoutService.getSubWidgetData(paramMap, session);
		}catch(Exception e){
			Message="조회에 실패 하였습니다.";
		}
		Map<String, Object> result = new HashMap<>();
		result.put("Data", data);
		result.put("Message", Message);
		Log.DebugEnd();
		return result;
	}

	/**
	 * 위젯 설정 저장
	 *
	 * @param session
	 * @param request
	 * @return Map
	 * @throws Exception
	 */
	@RequestMapping(value = "/saveWidgetConfig")
	public Map<String, Object> saveWidgetConfig(
			HttpSession session,  HttpServletRequest request,
			@RequestBody Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

		String message = "";
		int resultCnt = -1;
		try{
			resultCnt = frontLayoutService.saveWidgetConfig(paramMap);

			if(resultCnt > 0){ message=com.hr.common.language.LanguageUtil.getMessage("msg.alertSaveOkV1", null, "저장 되었습니다."); } else{ message=com.hr.common.language.LanguageUtil.getMessage("msg.alertSaveNoData", null, "저장된 내용이 없습니다."); }
		}catch(Exception e){
			Log.Error("Exception : "+e);
			Log.Error("resultCnt : "+resultCnt);
			resultCnt = -1; message=com.hr.common.language.LanguageUtil.getMessage("msg.alertSaveFail2", null, "저장에 실패하였습니다.");
		}

		Map<String, Object> result = new HashMap<String, Object>();
		result.put("Code", resultCnt);
		result.put("Message", message);

		Log.DebugEnd();

		return result;
	}


	/**
	 * 위젯 메뉴 이동을 위한 surl 조회
	 *
	 * @param session
	 * @param request
	 * @return Map
	 * @throws Exception
	 */
	@RequestMapping(value="/widgetActionMoveMenu", method=RequestMethod.POST )
	public Map<?, ?> widgetActionMoveMenu(HttpSession session,
								 HttpServletRequest request,
								 @RequestBody Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));

		Map<?, ?> data  = new HashMap<>();
		String Message = "";
		try{
			data = frontLayoutService.widgetActionMoveMenu(paramMap);
		}catch(Exception e){
			Message="조회에 실패 하였습니다.";
		}
		Map<String, Object> result = new HashMap<>();
		result.put("Data", data);
		result.put("Message", Message);
		Log.DebugEnd();
		return result;
	}

	/**
	 * 위젯 새창에서 열기 위한 URL 리턴
	 * 새창 띄우기 전 SSO 등 전처리 작업이 필요하다면 여기서 작업하도록 한다.
	 *
	 * @param session
	 * @param request
	 * @return Map
	 * @throws Exception
	 */
	@RequestMapping(value="/widgetActionOpenNewWindow", method=RequestMethod.POST )
	public Map<?, ?> widgetActionOpenNewWindow(HttpSession session,
								 HttpServletRequest request,
								 @RequestBody Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));

		Map<?, ?> data  = new HashMap<>();
		String Message = "";
		try{
			data = frontLayoutService.widgetActionOpenNewWindow(paramMap);
		}catch(Exception e){
			Message="조회에 실패 하였습니다.";
		}
		Map<String, Object> result = new HashMap<>();
		result.put("Data", data);
		result.put("Message", Message);
		Log.DebugEnd();
		return result;
	}
}
