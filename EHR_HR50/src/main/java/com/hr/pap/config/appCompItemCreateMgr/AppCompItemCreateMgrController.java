package com.hr.pap.config.appCompItemCreateMgr;
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

import com.hr.common.code.CommonCodeService;
import com.hr.common.com.ComController;
import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;
/**
 * 역량평가표생성관리 Controller 
 * 
 * @author JSG
 *
 */
@Controller
@RequestMapping(value="/AppCompItemCreateMgr.do", method=RequestMethod.POST ) 
public class AppCompItemCreateMgrController extends ComController {
	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;
	
	/**
	 * 사용할 서비스 선언
	 */
	@Inject
	@Named("AppCompItemCreateMgrService")
	private AppCompItemCreateMgrService appCompItemCreateMgrService;
	
	/**
	 * 역량평가표생성관리 View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewAppCompItemCreateMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewAppCompItemCreateMgr() throws Exception {
		return "pap/config/appCompItemCreateMgr/appCompItemCreateMgr";
	}

	/**
	 * 역량평가표생성관리 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAppCompItemCreateMgrList", method = RequestMethod.POST )
	public ModelAndView getAppCompItemCreateMgrList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}
	
	/**
	 * 역량평가표생성관리 단건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAppCompItemCreateMgrMap", method = RequestMethod.POST )
	public ModelAndView getAppCompItemCreateMgrMap(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		Map<?, ?> map = appCompItemCreateMgrService.getAppCompItemCreateMgrMap(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("resultMap", map);
		Log.DebugEnd();
		return mv;
	}
	
	/**
	 * 역량평가표생성관리 저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveAppCompItemCreateMgr", method = RequestMethod.POST )
	public ModelAndView saveAppCompItemCreateMgr(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		convertMap.put("ssnSabun", session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		
		String message = "";
		int resultCnt = -1;
		try{
			resultCnt = appCompItemCreateMgrService.saveAppCompItemCreateMgr(convertMap);
			if(resultCnt > 0){ message="저장되었습니다."; }
			else{ message="저장된 내용이 없습니다."; }
		}catch(Exception e){
			resultCnt = -1;
			message="저장에 실패하였습니다.";
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
	 * 역량평가표생성관리 - 역량평가표를 생성 프로시저 호출
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=prcAppCompItemCreateMgr", method = RequestMethod.POST )
	public ModelAndView prcAppCompItemCreateMgr(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();  
		return execPrc(session, request, paramMap);
	}
	
	/**
	 * 역량평가표생성관리 생성
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=insertAppCompItemCreateMgr", method = RequestMethod.POST )
	public ModelAndView insertAppCompItemCreateMgr(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();
		String getParamNames ="sNo,sDelete,sStatus,prgCd,prgNm,prgEngNm,prgPath,use,version,memo,dateTrackYn,logSaveYn";
		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,getParamNames,"");
		convertMap.put("ssnSabun", session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		
		String message = "";
		int resultCnt = -1;
		try{
			resultCnt = appCompItemCreateMgrService.insertAppCompItemCreateMgr(convertMap);
			if(resultCnt > 0){ message="생성 되었습니다."; }
			else{ message="생성된 내용이 없습니다."; }
		}catch(Exception e){
			resultCnt = -1;
			message="생성에 실패하였습니다.";
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
	 * 역량평가표생성관리 수정
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=updateAppCompItemCreateMgr", method = RequestMethod.POST )
	public ModelAndView updateAppCompItemCreateMgr(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		String getParamNames ="sNo,sDelete,sStatus,prgCd,prgNm,prgEngNm,prgPath,use,version,memo,dateTrackYn,logSaveYn";
		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,getParamNames,"");
		convertMap.put("ssnSabun", session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		
		String message = "";
		int resultCnt = -1;
		try{
			resultCnt = appCompItemCreateMgrService.updateAppCompItemCreateMgr(convertMap);
			if(resultCnt > 0){ message="수정되었습니다."; }
			else{ message="수정된 내용이 없습니다."; }
		}catch(Exception e){
			resultCnt = -1;
			message="수정에 실패하였습니다.";
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
	 * 역량평가표생성관리 삭제
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=deleteAppCompItemCreateMgr", method = RequestMethod.POST )
	public ModelAndView deleteAppCompItemCreateMgr(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		String getParamNames ="sNo,sDelete,sStatus,prgCd,prgNm,prgEngNm,prgPath,use,version,memo,dateTrackYn,logSaveYn";
		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,getParamNames,"");
		convertMap.put("ssnSabun", session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		
		String message = "";
		int resultCnt = -1;
		try{
			// 삭제 서비스 호출
			resultCnt = appCompItemCreateMgrService.deleteAppCompItemCreateMgr(convertMap);
			if(resultCnt > 0){ message="삭제되었습니다."; }
			else{ message="삭제된 내용이 없습니다."; }
		}catch(Exception e){
			resultCnt = -1;
			message="삭제에 실패하였습니다.";
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
