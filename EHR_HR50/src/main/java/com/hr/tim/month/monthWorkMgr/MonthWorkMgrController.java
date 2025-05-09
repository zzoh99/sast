package com.hr.tim.month.monthWorkMgr;
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

import com.hr.common.code.CommonCodeService;
import com.hr.common.com.ComController;
import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;

import com.hr.tim.month.dailyWorkMgr.DailyWorkMgrService;
import com.hr.common.language.LanguageUtil;
/**
 * 월근태/근무관리 Controller
 *
 * @author JSG
 *
 */
@Controller
@RequestMapping(value="/MonthWorkMgr.do", method=RequestMethod.POST )
public class MonthWorkMgrController extends ComController {

	/**
	 * 월근태/근무관리 서비스
	 */
	@Inject
	@Named("MonthWorkMgrService")
	private MonthWorkMgrService monthWorkMgrService;

	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;

	@Inject
	@Named("DailyWorkMgrService")
	private DailyWorkMgrService dailyWorkMgrService;

	/**
	 * monthWorkMgr View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewMonthWorkMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewMonthWorkMgr() throws Exception {
		return "tim/month/monthWorkMgr/monthWorkMgr";
	}
	
	/**
	 * monthWorkMgr View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewMonthWorkDayTab", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewMonthWorkDayTab() throws Exception {
		return "tim/month/monthWorkMgr/monthWorkDayTab";
	}
	
	/**
	 * monthWorkMgr View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewMonthWorkTimeTab1", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewMonthWorkTimeTab1() throws Exception {
		return "tim/month/monthWorkMgr/monthWorkTimeTab1";
	}
	
	/**
	 * monthWorkMgr View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewMonthWorkTimeTab", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewMonthWorkTimeTab() throws Exception {
		return "tim/month/monthWorkMgr/monthWorkTimeTab";
	}
	
	/**
	 * monthWorkMgr View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewMonthWorkTotalTab", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewMonthWorkTotalTab() throws Exception {
		return "tim/month/monthWorkMgr/monthWorkTotalTab";
	}

	/**
	 * 일근무시간 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewMonthWorkTimeTab2", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewMonthWorkMgrDayTab() throws Exception {
		return "tim/month/monthWorkMgr/monthWorkTimeTab2";
	}
	
	/**
	 * 월근무시간 (근무코드별) 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getMonthWorkTimeTab1", method = RequestMethod.POST )
	public ModelAndView getMonthWorkTimeTab1(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		List<?> list  = new ArrayList<Object>();
		String Message = "";
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		try{
			List<?> titleList = dailyWorkMgrService.getDailyWorkMgrHeaderList(paramMap);
			paramMap.put("titles", titleList);

			list = monthWorkMgrService.getMonthWorkMgrList("getMonthWorkTimeTab1", paramMap);
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
	 * monthWorkDayTab 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getMonthWorkDayTab", method = RequestMethod.POST )
	public ModelAndView getMonthWorkDayTab(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = monthWorkMgrService.getMonthWorkDayTab(paramMap);
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
	 * monthWorkDayTab 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveMonthWorkDayTab", method = RequestMethod.POST )
	public ModelAndView saveMonthWorkDayTab(
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
			resultCnt =monthWorkMgrService.saveMonthWorkDayTab(convertMap);
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
	
	/**
	 * monthWorkTimeTab 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getMonthWorkTimeTab", method = RequestMethod.POST )
	public ModelAndView getMonthWorkTimeTab(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = monthWorkMgrService.getMonthWorkTimeTab(paramMap);
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
	 * monthWorkTimeTab 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveMonthWorkTimeTab", method = RequestMethod.POST )
	public ModelAndView saveMonthWorkTimeTab(
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
			resultCnt =monthWorkMgrService.saveMonthWorkTimeTab(convertMap);
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
	
	/**
	 * monthWorkTotalTab 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getMonthWorkTotalTab", method = RequestMethod.POST )
	public ModelAndView getMonthWorkTotalTab(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = monthWorkMgrService.getMonthWorkTotalTab(paramMap);
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
	 * monthWorkTotalTab 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveMonthWorkTotalTab", method = RequestMethod.POST )
	public ModelAndView saveMonthWorkTotalTab(
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
			resultCnt =monthWorkMgrService.saveMonthWorkTotalTab(convertMap);
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
	
	/**
	 * 월근무시간(근무코드별)  저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveMonthWorkTimeTab1", method = RequestMethod.POST )
	public ModelAndView saveMonthWorkTimeTab1(
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

			titleList = dailyWorkMgrService.getDailyWorkMgrHeaderList(convertMap);
			List<Map> mergeRows = (List<Map>)convertMap.get("mergeRows");

			List<Map<String,String>> addRows = new ArrayList<Map<String,String>>();

			List<Serializable> titles = new ArrayList<Serializable>();

			for(Map<String,String> mp : mergeRows) {
				for(int i = 0 ; i < titleList.size() ; i++){
					Map<String, String> map = (Map)titleList.get(i);
					String workCd  = map.get("code").toString();
					String colName = map.get("saveNameDisp").toString();

					Map<String,String> addMap = new HashMap<String,String>();
					String workHour = mp.get(colName);

					addMap.put("sabun",  	mp.get("sabun"));
					addMap.put("applyYy",	mp.get("applyYy"));
					addMap.put("ym",    	mp.get("ym"));
					addMap.put("workCd",	workCd);
					addMap.put("workHour",	workHour );
					addRows.add(addMap);
				}
			}
			convertMap.put("mergeRows403", addRows);

			resultCnt = monthWorkMgrService.saveMonthWorkTimeTab1(convertMap);
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
	 * 일근무조회 다건 조회  2020.08.30
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getMonthWorkTimeTab2", method = RequestMethod.POST )
	public ModelAndView getMonthWorkMgrDayTab(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		List<?> titleList = dailyWorkMgrService.getDailyWorkMgrHeaderList(paramMap);
		paramMap.put("titles", titleList);
		
		return getDataList(session, request, paramMap);
	}
	/**
	 * 일근무조회 저장  2020.08.30
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveMonthWorkTimeTab2", method = RequestMethod.POST )
	public ModelAndView saveMonthWorkMgrDayTab(
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

			List<?> titleList = dailyWorkMgrService.getDailyWorkMgrHeaderList(paramMap);
			convertMap.put("titles", titleList);
			
			resultCnt = monthWorkMgrService.saveMonthWorkTimeTab2(convertMap);
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
	

}