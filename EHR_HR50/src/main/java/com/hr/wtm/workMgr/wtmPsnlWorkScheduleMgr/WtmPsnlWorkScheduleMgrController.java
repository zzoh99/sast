package com.hr.wtm.workMgr.wtmPsnlWorkScheduleMgr;

import com.hr.common.code.CommonCodeService;
import com.hr.common.language.LanguageUtil;
import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;
import com.hr.wtm.workMgr.wtmShiftSchMgr.WtmShiftSchMgrService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.io.Serializable;
import java.util.*;
import java.util.stream.Collectors;

/**
 * 개인근무스케줄관리 Controller
 *
 * @author JSG
 *
 */
@Controller
@RequestMapping({"/WtmPsnlWorkScheduleMgr.do"})
public class WtmPsnlWorkScheduleMgrController {
	/**
	 * 개인근무스케줄관리 서비스
	 */
	@Inject
	@Named("WtmPsnlWorkScheduleMgrService")
	private WtmPsnlWorkScheduleMgrService wtmPsnlWorkScheduleMgrService;

	@Autowired
	private WtmShiftSchMgrService wtmShiftSchMgrService;

	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;

	/**
	 * psnlWorkScheduleMgr View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewWtmPsnlWorkScheduleMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewPsnlWorkScheduleMgr() throws Exception {
		return "wtm/workMgr/wtmPsnlWorkScheduleMgr/wtmPsnlWorkScheduleMgr";
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
	@RequestMapping(params="cmd=getWtmPsnlWorkScheduleMgrList", method = RequestMethod.POST )
	public ModelAndView getWtmPsnlWorkScheduleMgrList(
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

			list = wtmPsnlWorkScheduleMgrService.getWtmPsnlWorkScheduleMgrList(paramMap);
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
	@RequestMapping(params="cmd=getWtmPsnlWorkScheduleMgrDayWorkList", method = RequestMethod.POST )
	public ModelAndView getWtmPsnlWorkScheduleMgrDayWorkList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {

		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

		Log.DebugStart();
		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = wtmPsnlWorkScheduleMgrService.getWtmPsnlWorkScheduleMgrDayWorkList(paramMap);
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
	@RequestMapping(params="cmd=getWtmPsnlWorkExtendCheck", method = RequestMethod.POST )
	public ModelAndView getWtmPsnlWorkExtendCheck(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnSabun",   session.getAttribute("ssnSabun"));
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		
		Map<?, ?> map = wtmPsnlWorkScheduleMgrService.getWtmPsnlWorkExtendCheck(paramMap);
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
	@RequestMapping(params="cmd=deleteWtmPsnlWorkScheduleMgr", method = RequestMethod.POST )
	public ModelAndView deleteWtmPsnlWorkScheduleMgr(
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
			resultCnt = wtmPsnlWorkScheduleMgrService.deleteWtmPsnlWorkScheduleMgr(convertMap);
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
	@RequestMapping(params="cmd=saveWtmPsnlWorkScheduleMgr", method = RequestMethod.POST )
	public ModelAndView saveWtmPsnlWorkScheduleMgr(
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
				List<Map<String, Object>> mergeRows = (List<Map<String, Object>>) convertMap.get("mergeRows");
				// "id" 기준으로 중복 제거
				List<Object> sabunList = new ArrayList<>(
						mergeRows.stream()
								.collect(Collectors.toMap(
										m -> m.get("sabun"), // 키 기준
										m -> m,           // 값
										(existing, replacement) -> existing // 중복 키가 있을 경우 기존 값 유지
								))
								.keySet()
				);
				paramMap.put("checkSabunList", sabunList);

				int checkCnt = wtmPsnlWorkScheduleMgrService.getWtmPsnlWorkScheduleMgrCheck(paramMap);

				convertMap.put("sdate", paramMap.get("saveSymd"));
				convertMap.put("edate", paramMap.get("saveEymd"));
				convertMap.put("workClassCd", paramMap.get("searchWorkClassCd"));
				convertMap.put("searchSabunName", paramMap.get("searchSabunName"));

				//임시 저장 후 반영
				resultCnt = wtmPsnlWorkScheduleMgrService.saveWtmPsnlWorkScheduleMgr(convertMap);

				//반영
				wtmShiftSchMgrService.saveWorkClassSchDetailApply(convertMap);

//				List<Map> mergeList = (List<Map>)convertMap.get("mergeRows");
//				List<Map<String,Object>> callProcList = new ArrayList<Map<String,Object>>();
//
//				for(Map<String,Object> mp : mergeList) {
//
//					if ("callPro".equals(mp.get("flag"))){
//						Map<String,Object> callProcMap = new HashMap<String,Object>();
//						callProcMap.put("ssnSabun",   convertMap.get("ssnSabun"));
//						callProcMap.put("ssnEnterCd", convertMap.get("ssnEnterCd"));
//						callProcMap.put("symd",       convertMap.get("saveSymd"));
//						callProcMap.put("eymd",       convertMap.get("saveEymd"));
//						callProcMap.put("searchBizPlaceCd", "");
//						callProcMap.put("sabun",      mp.get("sabun"));
//
//						wtmPsnlWorkScheduleMgrService.callP_TIM_WORK_HOUR_CHG(callProcMap);
//					}
//				}

				if(resultCnt > 0){
					if(sabunList.size() == checkCnt){
						message=LanguageUtil.getMessage("msg.alertSaveOkV1", null, "저장 되었습니다.");
					}else{
						message=LanguageUtil.getMessage("msg.alertSaveOkV1", null, "해당 근무유형에 포함되지 않은 사번이 있습니다.");
					}

				} else{
					message=LanguageUtil.getMessage("msg.alertSaveNoData", null, "저장된 내용이 없습니다.");
				}
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
		map = wtmPsnlWorkScheduleMgrService.callP_TIM_MTN_SCHEDULE_CREATE(paramMap);

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
	@RequestMapping(params="cmd=getWtmPsnlWorkScheduleMgrMemo", method = RequestMethod.POST )
	public ModelAndView getWtmPsnlWorkScheduleMgrMemo(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
	
		Map<?, ?> map = null;
		String Message = "";
	
		try{
			map = wtmPsnlWorkScheduleMgrService.getWtmPsnlWorkScheduleMgrMemo(paramMap);
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
	@RequestMapping(params="cmd=getWtmPsnlWorkScheduleMgrEndYn", method = RequestMethod.POST )
	public ModelAndView getWtmPsnlWorkScheduleMgrEndYn(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
	
		Map<?, ?> map = null;
		String Message = "";
	
		try{
			map = wtmPsnlWorkScheduleMgrService.getWtmPsnlWorkScheduleMgrEndYn(paramMap);
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
	@RequestMapping(params="cmd=getWtmPsnlWorkScheduleMgrHeaderList", method = RequestMethod.POST )
	public ModelAndView getWtmPsnlWorkScheduleMgrHeaderList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = wtmPsnlWorkScheduleMgrService.getWtmPsnlWorkScheduleMgrHeaderList(paramMap);
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
	@RequestMapping(params="cmd=getWtmPsnlWorkScheduleMgrDayWorkHeaderList", method = RequestMethod.POST )
	public ModelAndView getWtmPsnlWorkScheduleMgrDayWorkHeaderList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = wtmPsnlWorkScheduleMgrService.getWtmPsnlWorkScheduleMgrDayWorkHeaderList(paramMap);
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
