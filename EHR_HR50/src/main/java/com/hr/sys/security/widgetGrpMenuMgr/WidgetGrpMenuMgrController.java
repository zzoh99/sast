package com.hr.sys.security.widgetGrpMenuMgr;
import java.util.HashMap;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.hr.common.com.ComController;
import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;
/**
 * 권한그룹프로그램관리 Controller 
 * 
 * @author ParkMoohun
 *
 */
@Controller
@RequestMapping(value="/WidgetGrpMenuMgr.do", method=RequestMethod.POST ) 
public class WidgetGrpMenuMgrController extends ComController {
	/**
	 * 권한그룹프로그램관리 서비스
	 */
	@Inject
	@Named("WidgetGrpMenuMgrService")
	private WidgetGrpMenuMgrService widgetGrpMenuMgrService;
	/**
	 * 권한그룹프로그램관리 View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewWidgetGrpMenuMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewWidgetGrpMenuMgr() throws Exception {
		return "sys/security/widgetGrpMenuMgr/widgetGrpMenuMgr";
	}
	
	/**
	 * 권한그룹프로그램관리 등록메인메뉴 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getWidgetGrpMenuMgrLeftList", method = RequestMethod.POST )
	public ModelAndView getWidgetGrpMenuMgrLeftList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}
	
	/**
	 * 권한그룹프로그램관리 등록가능메인메뉴 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getWidgetGrpMenuMgrRightList", method = RequestMethod.POST )
	public ModelAndView getWidgetGrpMenuMgrRightList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}
	
	/**
	 * 권한그룹프로그램관리 등록
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=insertWidgetGrpMenuMgr", method = RequestMethod.POST )
	public ModelAndView insertWidgetGrpMenuMgr(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		
		String message = "";
		int resultCnt = -1;
		try{
			resultCnt =widgetGrpMenuMgrService.insertWidgetGrpMenuMgr(convertMap);
			if(resultCnt > 0){ message="저장 되었습니다."; } else{ message="저장된 내용이 없습니다."; }
		}catch(Exception e){
			resultCnt = -1; message="저장에 실패하였습니다.";
		}
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("Code", resultCnt);
		resultMap.put("Message", message);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Result", resultMap);
		Log.DebugEnd();
		return mv;
	}
	
	/**
	 * 권한그룹프로그램관리 삭제
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=deleteWidgetGrpMenuMgr", method = RequestMethod.POST )
	public ModelAndView deleteWidgetGrpMenuMgr(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		
		String message = "";
		int resultCnt = -1;
		try{
			resultCnt =widgetGrpMenuMgrService.deleteWidgetGrpMenuMgr(convertMap);
			if(resultCnt > 0){ message="저장 되었습니다."; } else{ message="저장된 내용이 없습니다."; }
		}catch(Exception e){
			resultCnt = -1; message="저장에 실패하였습니다.";
		}
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("Code", resultCnt);
		resultMap.put("Message", message);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Result", resultMap);
		Log.DebugEnd();
		return mv;
	}
	
	@RequestMapping(params="cmd=saveWidgetGrpMenuMgr", method = RequestMethod.POST )
	public ModelAndView saveWidgetGrpMenuMgr(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return saveData(session, request, paramMap);
	}


	@RequestMapping(params="cmd=prcWidgetGrpMenuMgrCre", method = RequestMethod.POST )
	public ModelAndView prcWidgetGrpMenuMgrCre(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return execPrc(session, request, paramMap);
	}

	/**
	 * 위젯권한관리 그룹간 복사
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=copyWidgetGrpMenuMgr", method = RequestMethod.POST )
	public ModelAndView copyWidgetGrpMenuMgr(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));

		String message = "";
		int resultCnt = -1;
		try{
			resultCnt = widgetGrpMenuMgrService.copyWidgetGrpMenuMgr(paramMap);
			if(resultCnt > 0){ message="복사 되었습니다."; }
		}catch(Exception e){
			resultCnt = -1; message="복사 실패 하였습니다.";
		}

		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("Code", resultCnt);
		resultMap.put("Message", message);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Result", resultMap);
		Log.DebugEnd();
		return mv;
	}
}