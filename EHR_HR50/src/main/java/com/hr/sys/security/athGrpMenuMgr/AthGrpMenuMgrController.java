package com.hr.sys.security.athGrpMenuMgr;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import com.hr.common.security.SecurityMgrService;
import com.nhncorp.lucy.security.xss.XssFilter;
import com.nhncorp.lucy.security.xss.XssPreventer;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;
/**
 * 권한그룹프로그램관리 Controller 
 * 
 * @author ParkMoohun
 *
 */
@Controller
@RequestMapping(value="/AthGrpMenuMgr.do", method=RequestMethod.POST )
public class AthGrpMenuMgrController {
	/**
	 * 권한그룹프로그램관리 서비스
	 */
	@Inject
	@Named("AthGrpMenuMgrService")
	private AthGrpMenuMgrService athGrpMenuMgrService;

	@Autowired
	private SecurityMgrService securityMgrService;

	/**
	 * 권한그룹프로그램관리 View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewAthGrpMenuMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewAthGrpMenuMgr() throws Exception {
		return "sys/security/athGrpMenuMgr/athGrpMenuMgr";
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
	@RequestMapping(params="cmd=getAthGrpMenuMgrLeftList", method = RequestMethod.POST )
	public ModelAndView getAthGrpMenuMgrLeftList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		List<?> list  = new ArrayList<Object>();
		String Message = "";
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		try{
			list = athGrpMenuMgrService.getAthGrpMenuMgrLeftList(paramMap);
		}catch(Exception e){
			Message="조회에 실패 하였습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
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
	@RequestMapping(params="cmd=getAthGrpMenuMgrRightList", method = RequestMethod.POST )
	public ModelAndView getAthGrpMenuMgrRightList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		List<?> list  = new ArrayList<Object>();
		String Message = "";
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		try{
			list = athGrpMenuMgrService.getAthGrpMenuMgrRightList(paramMap);
		}catch(Exception e){
			Message="조회에 실패 하였습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
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
	@RequestMapping(params="cmd=insertAthGrpMenuMgr", method = RequestMethod.POST )
	public ModelAndView insertAthGrpMenuMgr(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		
		String message = "";
		int resultCnt = -1;
		try{
			resultCnt =athGrpMenuMgrService.insertAthGrpMenuMgr(convertMap);
			if(resultCnt > 0){ message="저장 되었습니다."; } else{ message="저장된 내용이 없습니다."; }
		}catch(Exception e){
			resultCnt = -1; message="저장에 실패하 였습니다.";
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
/*	
	@RequestMapping(params="cmd=deleteAthGrpMenuMgr", method = RequestMethod.POST )
	public ModelAndView saveAthGrpMenuMgr(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		
		String message = "";
		int resultCnt = -1;
		try{
			resultCnt =athGrpMenuMgrService.deleteAthGrpMenuMgr(convertMap);
			if(resultCnt > 0){ message="저장 되었습니다."; } else{ message="저장된 내용이 없습니다."; }
		}catch(Exception e){
			resultCnt = -1; message="저장에 실패하 였습니다.";
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
*/	
	
	/**
	 * 권한그룹프로그램관리 - 권한별 프로그램 세부내역 Popup 
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=athGrpMenuMgrRegPopup", method = RequestMethod.POST )
	public String athGrpMenuMgrRegPopup() throws Exception {
		return "sys/security/athGrpMenuMgr/athGrpMenuMgrRegPopup";
	}
	/**
	 * 권한그룹프로그램관리 - 등록된 권한별 프로그램 세부내역 Popup 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAthGrpMenuMgrRegPopupList", method = RequestMethod.POST )
	public ModelAndView getAthGrpMenuMgrPopupList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		List<?> list  = new ArrayList<Object>();
		String Message = "";
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		try{
			list = athGrpMenuMgrService.getAthGrpMenuMgrRegPopupList(paramMap);
		}catch(Exception e){
			Message="조회에 실패 하였습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}
	/**
	 * 권한그룹프로그램관리 - 등록된 권한별 프로그램 세부내역 Popup 저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveAthGrpMenuMgrRegPopup", method = RequestMethod.POST )
	public ModelAndView saveAthGrpMenuMgrPopup(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		String message = "";
		int resultCnt = -1;
		try{

			List<Map> insertList = (List<Map>)convertMap.get("insertRows");
			List<Map> mergeList = (List<Map>)convertMap.get("mergeRows");

			for(Map<String, Object> mp : insertList) {
				for (Map.Entry<String, Object> e : mp.entrySet()) {
					String k = e.getKey();
					Object v = e.getValue();

					mp.put(k, securityMgrService.filterInput(v));
				}
			}

			for(Map<String, Object> mp : mergeList) {
				for (Map.Entry<String, Object> e : mp.entrySet()) {
					String k = e.getKey();
					Object v = e.getValue();

					mp.put(k, securityMgrService.filterInput(v));
				}
			}

			convertMap.put("insertRows", insertList);
			convertMap.put("mergeRows", mergeList);

			resultCnt = athGrpMenuMgrService.saveAthGrpMenuMgrRegPopup(convertMap);
			if(resultCnt > 0){ message="저장되었습니다."; } else{ message="저장된 내용이 없습니다."; }
		}catch(Exception e){
			resultCnt = -1; message="저장에 실패하 였습니다.";
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
	 * 권한그룹프로그램관리 - 등록가능  권한별 프로그램 세부내역 Popup 
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=athGrpMenuMgrNoneRegPopup", method = RequestMethod.POST )
	public String athGrpMenuMgrNoneRegPopup() throws Exception {
		return "sys/security/athGrpMenuMgr/athGrpMenuMgrNoneRegPopup";
	}
	/**
	 * 권한그룹프로그램관리 - 등록가능  권한별 프로그램 세부내역 Popup 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAthGrpMenuMgrNoneRegPopupList", method = RequestMethod.POST )
	public ModelAndView getAthGrpMenuMgrNoneRegPopupList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		List<?> list  = new ArrayList<Object>();
		String Message = "";
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		try{
			list = athGrpMenuMgrService.getAthGrpMenuMgrNoneRegPopupList(paramMap);
		}catch(Exception e){
			Message="조회에 실패 하였습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}
	
	/**
	 * 권한프로그램관리 그룹간 복사
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=copyAthGrpMenuMgr", method = RequestMethod.POST )
	public ModelAndView copyAthGrpMenuMgr(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		String message = "";
		int resultCnt = -1;
		try{
			resultCnt = athGrpMenuMgrService.copyAthGrpMenuMgr(paramMap);
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