package com.hr.pap.appMtlPappMemMgr;

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
 * SAVE DATA Controller
 */
@Controller
@RequestMapping(value="/AppMtlPappMemMgr.do", method=RequestMethod.POST )
public class AppMtlPappMemMgrController extends ComController {

	/**
	 * SAVE DATA 서비스
	 */
	@Inject
	@Named("AppMtlPappMemMgrService")
	private AppMtlPappMemMgrService appMtlPappMemMgrService;
	
	/**
	 *  View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewAppMtlPappMemMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewAppMtlPappMemMgr() throws Exception {
		return "pap/appMtlPappMemMgr/appMtlPappMemMgr";
	}

	/**
	 * 피평가자 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 *//*
	@RequestMapping(params="cmd=getAppMtlPappMemMgrList1", method = RequestMethod.POST )
	public ModelAndView getAppMtlPappMemMgrList1(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}

	*//**
	 * 평가자 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 *//*
	@RequestMapping(params="cmd=getAppMtlPappMemMgrList2", method = RequestMethod.POST )
	public ModelAndView getAppMtlPappMemMgrList2(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}*/

	/**
	 * 평가 적용 가능 대상 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAppMtlPappMemMgrList3", method = RequestMethod.POST )
	public ModelAndView getAppMtlPappMemMgrList3(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}
/*
	*//**
	 * 피평가자 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 *//*
	@RequestMapping(params="cmd=saveAppMtlPappMemMgr", method = RequestMethod.POST )
	public ModelAndView saveAppMtlPappMemMgr(
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
			resultCnt = appMtlPappMemMgrService.saveAppMtlPappMemMgr(convertMap);
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

	*//**
	 * 피평가자 초기화
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return
	 * @throws Exception
	 *//*
	@RequestMapping(params="cmd=initializeAppMtlPappMem", method = RequestMethod.POST )
	public ModelAndView initializeAppMtlPappMem(HttpSession session,
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

			cnt = appMtlPappMemMgrService.initializeAppMtlPappMem(paramMap);
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
	}*/
}
