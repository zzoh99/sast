package com.hr.pap.config.appGroupMgrCopyPop;
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
 * 평가그룹설정 - 평가범위설정 Controller 
 * 
 * @author jcy
 *
 */
@Controller
@RequestMapping({"/AppGroupMgrRngPop.do","/CompAppraisalGubun.do"})
public class AppGroupMgrRngPopController {
	/**
	 * 평가그룹설정 - 평가범위설정 서비스
	 */
	@Inject
	@Named("AppGroupMgrRngPopService")
	private AppGroupMgrRngPopService appGroupMgrRngPopService;
	/**
	 * 평가그룹설정 - 평가범위설정 View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewAppGroupMgrRngPop", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewAppGroupMgrRngPop() throws Exception {
		return "pap/config/appGroupMgr/appGroupMgrRngPop";
	}
	/**
	 * 평가그룹설정 - 평가범위설정 View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewAppGroupMgrRngOrgPop", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewAppGroupMgrRngOrgPop() throws Exception {
		return "pap/config/appGroupMgr/appGroupMgrRngOrgPop";
	}
	/**
	 * 평가그룹설정 - 평가범위설정 View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewAppGroupMgrRngPersonPop", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewAppGroupMgrRngPersonPop() throws Exception {
		return "pap/config/appGroupMgr/appGroupMgrRngPersonPop";
	}
	
	/**
	 * 평가그룹설정 - 평가범위설정 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAppGroupMgrRngPopList2", method = RequestMethod.POST )
	public ModelAndView getAppGroupMgrRngPopList2(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		List<?> list  = new ArrayList<Object>();
		String message = "";
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		try{
			Map<?, ?> query = appGroupMgrRngPopService.getAppGroupMgrRngPopTempQueryMap(paramMap);
			if(query != null) {
				paramMap.put("query",query.get("query"));
				list = appGroupMgrRngPopService.getAppGroupMgrRngPopList2(paramMap);
			} else {
				message="조회에 실패하였습니다.";
			}
		}catch(Exception e){
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
	 * 평가그룹설정 - 평가범위설정 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAppGroupMgrRngPopList3", method = RequestMethod.POST )
	public ModelAndView getAppGroupMgrRngPopList3(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		List<?> list  = new ArrayList<Object>();
		String Message = "";
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		try{
			
			list = appGroupMgrRngPopService.getAppGroupMgrRngPopList3(paramMap);
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
	 * 평가그룹설정 - 평가범위설정 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAppGroupMgrRngPopList4", method = RequestMethod.POST )
	public ModelAndView getAppGroupMgrRngPopList4(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		List<?> list  = new ArrayList<Object>();
		String Message = "";
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		try{
			
			list = appGroupMgrRngPopService.getAppGroupMgrRngPopList4(paramMap);
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
	 * 평가그룹설정 - 평가범위설정 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAppGroupMgrRngPopList5", method = RequestMethod.POST )
	public ModelAndView getAppGroupMgrRngPopList5(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		List<?> list  = new ArrayList<Object>();
		String Message = "";
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		try{
			
			list = appGroupMgrRngPopService.getAppGroupMgrRngPopList5(paramMap);
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
	 * 평가그룹설정 - 평가범위설정 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAppGroupMgrRngPopList6", method = RequestMethod.POST )
	public ModelAndView getAppGroupMgrRngPopList6(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		List<?> list  = new ArrayList<Object>();
		String Message = "";
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		try{
			
			list = appGroupMgrRngPopService.getAppGroupMgrRngPopList6(paramMap);
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
	 * 평가그룹설정 - 평가범위설정 단건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAppGroupMgrRngPopMap", method = RequestMethod.POST )
	public ModelAndView getAppGroupMgrRngPopMap(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		Map<?, ?> map = appGroupMgrRngPopService.getAppGroupMgrRngPopMap(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("map", map);
		Log.DebugEnd();
		return mv;
	}
	/**
	 * 평가그룹설정 - 평가범위설정 저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveAppGroupMgrRngPop", method = RequestMethod.POST )
	public ModelAndView saveAppGroupMgrRngPop(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		
		convertMap.put("searchUseGubun",paramMap.get("searchUseGubun"));
		convertMap.put("searchItemValue1",paramMap.get("searchItemValue1"));
		convertMap.put("searchItemValue2",paramMap.get("searchItemValue2"));
		convertMap.put("searchItemValue3",paramMap.get("searchItemValue3"));
		convertMap.put("searchAuthScopeCd",paramMap.get("searchAuthScopeCd"));
		
		
		
		String message = "";
		int resultCnt = -1;
		try{
			resultCnt =appGroupMgrRngPopService.saveAppGroupMgrRngPop(convertMap);
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

}
