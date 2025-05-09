package com.hr.pap.appGroupMemMgr;
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
 * 평가그룹매핑 Controller
 */
@Controller
@RequestMapping(value="/AppGroupMemMgr.do", method=RequestMethod.POST )
public class AppGroupMemMgrController extends ComController {

	/**
	 * 평가그룹매핑 서비스
	 */
	@Inject
	@Named("AppGroupMemMgrService")
	private AppGroupMemMgrService appGroupMemMgrService;
	
	/**
	 * 평가자맵핑 View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewAppGroupMemMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewAppGroupMemMgr() throws Exception {
		return "pap/appGroupMemMgr/appGroupMemMgr";
	}
	
	/**
	 * 평가그룹 적용 인원 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAppGroupMemMgrList1", method = RequestMethod.POST )
	public ModelAndView getAppGroupMemMgrList1(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}
	
	/**
	 * 대상자 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAppGroupMemMgrList2", method = RequestMethod.POST )
	public ModelAndView getAppGroupMemMgrList2(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}
	
	/**
	 * 평가그룹 미적용자 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAppGroupMemMgrList3", method = RequestMethod.POST )
	public ModelAndView getAppGroupMemMgrList3(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}
	
	/**
	 * 평가그룹 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveAppGroupMemMgr", method = RequestMethod.POST )
	public ModelAndView saveAppGroupMemMgr(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		convertMap.put("searchAppGroupCd", paramMap.get("searchAppGroupCd"));

		String message = "";
		int resultCnt = -1;
		try{
			resultCnt = appGroupMemMgrService.saveAppGroupMemMgr(convertMap);
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
	 * 평가그룹 초기화
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=updateInitializeAppGroupMem", method = RequestMethod.POST )
	public ModelAndView updateInitializeAppGroupMem(HttpSession session,
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

			cnt = appGroupMemMgrService.updateInitializeAppGroupMem(paramMap);
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