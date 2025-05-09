package com.hr.tim.schedule.psnlWorkScheduleMgr;
import java.io.Serializable;
import java.util.HashMap;
import java.util.Map;
import java.util.List;
import java.util.ArrayList;

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
import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;
import com.hr.common.language.LanguageUtil;
/**
 * 개인근무스케줄관리 Controller
 *
 * @author JSG
 *
 */
@Controller
@RequestMapping({"/PsnlWorkScheduleMgr.do", "/WorkScheduleOrgApp.do", "/OtWorkOrgApp.do", "/OtWorkOrgUpdApp.do"})
public class PsnlWorkScheduleMgrController {
	/**
	 * 개인근무스케줄관리 서비스
	 */
	@Inject
	@Named("PsnlWorkScheduleMgrService")
	private PsnlWorkScheduleMgrService psnlWorkScheduleMgrService;

	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;

	/**
	 * psnlWorkScheduleMgr View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewPsnlWorkScheduleMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewPsnlWorkScheduleMgr() throws Exception {
		return "tim/schedule/psnlWorkScheduleMgr/psnlWorkScheduleMgr";
	}
	
	/**
	 * 개인근무스케줄관리 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPsnlWorkScheduleMgrList", method = RequestMethod.POST )
	public ModelAndView getPsnlWorkScheduleMgrList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {

		paramMap.put("ssnSabun",   session.getAttribute("ssnSabun"));
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSearchType", session.getAttribute("ssnSearchType"));
		paramMap.put("ssnGrpCd",session.getAttribute("ssnGrpCd"));

		Log.DebugStart();
		HashMap<String, String> mapElement = null;
		List<?> titleList = new ArrayList<Object>();
		List<Serializable> titles = new ArrayList<Serializable>();

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{

			list = psnlWorkScheduleMgrService.getPsnlWorkScheduleMgrList(paramMap);
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
	 * 개인근무스케줄관리 - 일일근무시간(sheet2) 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPsnlWorkScheduleMgrDayWorkList", method = RequestMethod.POST )
	public ModelAndView getPsnlWorkScheduleMgrDayWorkList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {

		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

		Log.DebugStart();
		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = psnlWorkScheduleMgrService.getPsnlWorkScheduleMgrDayWorkList(paramMap);
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
	
	/* 메카로 연장근무신청관리자  조회(20190726 이재경 추가)*/
	@RequestMapping(params="cmd=getPsnlWorkExtendCheck", method = RequestMethod.POST )
	public ModelAndView getPsnlWorkExtendCheck(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnSabun",   session.getAttribute("ssnSabun"));
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		
		Map<?, ?> map = psnlWorkScheduleMgrService.getPsnlWorkExtendCheck(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("map", map);
		Log.DebugEnd();
		return mv;
	}
	

	/**
	 * 개인근무스케줄관리 삭제
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=deletePsnlWorkScheduleMgr", method = RequestMethod.POST )
	public ModelAndView deletePsnlWorkScheduleMgr(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		String getParamNames ="sNo,sDelete,sStatus,sabun,ymd,workCd,workOrgCd,requestHour,applyHour";

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,getParamNames,"");
		convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

		String message = "";
		int resultCnt = -1;
		try{
			resultCnt = psnlWorkScheduleMgrService.deletePsnlWorkScheduleMgr(convertMap);
			if(resultCnt > 0){ message="삭제되었습니다."; } else{ message="삭제된 내용이 없습니다."; }
		}catch(Exception e){
			resultCnt = -1; message=LanguageUtil.getMessage("msg.errorDelete2", null, "삭제에 실패하였습니다.");
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
	 * 개인근무스케줄관리 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=savePsnlWorkScheduleMgr", method = RequestMethod.POST )
	public ModelAndView savePsnlWorkScheduleMgr(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

		List<Map> insertList = (List<Map>)convertMap.get("insertRows");
		List<Map<String,Object>> dupList = new ArrayList<Map<String,Object>>();


		/*for(Map<String,Object> mp : insertList) {
			Map<String,Object> dupMap = new HashMap<String,Object>();

			if (!"callPro".equals(mp.get("flag"))){
				dupMap.put("ENTER_CD",convertMap.get("ssnEnterCd"));
				dupMap.put("SABUN",mp.get("sabun"));
				dupMap.put("YMD",mp.get("ymd"));
				dupMap.put("WORK_CD",mp.get("workCd"));
				dupMap.put("SDATE",mp.get("sdate"));
				dupList.add(dupMap);
			}
		} 중복체크 막음.2016.10.24
		*/

		String message = "";
		int resultCnt = -1;
		try{
			int dupCnt = 0;

			/* 중복체크 막음 2016.10.24
			if(insertList.size() > 0) {
				// 중복체크
				dupCnt = commonCodeService.getDupCnt("TTIM120","ENTER_CD,SABUN,YMD,WORK_CD","s,s,s,s",dupList);
			}*/

			if(dupCnt > 0) {
				resultCnt = -1; message=LanguageUtil.getMessage("msg.alertDataDup.value", null, "중복된 값이 존재 합니다.");
			} else {
				resultCnt = psnlWorkScheduleMgrService.savePsnlWorkScheduleMgr(convertMap);

				List<Map> mergeList = (List<Map>)convertMap.get("mergeRows");
				List<Map<String,Object>> callProcList = new ArrayList<Map<String,Object>>();

				for(Map<String,Object> mp : mergeList) {

					if ("callPro".equals(mp.get("flag"))){
						Map<String,Object> callProcMap = new HashMap<String,Object>();
						callProcMap.put("ssnSabun",   convertMap.get("ssnSabun"));
						callProcMap.put("ssnEnterCd", convertMap.get("ssnEnterCd"));
						callProcMap.put("symd",       convertMap.get("saveSymd"));
						callProcMap.put("eymd",       convertMap.get("saveEymd"));
						callProcMap.put("searchBizPlaceCd", "");
						callProcMap.put("sabun",      mp.get("sabun"));

						psnlWorkScheduleMgrService.callP_TIM_WORK_HOUR_CHG(callProcMap);
					}
				}

				if(resultCnt > 0){ message=LanguageUtil.getMessage("msg.alertSaveOkV1", null, "저장 되었습니다."); } else{ message=LanguageUtil.getMessage("msg.alertSaveNoData", null, "저장된 내용이 없습니다."); }
			}

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
	 * callP_TIM_MTN_SCHEDULE_CREATE 프로시저
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=callP_TIM_MTN_SCHEDULE_CREATE", method = RequestMethod.POST )
	public ModelAndView callP_TIM_MTN_SCHEDULE_CREATE(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();
		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		Map map  ;
		map = psnlWorkScheduleMgrService.callP_TIM_MTN_SCHEDULE_CREATE(paramMap);

		Map<String, Object> resultMap = new HashMap<String, Object>();
		if(map != null) {
			Log.Debug("obj : "+map);
			Log.Debug("sqlcode : "+map.get("sqlcode"));
			Log.Debug("sqlerrm : "+map.get("sqlerrm"));
			
			if (map.get("sqlCode") != null) {
				resultMap.put("Code", map.get("sqlCode").toString());
			}
			if (map.get("sqlErrm") != null) {
				resultMap.put("Message", map.get("sqlErrm").toString());
			}
		}

		// ModelAndView 생성
		ModelAndView mv = new ModelAndView();
		// return 형태 설정
		mv.setViewName("jsonView");
		mv.addObject("Result", resultMap);
		// 그리드에 맵핑 되는 데이터 이면 DATA에 담아서 보냄
		// comment 종료
		Log.DebugEnd();
		return mv;
	}
	
	/**
	 * psnlWorkScheduleMgr 1 단건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPsnlWorkScheduleMgrMemo", method = RequestMethod.POST )
	public ModelAndView getPsnlWorkScheduleMgrMemo(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
	
		Map<?, ?> map = null;
		String Message = "";
	
		try{
			map = psnlWorkScheduleMgrService.getPsnlWorkScheduleMgrMemo(paramMap);
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
	 * psnlWorkScheduleMgr 2 단건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPsnlWorkScheduleMgrEndYn", method = RequestMethod.POST )
	public ModelAndView getPsnlWorkScheduleMgrEndYn(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
	
		Map<?, ?> map = null;
		String Message = "";
	
		try{
			map = psnlWorkScheduleMgrService.getPsnlWorkScheduleMgrEndYn(paramMap);
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
	 * 개인근무스케줄관리 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPsnlWorkScheduleMgrHeaderList", method = RequestMethod.POST )
	public ModelAndView getPsnlWorkScheduleMgrHeaderList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = psnlWorkScheduleMgrService.getPsnlWorkScheduleMgrHeaderList(paramMap);
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
	 * 개인근무스케줄관리 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPsnlWorkScheduleMgrDayWorkHeaderList", method = RequestMethod.POST )
	public ModelAndView getPsnlWorkScheduleMgrDayWorkHeaderList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = psnlWorkScheduleMgrService.getPsnlWorkScheduleMgrDayWorkHeaderList(paramMap);
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
	
}
