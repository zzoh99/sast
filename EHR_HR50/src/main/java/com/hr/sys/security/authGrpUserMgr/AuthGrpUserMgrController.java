package com.hr.sys.security.authGrpUserMgr;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
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

import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;
/**
 * 권한그룹사용자관리 Controller
 *
 * @author CBS
 *
 */
@Controller
@RequestMapping(value="/AuthGrpUserMgr.do", method=RequestMethod.POST )
public class AuthGrpUserMgrController {
	/**
	 * 권한그룹사용자관리 서비스
	 */
	@Inject
	@Named("AuthGrpUserMgrService")
	private AuthGrpUserMgrService authGrpUserMgrService;

	/**
	 * 권한그룹사용자관리 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewAuthGrpUserMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewAuthGrpUserMgr() throws Exception {
		return "sys/security/authGrpUserMgr/authGrpUserMgr";
	}

	/**
	 * 권한그룹사용자관리 sheet1 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAuthGrpUserMgrSheet1List", method = RequestMethod.POST )
	public ModelAndView getAuthGrpUserMgrSheet1List(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		List<?> list  = new ArrayList<Object>();
		String Message = "";
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		try{
			list = authGrpUserMgrService.getAuthGrpUserMgrSheet1List(paramMap);
		}catch(Exception e){
			Message="조회에 실패하였습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}
	/**
	 * 권한그룹사용자관리 sheet2 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAuthGrpUserMgrSheet2List", method = RequestMethod.POST )
	public ModelAndView getAuthGrpUserMgrSheet2List(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		List<?> list  = new ArrayList<Object>();
		String Message = "";
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		try{
			list = authGrpUserMgrService.getAuthGrpUserMgrSheet2List(paramMap);
		}catch(Exception e){
			Message="조회에 실패하였습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 권한그룹사용자관리 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveAuthGrpUserMgr", method = RequestMethod.POST )
	public ModelAndView saveAuthGrpUserMgr(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

		String message = "";
		int resultCnt = -1;
		try{
			resultCnt =authGrpUserMgrService.saveAuthGrpUserMgr(convertMap);
			if(resultCnt > 0){ message="저장되었습니다."; } else{ message="저장된 내용이 없습니다."; }
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
	 * 권한그룹사용자관리 삭제
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=deleteAuthGrpUserMgr", method = RequestMethod.POST )
	public ModelAndView deleteAuthGrpUserMgr(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		String getParamNames ="sNo,sDelete,sStatus,grpCd,sabun,dataRwType,searchType";
		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,getParamNames,"");
		convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

		String message = "";
		int resultCnt = -1;
		try{
			resultCnt = authGrpUserMgrService.deleteAuthGrpUserMgr(convertMap);
			if(resultCnt > 0){ message="삭제되었습니다."; } else{ message="삭제된 내용이 없습니다."; }
		}catch(Exception e){
			resultCnt = -1; message="삭제에 실패하였습니다.";
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
	 * 권한범위 설정 팝업 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewAuthGrpUserMgrScopePopup", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewAuthGrpUserMgrScopePopup() throws Exception {
		return "sys/security/authGrpUserMgr/authGrpUserMgrScopePopup";
	}
	
	@RequestMapping(params="cmd=viewAuthGrpUserMgrScopeLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewAuthGrpUserMgrScopeLayer() throws Exception {
		return "sys/security/authGrpUserMgr/authGrpUserMgrScopeLayer";
	}

	/**
	 * 권한범위 설정 팝업 sheet1 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAuthGrpUserMgrScopePopupSheet1List", method = RequestMethod.POST )
	public ModelAndView getAuthGrpUserMgrScopePopupSheet1List(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		List<?> list  = new ArrayList<Object>();
		String Message = "";
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		try{
			list = authGrpUserMgrService.getAuthGrpUserMgrScopePopupSheet1List(paramMap);
		}catch(Exception e){
			Message="조회에 실패하였습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 권한범위 설정 팝업 범위항목 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAuthGrpUserMgrScopePopupSheet2List", method = RequestMethod.POST )
	public ModelAndView getAppGroupMgrRngPopList2(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		List<?> list  = new ArrayList<Object>();
		String message = "";
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		try {
			Map<?, ?> query = authGrpUserMgrService.getAuthGrpUserMgrScopePopupSheet2Query(paramMap);
			if(query != null) {
				paramMap.put("query", query.get("query"));
				list = authGrpUserMgrService.getAuthGrpUserMgrScopePopupSheet2List(paramMap);
			} else {
				message="조회에 실패하였습니다.";
			}
		} catch(Exception e){
			message="조회에 실패하였습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", message);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 권한범위 설정 팝업 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveAuthGrpUserMgrScopePopup", method = RequestMethod.POST )
	public ModelAndView saveAuthGrpUserMgrScopePopup(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

		String message = "";
		int resultCnt = -1;
		try{
			resultCnt =authGrpUserMgrService.saveAuthGrpUserMgrScopePopup(convertMap);
			if(resultCnt > 0){ message="저장되었습니다."; } else{ message="저장된 내용이 없습니다."; }
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
	 * 권한범위 설정(조직) 팝업 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewAuthGrpUserMgrScopeOrgPopup", method = {RequestMethod.POST, RequestMethod.GET} )
	public String authGrpUserMgrScopeOrgPopup() throws Exception {
		return "sys/security/authGrpUserMgr/authGrpUserMgrScopeOrgPopup";
	}
	
	@RequestMapping(params="cmd=viewAuthGrpUserMgrScopeOrgLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewAuthGrpUserMgrScopeOrgPopup() throws Exception {
		return "sys/security/authGrpUserMgr/authGrpUserMgrScopeOrgLayer";
	}
	

	/**
	 * 권한범위 설정(조직) 팝업 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewAuthGrpUserMgrScopePerPopup", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewAuthGrpUserMgrScopePerPopup() throws Exception {
		return "sys/security/authGrpUserMgr/authGrpUserMgrScopePerPopup";
	}

	/**
	 * 권한범위 설정(조직) 팝업 sheet1 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAuthGrpUserMgrScopeOrgPopupList", method = RequestMethod.POST )
	public ModelAndView getAuthGrpUserMgrScopeOrgPopupList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		List<?> list  = new ArrayList<Object>();
		String Message = "";
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		try{
			list = authGrpUserMgrService.getAuthGrpUserMgrScopeOrgPopupList(paramMap);
		}catch(Exception e){
			Message="조회에 실패하였습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 권한범위 설정(사원) - 평가범위설정 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAuthGrpUserMgrPopList4", method = RequestMethod.POST )
	public ModelAndView getAuthGrpUserMgrPopList4(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		List<?> list  = new ArrayList<Object>();
		String Message = "";
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		try{

			list = authGrpUserMgrService.getAuthGrpUserMgrPopList4(paramMap);
		}catch(Exception e){
			Message="조회에 실패하였습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 권한범위 설정(사원) - 평가범위설정 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAuthGrpUserMgrPopList5", method = RequestMethod.POST )
	public ModelAndView getAuthGrpUserMgrPopList5(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		List<?> list  = new ArrayList<Object>();
		String Message = "";
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		try{

			list = authGrpUserMgrService.getAuthGrpUserMgrPopList5(paramMap);
		}catch(Exception e){
			Message="조회에 실패하였습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 권한범위 설정(사원) - 평가범위설정 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAuthGrpUserMgrPopList6", method = RequestMethod.POST )
	public ModelAndView getAuthGrpUserMgrPopList6(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		List<?> list  = new ArrayList<Object>();
		String Message = "";
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		try{

			list = authGrpUserMgrService.getAuthGrpUserMgrPopList6(paramMap);
		}catch(Exception e){
			Message="조회에 실패하였습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}
	
	/**
	 * 대상자 선택 팝업 팝업 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewAuthGrpUserMgrTargetPopup", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewAuthGrpUserMgrTargetPopup() throws Exception {
		return "sys/security/authGrpUserMgr/authGrpUserMgrTargetPopup";
	}
	
	/**
     * 대상자 선택 팝업 팝업 View
     *
     * @return String
     * @throws Exception
     */
    @RequestMapping(params="cmd=viewAuthGrpUserMgrTargetLayer", method = {RequestMethod.POST, RequestMethod.GET} )
    public String viewAuthGrpUserMgrTargetLayer() throws Exception {
        return "sys/security/authGrpUserMgr/authGrpUserMgrTargetLayer";
    }

	
	/**
	 * 대상자 선택 팝업 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAuthGrpUserMgrTargetPopupList", method = RequestMethod.POST )
	public ModelAndView getEduPeopleMgrPopupList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		List<?> list  = new ArrayList<Object>();
		String Message = "";
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		try{
			list = authGrpUserMgrService.getAuthGrpUserMgrTargetPopupList(paramMap);
		}catch(Exception e){
			Message="조회에 실패하였습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}
}
