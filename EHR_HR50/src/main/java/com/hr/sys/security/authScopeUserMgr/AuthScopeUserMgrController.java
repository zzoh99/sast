package com.hr.sys.security.authScopeUserMgr;
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

import com.hr.common.com.ComService;
import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;
/**
 * 사용자별 권한범위관리 Controller
 *
 *
 */
@Controller
@RequestMapping(value="/AuthScopeUserMgr.do", method=RequestMethod.POST )
public class AuthScopeUserMgrController {
	/**
	 * 공통 서비스
	 */
	@Inject
	@Named("ComService")
	private ComService comService;

	
	/**
	 * 사용자별 권한범위관리 서비스
	 */
	@Inject
	@Named("AuthScopeUserMgrService")
	private AuthScopeUserMgrService authScopeUserMgrService;
	

	
	/**
	 * 사용자 권한범위관리
	 */
	@RequestMapping(params="cmd=viewAuthScopeUserMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewAuthScopeUserMgr(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		return "sys/security/authScopeUserMgr/authScopeUserMgr";
	}
	

	/**
	 * 사용자 권한범위관리 - 팝업
	 */
	@RequestMapping(params="cmd=viewAuthScopeUserMgrPopup", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewAuthScopeUserMgrPopup(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		return "sys/security/authScopeUserMgr/authScopeUserMgrPopup";
	}
	
	/**
     * 사용자 권한범위관리 - 팝업
     */
    @RequestMapping(params="cmd=viewAuthScopeUserMgrLayer", method = {RequestMethod.POST, RequestMethod.GET} )
    public String viewAuthScopeUserMgrLayer(
            HttpSession session, HttpServletRequest request,
            @RequestParam Map<String, Object> paramMap) throws Exception {
        return "sys/security/authScopeUserMgr/authScopeUserMgrLayer";
    }
	

	/**
	 * 권한그룹 콤보 조회
	 */
	@RequestMapping(params="cmd=getAuthScopeUserMgrGrpList", method = RequestMethod.POST )
	public ModelAndView getAuthScopeUserMgrGrpList(HttpSession session,
			HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		List<?> result = comService.getDataList(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", result);
		Log.DebugEnd();
		return mv;
	}

	

	/**
	 * 권한그룹 사용자 조회
	 */
	@RequestMapping(params="cmd=getAuthScopeUserMgrList", method = RequestMethod.POST )
	public ModelAndView getAuthScopeUserMgrList(HttpSession session,
			HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		List<?> result = comService.getDataList(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", result);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 권한범위(조직) 조회
	 */
	@RequestMapping(params="cmd=getAuthScopeUserMgrOrgList", method = RequestMethod.POST )
	public ModelAndView getAuthScopeUserMgrOrgList(HttpSession session,
			HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		List<?> result = comService.getDataList(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", result);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 권한범위(사람) 조회
	 */
	@RequestMapping(params="cmd=getAuthScopeUserMgrScopeEmpList", method = RequestMethod.POST )
	public ModelAndView getAuthScopeUserMgrScopeEmpList(HttpSession session,
			HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		List<?> result = comService.getDataList(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", result);
		Log.DebugEnd();
		return mv;
	}
	
	
	/**
	 * 사용자별 권한범위관리  범위 쿼리
	 */
	@RequestMapping(params="cmd=getAuthScopeUserMgrScopeList", method = RequestMethod.POST )
	public ModelAndView getAuthScopeUserMgrScopeList1(HttpSession session,
			HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		List<?> result = comService.getDataList(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", result);
		Log.DebugEnd();
		return mv;
	}
	/**
	 * 범위항목
	 */
	@RequestMapping(params="cmd=getAuthScopeUserMgrScopeOthList", method = RequestMethod.POST )
	public ModelAndView getAuthScopeUserMgrScopeOthList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		List<?> list  = new ArrayList<Object>();
		String message = "";
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		try{
			//권한범위(사람,조직 외) 쿼리 조회
			paramMap.put("cmd","getAuthScopeUserMgrScopeList1");
			Map<?, ?> query = comService.getDataMap(paramMap);

			if(query != null) {
				paramMap.put("query",query.get("query"));
				paramMap.put("cmd","getAuthScopeUserMgrScopeList2");
				list = comService.getDataList(paramMap);
			} else {
				message=com.hr.common.language.LanguageUtil.getMessage("msg.alertMsg13", null, "조회에 실패 하였습니다.");
			}
		}catch(Exception e){
			message=com.hr.common.language.LanguageUtil.getMessage("msg.alertMsg13", null, "조회에 실패 하였습니다.");
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", message);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 권한범위 대상자 조회(팝업)
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAuthScopeUserMgrPopupList", method = RequestMethod.POST )
	public ModelAndView getAuthScopeUserMgrPopupList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		List<?> list  = new ArrayList<Object>();
		String message = "";
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		try{

			paramMap.put("cmd","getAuthScopeUserMgrPopupList1");
			Map<?, ?> query = comService.getDataMap(paramMap);
			if(query != null) {
				paramMap.put("query",query.get("query"));
				paramMap.put("cmd","getAuthScopeUserMgrPopupList2");
				list = comService.getDataList(paramMap);
			} else {
				message=com.hr.common.language.LanguageUtil.getMessage("msg.alertMsg13", null, "조회에 실패 하였습니다.");
			}
		}catch(Exception e){
			message=com.hr.common.language.LanguageUtil.getMessage("msg.alertMsg13", null, "조회에 실패 하였습니다.");
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", message);
		Log.DebugEnd();
		return mv;
	}
	

	/**
	 * 사용자별 권한범위관리 사용자 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveAuthScopeUserMgrUser", method = RequestMethod.POST )
	public ModelAndView saveAuthScopeUserMgrUser(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		
		String message = "";
		int resultCnt = -1;
		try{
			resultCnt = authScopeUserMgrService.saveAuthScopeUserMgrUser(convertMap);
			
			if(resultCnt > 0){ message=com.hr.common.language.LanguageUtil.getMessage("msg.alertSaveOkV1", null, "저장 되었습니다."); } else{ message=com.hr.common.language.LanguageUtil.getMessage("msg.alertSaveNoData", null, "저장된 내용이 없습니다."); }
			
		}catch(Exception e){
			
			resultCnt = -1; message=com.hr.common.language.LanguageUtil.getMessage("msg.alertSaveFail2", null, "저장에 실패하였습니다.");
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
	 * 사용자별 권한범위관리 범위 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveAuthScopeUserMgr", method = RequestMethod.POST )
	public ModelAndView saveAuthScopeUserMgr(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		
		String message = "";
		int resultCnt = -1;
		try{
			resultCnt = authScopeUserMgrService.saveAuthScopeUserMgr(convertMap);
			
			if(resultCnt > 0){ message=com.hr.common.language.LanguageUtil.getMessage("msg.alertSaveOkV1", null, "저장 되었습니다."); } else{ message=com.hr.common.language.LanguageUtil.getMessage("msg.alertSaveNoData", null, "저장된 내용이 없습니다."); }
			
		}catch(Exception e){
			
			resultCnt = -1; message=com.hr.common.language.LanguageUtil.getMessage("msg.alertSaveFail2", null, "저장에 실패하였습니다.");
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
