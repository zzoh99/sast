package com.hr.sys.alteration.mainMnMgr;
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
import com.hr.sys.system.dictMgr.DictMgrService;
/**
 * 메인메뉴관리 Controller 
 * 
 * @author ParkMoohun
 *
 */
@Controller
@RequestMapping(value="/MainMnMgr.do", method=RequestMethod.POST ) 
public class MainMnMgrController {
	/**
	 * 메인메뉴관리 서비스
	 */
	@Inject
	@Named("MainMnMgrService")
	private MainMnMgrService mainMnMgrService;
	
	@Inject
	@Named("DictMgrService")
	private DictMgrService dictMgrService;
	
	/**
	 * 메인메뉴관리 View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewMainMnMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewMainMnMgr() throws Exception {
		return "sys/alteration/mainMnMgr/mainMnMgr";
	}
	/**
	 * 메인메뉴관리 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getMainMnMgrList", method = RequestMethod.POST )
	public ModelAndView getMainMnMgrList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			paramMap.put("localeCd1", session.getAttribute("localeCd1"));
			list = mainMnMgrService.getMainMnMgrList(paramMap);
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
	 * 메인메뉴관리 단건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getMainMnMgrMap", method = RequestMethod.POST )
	public ModelAndView getMainMnMgrMap(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		Map<?, ?> map =null;
		String Message = "";
		try{
			map = mainMnMgrService.getMainMnMgrMap(paramMap);
		}catch(Exception e){
			Message="조회에 실패하였습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", map);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}
	/**
	 * 메인메뉴관리 저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveMainMnMgr", method = RequestMethod.POST )
	public ModelAndView saveMainMnMgr(
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
			resultCnt =mainMnMgrService.saveMainMnMgr(convertMap);
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
//	/**
//	 * 메인메뉴관리 생성
//	 * 
//	 * @param session
//	 * @param request
//	 * @param paramMap
//	 * @return ModelAndView
//	 * @throws Exception
//	 */
//	@RequestMapping(params="cmd=insertMainMnMgr", method = RequestMethod.POST )
//	public ModelAndView insertMainMnMgr(
//			HttpSession session,  HttpServletRequest request, 
//			@RequestParam Map<String, Object> paramMap ) throws Exception {
//		// comment 시작
//		Log.DebugStart();
//		String getParamNames ="sNo,sDelete,sStatus,mainMenuCd,mainMenuNm,imagePath,seq";
//		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,getParamNames,"");
//		convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
//		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
//		
//		String message = "";
//		int resultCnt = -1;
//		try{
//			resultCnt = mainMnMgrService.insertMainMnMgr(convertMap);
//			if(resultCnt > 0){ message="생성 되었습니다."; } else{ message="생성된 내용이 없습니다."; }
//		}catch(Exception e){
//			resultCnt = -1; message="생성에 실패하였습니다.";
//		}
//		
//		Map<String, Object> resultMap = new HashMap<String, Object>();
//		resultMap.put("Code", resultCnt);
//		resultMap.put("Message", message);
//		
//		ModelAndView mv = new ModelAndView();
//		mv.setViewName("jsonView");
//		mv.addObject("Result", resultMap);
//		Log.DebugEnd();
//		return mv;
//	}
//	/**
//	 * 메인메뉴관리 수정
//	 * 
//	 * @param session
//	 * @param request
//	 * @param paramMap
//	 * @return ModelAndView
//	 * @throws Exception
//	 */
//	@RequestMapping(params="cmd=updateMainMnMgr", method = RequestMethod.POST )
//	public ModelAndView updateMainMnMgr(
//			HttpSession session,  HttpServletRequest request, 
//			@RequestParam Map<String, Object> paramMap ) throws Exception {
//		Log.DebugStart();
//		String getParamNames ="sNo,sDelete,sStatus,mainMenuCd,mainMenuNm,imagePath,seq";
//		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,getParamNames,"");
//		convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
//		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
//		
//		String message = "";
//		int resultCnt = -1;
//		try{
//			resultCnt = mainMnMgrService.updateMainMnMgr(convertMap);
//			if(resultCnt > 0){ message="수정 되었습니다."; } else{ message="수정된 내용이 없습니다."; }
//		}catch(Exception e){
//			resultCnt = -1; message="수정에 실패하였습니다.";
//		}
//		
//		Map<String, Object> resultMap = new HashMap<String, Object>();
//		resultMap.put("Code", resultCnt);
//		resultMap.put("Message", message);
//		
//		ModelAndView mv = new ModelAndView();
//		mv.setViewName("jsonView");
//		mv.addObject("Result", resultMap);
//		Log.DebugEnd();
//		return mv;
//	}
	/**
	 * 메인메뉴관리 삭제
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=deleteMainMnMgr", method = RequestMethod.POST )
	public ModelAndView deleteMainMnMgr(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		String getParamNames ="sNo,sDelete,sStatus,mainMenuCd,mainMenuNm,imagePath,seq";
		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,getParamNames,"");
		convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		
		String message = "";
		int resultCnt = -1;
		try{
			resultCnt = mainMnMgrService.deleteMainMnMgr(convertMap);
			if(resultCnt > 0){ message="삭제 되었습니다."; } else{ message="삭제된 내용이 없습니다."; }
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
}
