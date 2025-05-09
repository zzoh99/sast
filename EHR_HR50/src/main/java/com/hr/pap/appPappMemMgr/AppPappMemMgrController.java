package com.hr.pap.appPappMemMgr;

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
 * 평가자맵핑 Controller
 */
@Controller
@RequestMapping(value="/AppPappMemMgr.do", method=RequestMethod.POST )
public class AppPappMemMgrController extends ComController {

	/**
	 * 평가자맵핑 서비스
	 */
	@Inject
	@Named("AppPappMemMgrService")
	private AppPappMemMgrService appPappMemMgrService;
	
	/**
	 * 평가자맵핑 View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewAppPappMemMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewAppPappMemMgr() throws Exception {
		return "pap/appPappMemMgr/appPappMemMgr";
	}
	
	/**
	 * 평가자 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAppPappMemMgrList1", method = RequestMethod.POST )
	public ModelAndView getAppPappMemMgrList1(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}
	
	/**
	 * 피평가자 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAppPappMemMgrList2", method = RequestMethod.POST )
	public ModelAndView getAppPappMemMgrList2(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}
	
	/**
	 * 평가자 미적용자 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAppPappMemMgrList3", method = RequestMethod.POST )
	public ModelAndView getAppPappMemMgrList3(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}
	
	/**
	 * 평가자 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveAppPappMemMgr", method = RequestMethod.POST )
	public ModelAndView saveAppPappMemMgr(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		convertMap.put("searchAppSabun", paramMap.get("searchAppSabun"));

		String message = "";
		int resultCnt = -1;
		try{
			resultCnt = appPappMemMgrService.saveAppPappMemMgr(convertMap);
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
	 * 평가자 초기화
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=deleteInitializeAppPappMem", method = RequestMethod.POST )
	public ModelAndView deleteInitializeAppPappMem(HttpSession session,
			HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnSabun", 		session.getAttribute("ssnSabun"));
		paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));

		String message = "";
		String appSeqNm = (String) paramMap.get("appSeqNm");
		Map<String, Object> resultMap = new HashMap<String, Object>();
		int cnt = 0;
		try{

			cnt = appPappMemMgrService.deleteInitializeAppPappMem(paramMap);
			if (cnt > 0) {
				message = String.format("[%s] 초기화를 완료하였습니다.", appSeqNm);
			}  else {
				message="저장된 내용이 없습니다.";
			}
			
		}catch(Exception e){
			cnt=-1;
			message = String.format("[%s] 초기화에 실패하였습니다. ", appSeqNm);
		}

		resultMap.put("Code", 		cnt);
		resultMap.put("Message", 	message);

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Result", resultMap);

		Log.Debug("Result Message : " + mv);
		Log.DebugEnd();
		return mv;
	}
}
