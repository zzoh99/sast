package com.hr.tim.month.timeCardMgr;
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
import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;
import com.hr.common.language.LanguageUtil;
/**
 * TimeCard관리 Controller
 *
 * @author jcy
 *
 */
@Controller
@SuppressWarnings("unchecked")
@RequestMapping(value="/TimeCardMgr.do", method=RequestMethod.POST )
public class TimeCardMgrController {
	/**
	 * TimeCard관리 서비스
	 */
	@Inject
	@Named("TimeCardMgrService")
	private TimeCardMgrService timeCardMgrService;

	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;

	/**
	 * timeCardMgr View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewTimeCardMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewTimeCardMgr() throws Exception {
		return "tim/month/timeCardMgr/timeCardMgr";
	}
	
	/**
	 * timeCardMgr(세부내역) 팝업 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewTimeCardMgrPop", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewTimeCardMgrPop() throws Exception {
		return "tim/month/timeCardMgr/timeCardMgrPop";
	}

	/**
	 * timeCardMgr 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getTimeCardMgrList", method = RequestMethod.POST )
	public ModelAndView getTimeCardMgrList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = timeCardMgrService.getTimeCardMgrList(paramMap);
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
	 * TTIM999 마감여부
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getTimeCardMgrCount", method = RequestMethod.POST )
	public ModelAndView getTimWorkCount(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));

		Map<?, ?> map  = new HashMap<String,Object>();
		String Message = "";
		try{
			map = timeCardMgrService.getTimeCardMgr("getTimeCardMgrCount", paramMap);

		}catch(Exception e){
			Message=LanguageUtil.getMessage("msg.alertSearchFail2", null, "조회에 실패하였습니다.");
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", map);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}


	/**
	 * TimeCard관리 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveTimeCardMgrPop", method = RequestMethod.POST )
	public ModelAndView saveTimeCardMgrPop(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		String message = "";
		int resultCnt = -1;
		String symd = "";
		String eymd = "";
		try{
			//int dupCnt = 0;
			//파일LOAD DUPCHECK 안함.
			//dupCnt = commonCodeService.getDupCnt(convertMap, "TTIM330", "YMD,SABUN", "s,s");


			List<Map<String, Object>> mergeList = (List<Map<String, Object>>)convertMap.get("mergeRows");

			List<Map<String,Object>> rowList = new ArrayList<Map<String,Object>>();
			Map<String,Object> tempSaveMap = new HashMap<String,Object>();
			//Map<?, ?> sabunMap  = new HashMap<String,Object>();

			String tempSeq = convertMap.get("ssnSabun").toString()+ "_" + System.currentTimeMillis();
			//Debug.log("::::::::::::::::::::::::::tempSeq:"+tempSeq);

			int i = 0;
			for(Map<String,Object> mp : mergeList) {

				Map<String,Object> tempMap = new HashMap<String,Object>();

				tempMap.put("ymd",       mp.get("ymd"));
				tempMap.put("sabun",     mp.get("sabun"));
				tempMap.put("inYmd",     mp.get("inYmd"));
				tempMap.put("inHm",      mp.get("inHm"));
				tempMap.put("outYmd",    mp.get("outYmd"));
				tempMap.put("outHm",     mp.get("outHm"));
				tempMap.put("memo",      mp.get("memo"));
				tempMap.put("cardNo",    mp.get("cardNo"));
				tempMap.put("tempSeq",    tempSeq);
				tempMap.put("ssnSabun",   convertMap.get("ssnSabun"));
				tempMap.put("ssnEnterCd", convertMap.get("ssnEnterCd"));
				rowList.add(tempMap);

				if (i == 50){
					tempSaveMap.put("tempSeq",    tempSeq);
					tempSaveMap.put("ssnSabun",   convertMap.get("ssnSabun"));
					tempSaveMap.put("ssnEnterCd", convertMap.get("ssnEnterCd"));
					tempSaveMap.put("mergeRows",   rowList);

					// TTIM332(temp테이블에 데이터 올리기)
					resultCnt += timeCardMgrService.saveTimeCardMgrPopTemp332(tempSaveMap);
					rowList.clear();
					tempSaveMap.clear();
					i = 0;
				}
				i ++;
			}

			if (rowList.size() > 0){
				tempSaveMap.put("tempSeq",    tempSeq);
				tempSaveMap.put("ssnSabun",   convertMap.get("ssnSabun"));
				tempSaveMap.put("ssnEnterCd", convertMap.get("ssnEnterCd"));
				tempSaveMap.put("mergeRows",  rowList);

				resultCnt += timeCardMgrService.saveTimeCardMgrPopTemp332(tempSaveMap);
			}


			// 휴일데이터 빼고 TTIM330 에 insert
			// 사번 변환
			convertMap.put("tempSeq",    tempSeq);
			resultCnt = timeCardMgrService.saveTimeCardMgrPop(convertMap);

			// TTIM332 에서 ymd min/max 가져오기
			// symd / eymd
			Map<?, ?> map = new HashMap<String, Object> () ;
			map = timeCardMgrService.getTimeCardMgr("getTimeCardMgrPopTempDt332", convertMap);
			symd = (String) map.get("symd");
			eymd = (String) map.get("eymd");


			// 처리 후에 TTIM332 delete
			timeCardMgrService.deleteTimeCardMgrPopTemp332(convertMap);


			if(resultCnt > 0){ message=LanguageUtil.getMessage("msg.alertSaveOkV1", null, "저장 되었습니다."); } else{ message=LanguageUtil.getMessage("msg.alertSaveNoData", null, "저장된 내용이 없습니다."); }

		}catch(Exception e){
			resultCnt = -1; message=LanguageUtil.getMessage("msg.alertSaveFail2", null, "저장에 실패하였습니다.");
		}

		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("Code", resultCnt);
		resultMap.put("Message", message);
		resultMap.put("symd", symd);
		resultMap.put("eymd", eymd);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Result", resultMap);
		Log.DebugEnd();
		return mv;
	}
	
	/**
	 * timeCardMgr 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveTimeCardMgr", method = RequestMethod.POST )
	public ModelAndView saveTimeCardMgr(
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
			resultCnt =timeCardMgrService.saveTimeCardMgr(convertMap);
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
	 * 프로시저
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=callP_TIM_SECOM_TIME_CRE", method = RequestMethod.POST )
	public ModelAndView callP_TIM_SECOM_TIME_CRE(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",   session.getAttribute("ssnSabun"));

		Map<?, ?> map  = timeCardMgrService.callP_TIM_SECOM_TIME_CRE(paramMap);

		Log.Debug("obj : "+map);
		Log.Debug("pSqlcode : "+map.get("pSqlcode"));
		Log.Debug("pSqlerrm : "+map.get("pSqlerrm"));

		Map<String, Object> resultMap = new HashMap<String, Object>();
		if (map.get("pSqlcode") != null) {
			resultMap.put("Code", map.get("pSqlcode").toString());
		}
		if (map.get("pSqlerrm") != null) {
			resultMap.put("Message", map.get("pSqlerrm").toString());
		}

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Result", resultMap);
		Log.DebugEnd();
		return mv;
	}
	
	
	/**
	 * 프로시저
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=prcP_TIM_TC_LOAD", method = RequestMethod.POST )
	public ModelAndView prcP_TIM_TC_LOAD(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",   session.getAttribute("ssnSabun"));
		
		Map<?, ?> map  = timeCardMgrService.prcP_TIM_TC_LOAD(paramMap);
		
		Log.Debug("obj : "+map);
		Log.Debug("pSqlcode : "+map.get("pSqlcode"));
		Log.Debug("pSqlerrm : "+map.get("pSqlerrm"));
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		if (map.get("pSqlcode") != null) {
			resultMap.put("Code", map.get("pSqlcode").toString());
		}
		if (map.get("pSqlerrm") != null) {
			resultMap.put("Message", map.get("pSqlerrm").toString());
		}
		
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Result", resultMap);
		Log.DebugEnd();
		return mv;
	}
	
	/**
	 * 프로시저
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=callTimeCardMgrP_TIM_WORK_HOUR_CHG", method = RequestMethod.POST )
	public ModelAndView callTimeCardMgrP_TIM_WORK_HOUR_CHG(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",   session.getAttribute("ssnSabun"));

		Map<?, ?> map  = timeCardMgrService.callTimeCardMgrP_TIM_WORK_HOUR_CHG(paramMap);

		Log.Debug("obj : "+map);
		Log.Debug("sqlcode : "+map.get("sqlcode"));
		Log.Debug("sqlerrm : "+map.get("sqlerrm"));

		Map<String, Object> resultMap = new HashMap<String, Object>();
		if (map.get("sqlCode") != null) {
			resultMap.put("Code", map.get("sqlCode").toString());
		}
		if (map.get("sqlErrm") != null) {
			resultMap.put("Message", map.get("sqlErrm").toString());
		}

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Result", resultMap);
		Log.DebugEnd();
		return mv;
	}
	
	/**
	 * 프로시저
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=callTimeCardMgrWorkHourChg", method = RequestMethod.POST )
	public ModelAndView callTimeCardMgrWorkHourChg(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",   session.getAttribute("ssnSabun"));
		
		Map<?, ?> map  = timeCardMgrService.callTimeCardMgrWorkHourChg(paramMap);
		
		Log.Debug("obj : "+map);
		Log.Debug("sqlcode : "+map.get("sqlcode"));
		Log.Debug("sqlerrm : "+map.get("sqlerrm"));
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		if (map.get("sqlCode") != null) {
			resultMap.put("Code", map.get("sqlCode").toString());
		}
		if (map.get("sqlErrm") != null) {
			resultMap.put("Message", map.get("sqlErrm").toString());
		}
		
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Result", resultMap);
		Log.DebugEnd();
		return mv;
	}

}
