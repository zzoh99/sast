package com.hr.tim.month.dailyWorkMgr;
import java.io.Serializable;
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
import com.hr.common.language.LanguageUtil;
/**
 * 일근무관리 Controller
 *
 * @author JSG
 *
 */
@Controller
@RequestMapping(value="/DailyWorkMgr.do", method=RequestMethod.POST )
public class DailyWorkMgrController {
	/**
	 * 일근무관리 서비스
	 */
	@Inject
	@Named("DailyWorkMgrService")
	private DailyWorkMgrService dailyWorkMgrService;

	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;

	/**
	 * dailyWorkMgr View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewDailyWorkMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewDailyWorkMgr() throws Exception {
		return "tim/month/dailyWorkMgr/dailyWorkMgr";
	}

	/**
	 * dailyWorkMgr(세부내역) 팝업 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewDailyWorkMgrPop", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewDailyWorkMgrPop() throws Exception {
		return "tim/month/dailyWorkMgr/dailyWorkMgrPop";
	}
	
	/**
	
	/**
	 * 일근무관리 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getDailyWorkMgrList", method = RequestMethod.POST )
	public ModelAndView getDailyWorkMgrList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {

		paramMap.put("ssnSabun",		session.getAttribute("ssnSabun"));
		paramMap.put("ssnEnterCd",		session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSearchType",	session.getAttribute("ssnSearchType"));
		paramMap.put("ssnGrpCd",		session.getAttribute("ssnGrpCd"));


		Log.DebugStart();
		HashMap<String, String> mapElement = null;
		List<?> titleList = new ArrayList<Object>();
		List<Serializable> titles = new ArrayList<Serializable>();

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		Map<?,?> map  = new HashMap<String,Object>();
		
		try{
			//map  = dailyWorkMgrService.getDailyWorkMgrCntMap(paramMap);
			titleList = dailyWorkMgrService.getDailyWorkMgrHeaderList(paramMap);
			paramMap.put("titles", titleList);
			list = dailyWorkMgrService.getDailyWorkMgrList(paramMap);
		}catch(Exception e){
			Message=LanguageUtil.getMessage("msg.alertSearchFail2", null, "조회에 실패하였습니다.");
		}
		ModelAndView mv = new ModelAndView();
		
		if ("Y".equals(paramMap.get("exceldown"))) {
			mv.setViewName("common/etc/DirectDown2Excel");
			mv.addObject("SHEETDATA", list);
		} else {
			mv.setViewName("jsonView");
			mv.addObject("DATA", list);
		}
		
		mv.addObject("Message", Message);
		//mv.addObject("TOTAL",map.get("cnt"));
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 헤더 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getDailyWorkMgrHeaderList", method = RequestMethod.POST )
	public ModelAndView getDailyWorkMgrHeaderList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = dailyWorkMgrService.getDailyWorkMgrHeaderList(paramMap);
		}catch(Exception e){
			Message="조회에 실패 하였습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 일근무관리 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveDailyWorkMgr", method = RequestMethod.POST )
	public ModelAndView saveDailyWorkMgr(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

		String message = "";
		int resultCnt = -1;

		HashMap<String, String> mapElement = null;
		List<?> titleList = new ArrayList<Object>();
		List<Serializable> mergeData = new ArrayList<Serializable>();
		try{
			List<Map> mergeRows = (List<Map>)convertMap.get("mergeRows");

			List<Map<String,String>> addRows = new ArrayList<Map<String,String>>();

			titleList = dailyWorkMgrService.getDailyWorkMgrHeaderList(convertMap);

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
					addMap.put("ymd",    mp.get("ymd"));
					addMap.put("workCd", workCd);
					addMap.put("workHh", workHh );
					addMap.put("workMm", workMm);
					addRows.add(addMap);
				}
			}
			convertMap.put("mergeRows337", addRows);

			resultCnt = dailyWorkMgrService.saveDailyWorkMgr(convertMap);
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
	

	
	/**
	 * 근무시간  조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getDailyWorkMgrTimeList", method = RequestMethod.POST )
	public ModelAndView getDailyWorkMgrTimeList(
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

			titleList = dailyWorkMgrService.getDailyWorkMgrHeaderList(paramMap);

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
			
			list = dailyWorkMgrService.getDailyWorkMgrTimeList(paramMap);
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
}
