package com.hr.tim.workApp.otWorkAppDet;
import java.io.Serializable;
import java.sql.Array;
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
import com.hr.common.language.LanguageUtil;
/**
 * 특근신청 Controller 
 * 
 * @author JSG
 *
 */
@Controller
@RequestMapping(value="/OtWorkAppDet.do", method=RequestMethod.POST )
public class OtWorkAppDetController {
	/**
	 * 특근신청 서비스
	 */
	@Inject
	@Named("OtWorkAppDetService")
	private OtWorkAppDetService otWorkAppDetService;


	/**
	 * viewOtWorkAppDet View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewOtWorkAppDet", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewOtWorkAppDet() throws Exception {
		return "tim/workApp/otWorkAppDet/otWorkAppDet";
	}
	
	/**
	 * 특근신청 단건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getOtWorkAppDetMap", method = RequestMethod.POST )
	public ModelAndView getDayWorkTimeMgrMap(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnSabun",   session.getAttribute("ssnSabun"));
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		
		Map<?, ?> map = otWorkAppDetService.getOtWorkAppDetMap(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("map", map);
		Log.DebugEnd();
		return mv;
	}
	
	/**
	 * 연장근무대상자여부 조회(연장근무대상자이면 연장근무 신청 할 수 없다.)
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getOtWorkAppDetSabun", method = RequestMethod.POST )
	public ModelAndView getOtWorkAppDetSabun(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnSabun",   session.getAttribute("ssnSabun"));
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		
		Map<?, ?> map = otWorkAppDetService.getOtWorkAppDetSabun(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("map", map);
		Log.DebugEnd();
		return mv;
	}	
	
	
	/**
	 * 연장근무 기신청건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */

	
	@RequestMapping(params="cmd=getOtWorkAppCheck", method = RequestMethod.POST )
	public ModelAndView getOtWorkAppCheck(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		
		paramMap.put("ssnSabun",   session.getAttribute("ssnSabun"));
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));

		Map<?, ?> map  = new HashMap<String,Object>();
		String Message = "";
		try{
			map = otWorkAppDetService.getOtWorkAppCheck(paramMap);

		}catch(Exception e){
			Message="조회에 실패 하였습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("map", map);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}
	
	
	/**
	 * 특근신청 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getOtWorkAppDetList", method = RequestMethod.POST )
	public ModelAndView getOtWorkAppDetList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		
		paramMap.put("ssnSabun",   session.getAttribute("ssnSabun"));
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		
		Log.DebugStart();
		HashMap<String, String> mapElement = null;
		List<?> titleList = new ArrayList<Object>();
		List<Serializable> titles = new ArrayList<Serializable>();
		
		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			
			titleList = otWorkAppDetService.getOtWorkAppDetHeaderList(paramMap);

			for(int i = 0 ; i < titleList.size() ; i++){
				mapElement = new HashMap<String, String>();
				Map<String, String> map = (Map)titleList.get(i);
				mapElement.put("code",         map.get("code").toString());
				mapElement.put("codeNm",       map.get("codeNm").toString());
				mapElement.put("saveName",     map.get("saveName").toString());
				mapElement.put("saveNameDisp", map.get("saveNameDisp").toString());
				titles.add(mapElement);
			}			
			paramMap.put("titles", titles);
			
			list = otWorkAppDetService.getOtWorkAppDetList(paramMap);
		}catch(Exception e){
			Message=LanguageUtil.getMessage("msg.alertSearchFail2", null, "조회에 실패하였습니다.");
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}
	
	/**
	 * 특근신청 헤더 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getOtWorkAppDetHeaderList", method = RequestMethod.POST )
	public ModelAndView getOtWorkAppDetHeaderList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		
		paramMap.put("ssnSabun",   session.getAttribute("ssnSabun"));
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		
		Log.DebugStart();
		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = otWorkAppDetService.getOtWorkAppDetHeaderList(paramMap);
		}catch(Exception e){
			Message=LanguageUtil.getMessage("msg.alertSearchFail2", null, "조회에 실패하였습니다.");
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}
	
	/**
	 * 특근신청 - 근무시간  조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getOtWorkAppDetWokrTimeList", method = RequestMethod.POST )
	public ModelAndView getOtWorkAppDetWokrTimeList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		
		paramMap.put("ssnSabun",   session.getAttribute("ssnSabun"));
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		
		Log.DebugStart();
		HashMap<String, String> mapElement = null;
		List<?> titleList = new ArrayList<Object>();
		List<Serializable> titles = new ArrayList<Serializable>();
		
		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			
			titleList = otWorkAppDetService.getOtWorkAppDetHeaderList(paramMap);

			for(int i = 0 ; i < titleList.size() ; i++){
				mapElement = new HashMap<String, String>();
				Map<String, String> map = (Map)titleList.get(i);
				mapElement.put("code",         map.get("code").toString());
				mapElement.put("codeNm",       map.get("codeNm").toString());
				mapElement.put("saveName",     map.get("saveName").toString());
				mapElement.put("saveNameDisp", map.get("saveNameDisp").toString());
				titles.add(mapElement);
			}			
			paramMap.put("titles", titles);
			
			list = otWorkAppDetService.getOtWorkAppDetWokrTimeList(paramMap);
		}catch(Exception e){
			Message=LanguageUtil.getMessage("msg.alertSearchFail2", null, "조회에 실패하였습니다.");
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}	
	
	/**
	 * 특근신청 저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveOtWorkAppDet", method = RequestMethod.POST )
	public ModelAndView saveOtWorkAppDet(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();
		
		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		convertMap.put("ssnSabun",   session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
				
		HashMap<String, String> mapElement = null;
		List<?> titleList = new ArrayList<Object>();
		List<Serializable> mergeData = new ArrayList<Serializable>();
		
		String message = "";
		int resultCnt = -1;
		try{
			
			List<Map> mergeRows = (List<Map>)convertMap.get("mergeRows");

			List<Map<String,String>> addRows = new ArrayList<Map<String,String>>();
			
			titleList = otWorkAppDetService.getOtWorkAppDetHeaderList(convertMap);

			List<Serializable> titles = new ArrayList<Serializable>();
			
			for(Map<String,String> mp : mergeRows) {
				for(int i = 0 ; i < titleList.size() ; i++){
					Map<String, String> map = (Map)titleList.get(i);
					String workCd  = map.get("code").toString();
					String colName = map.get("saveNameDisp").toString();

					Map<String,String> addMap = new HashMap<String,String>();
					String workHm  = mp.get(colName);
					String workHh = (workHm != null && workHm.length() >= 2)? workHm.substring(0,2):"";
					String workMm = (workHm != null && workHm.length() >= 4)? workHm.substring(2,4):"";
					
					
					addMap.put("sabun",  mp.get("sabun"));
					addMap.put("workCd", workCd);
					addMap.put("workHh", workHh );
					addMap.put("workMm", workMm);
					addRows.add(addMap);
				}
			}
				
			convertMap.put("mergeRows342", addRows);
			resultCnt = otWorkAppDetService.saveOtWorkAppDet(convertMap);
			if(resultCnt > 0){ message=LanguageUtil.getMessage("msg.alertSaveOkV1", null, "저장 되었습니다."); } else{ message=LanguageUtil.getMessage("msg.alertSaveNoData", null, "저장된 내용이 없습니다."); }
		}catch(Exception e){
			resultCnt = -1; message=LanguageUtil.getMessage("msg.alertSaveFail2", null, "저장에 실패하였습니다.");
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
