package com.hr.pap.config.appScheduleMgr;
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
import com.hr.common.code.CommonCodeService;
/**
 * 평가일정관리 Controller 
 * 
 * @author jcy
 *
 */
@Controller
@RequestMapping(value="/AppScheduleMgr.do", method=RequestMethod.POST )
public class AppScheduleMgrController {
	/**
	 * 사용할 서비스 선언
	 */
	@Inject
	@Named("AppScheduleMgrService")
	private AppScheduleMgrService appScheduleMgrService;
	
	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;
	
	/**
	 * 평가일정관리 View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewAppScheduleMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewAppScheduleMgr() throws Exception {
		return "pap/config/appScheduleMgr/appScheduleMgr";
	}
	
	/**
	 * 평가일정관리 - 평가차수일정 - 팝업 View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewAppScheduleMgrPop", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewAppScheduleMgrPop() throws Exception {
		return "pap/config/appScheduleMgr/appScheduleMgrPop";
	}
	
	/**
	 * 평가일정관리 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAppScheduleMgrList", method = RequestMethod.POST )
	public ModelAndView getAppScheduleMgrList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		List<?> list  = new ArrayList<Object>();
		String Message = "";
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		try{
			list = appScheduleMgrService.getAppScheduleMgrList(paramMap);
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
	 * 평가일정관리 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAppScheduleMgrPopList", method = RequestMethod.POST )
	public ModelAndView getAppScheduleMgrPopList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		List<?> list  = new ArrayList<Object>();
		String Message = "";
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		try{
			list = appScheduleMgrService.getAppScheduleMgrPopList(paramMap);
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
	 * 평가일정관리 단건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAppScheduleMgrMap", method = RequestMethod.POST )
	public ModelAndView getAppScheduleMgrMap(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		Map<?, ?> map = appScheduleMgrService.getAppScheduleMgrMap(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("resultMap", map);
		Log.DebugEnd();
		return mv;
	}
	
	/**
	 * 평가일정관리 저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveAppScheduleMgr", method = RequestMethod.POST )
	public ModelAndView saveAppScheduleMgr(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		convertMap.put("ssnSabun", session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		
		List<Map> insertList = (List<Map>)convertMap.get("insertRows");
		List<Map<String,Object>> dupList = new ArrayList<Map<String,Object>>();

		for(Map<String,Object> mp : insertList) {
			Map<String,Object> dupMap = new HashMap<String,Object>();
			dupMap.put("ENTER_CD",convertMap.get("ssnEnterCd"));
			dupMap.put("APPRAISAL_CD",mp.get("appraisalCd"));
			dupMap.put("APP_STEP_CD",mp.get("appStepCd"));
			dupList.add(dupMap);
		}
		
		String message = "";
		int resultCnt = -1;
		try{
			int dupCnt = 0;
			
			if(insertList.size() > 0) {
				// 중복체크
				dupCnt = commonCodeService.getDupCnt("TPAP105","ENTER_CD,APPRAISAL_CD,APP_STEP_CD","s,s,s",dupList);
			}

			if(dupCnt > 0) {
				resultCnt = -1; message="중복된 값이 존재합니다.";
			} else {
			
			resultCnt =appScheduleMgrService.saveAppScheduleMgr(convertMap);
			if(resultCnt > 0){ message="저장되었습니다."; }
			else{ message="저장된 내용이 없습니다."; }
			}
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
	 * 평가일정관리 생성
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=insertAppScheduleMgr", method = RequestMethod.POST )
	public ModelAndView insertAppScheduleMgr(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();
		String getParamNames ="sNo,sDelete,sStatus,appScheduleCd,appScheduleNm,appScheduleEngNm,appSchedulePath,use,version,memo,dateTrackYn,logSaveYn";
		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,getParamNames,"");
		convertMap.put("ssnSabun", session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		
		String message = "";
		int resultCnt = -1;
		try{
			resultCnt = appScheduleMgrService.insertAppScheduleMgr(convertMap);
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
	 * 평가일정관리 수정
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=updateAppScheduleMgr", method = RequestMethod.POST )
	public ModelAndView updateAppScheduleMgr(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		String getParamNames ="sNo,sDelete,sStatus,appScheduleCd,appScheduleNm,appScheduleEngNm,appSchedulePath,use,version,memo,dateTrackYn,logSaveYn";
		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,getParamNames,"");
		convertMap.put("ssnSabun", session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		
		String message = "";
		int resultCnt = -1;
		try{
			resultCnt = appScheduleMgrService.updateAppScheduleMgr(convertMap);
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
	 * 평가일정관리 삭제
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=deleteAppScheduleMgr", method = RequestMethod.POST )
	public ModelAndView deleteAppScheduleMgr(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		String getParamNames ="sNo,sDelete,sStatus,appScheduleCd,appScheduleNm,appScheduleEngNm,appSchedulePath,use,version,memo,dateTrackYn,logSaveYn";
		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,getParamNames,"");
		convertMap.put("ssnSabun", session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		
		String message = "";
		int resultCnt = -1;
		try{
			// 삭제 서비스 호출
			resultCnt = appScheduleMgrService.deleteAppScheduleMgr(convertMap);
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
	
	
	/**
	 * 평가일정관리-평가차수일정관리팝업 - 저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveAppScheduleMgrPop", method = RequestMethod.POST )
	public ModelAndView saveAppScheduleMgrPop(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		convertMap.put("ssnSabun", session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		
		List<Map> insertList = (List<Map>)convertMap.get("insertRows");
		List<Map<String,Object>> dupList = new ArrayList<Map<String,Object>>();

		for(Map<String,Object> mp : insertList) {
			Map<String,Object> dupMap = new HashMap<String,Object>();
			dupMap.put("ENTER_CD",convertMap.get("ssnEnterCd"));
			dupMap.put("APPRAISAL_CD",mp.get("appraisalCd"));
			dupMap.put("APP_STEP_CD",mp.get("appStepCd"));
			dupMap.put("APPRAISAL_SEQ",mp.get("appraisalSeq"));
			dupList.add(dupMap);
		}
		
		String message = "";
		int resultCnt = -1;
		try{
			int dupCnt = 0;
			
			if(insertList.size() > 0) {
				// 중복체크
				dupCnt = commonCodeService.getDupCnt("TPAP104","ENTER_CD,APPRAISAL_CD,APP_STEP_CD,APPRAISAL_SEQ","s,s,s,s",dupList);
			}

			if(dupCnt > 0) {
				resultCnt = -1; message="중복된 값이 존재합니다.";
			} else {
			
			resultCnt =appScheduleMgrService.saveAppScheduleMgrPop(convertMap);
			if(resultCnt > 0){ message="저장되었습니다."; }
			else{ message="저장된 내용이 없습니다."; }
			}
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
}
