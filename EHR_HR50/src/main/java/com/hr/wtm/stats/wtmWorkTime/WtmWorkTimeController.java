package com.hr.wtm.stats.wtmWorkTime;

import com.hr.common.code.CommonCodeService;
import com.hr.common.language.LanguageUtil;
import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
/**
 * 일근무관리 Controller
 *
 * @author JSG
 *
 */
@Controller
@RequestMapping(value="/WtmWorkTime.do", method=RequestMethod.POST )
public class WtmWorkTimeController {
	/**
	 * 일근무관리 서비스
	 */
	@Inject
	@Named("WtmWorkTimeService")
	private WtmWorkTimeService wtmWorkTimeService;

	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;

	/**
	 * workTime View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewWtmWorkTime",method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewWorkTime() throws Exception {
		return "wtm/stats/wtmWorkTime/wtmWorkTime";
	}
	
	/**
	 * 일근무관리 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getWtmWorkTimeList", method = RequestMethod.POST )
	public ModelAndView getWorkTimeList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {

		paramMap.put("ssnSabun",		session.getAttribute("ssnSabun"));
		paramMap.put("ssnEnterCd",		session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSearchType",	session.getAttribute("ssnSearchType"));
		paramMap.put("ssnGrpCd",		session.getAttribute("ssnGrpCd"));


		Log.DebugStart();

		List<?> list  = new ArrayList<>();
		String message = "";

		try {
//			List<?> titleList = wtmWorkTimeService.getWtmWorkTimeHeaderList(paramMap);
//			paramMap.put("titles", titleList);
			// TODO: 리포트 별 화면 출력할 수 있는 옵션 추가해야함.
			list = wtmWorkTimeService.getWtmWorkTimeList(paramMap);
		} catch(Exception e) {
			Log.Error(e.getLocalizedMessage());
			message = LanguageUtil.getMessage("msg.alertSearchFail2", null, "조회에 실패하였습니다.");
		}
		ModelAndView mv = new ModelAndView();
		
		if ("Y".equals(paramMap.get("exceldown"))) {
			mv.setViewName("common/etc/DirectDown2Excel");
			mv.addObject("SHEETDATA", list);
		} else {
			mv.setViewName("jsonView");
			mv.addObject("DATA", list);
		}
		
		mv.addObject("Message", message);
		Log.DebugEnd();
		return mv;
	}
	
	/**
	 * workTime 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getWorkStatusInfo", method = RequestMethod.POST )
	public ModelAndView getWorkStatusInfo(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<>();
		String message = "";
		try {
			list = wtmWorkTimeService.getWorkStatusInfo(paramMap);
		} catch(Exception e) {
			Log.Error(e.getLocalizedMessage());
			message = "조회에 실패 하였습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", message);
		Log.DebugEnd();
		return mv;
	}
	
	/**
	 * workTime 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getWtmWorkTimeHeaderList", method = RequestMethod.POST )
	public ModelAndView getWtmWorkTimeHeaderList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<>();
		String message = "";
		try {
			list = wtmWorkTimeService.getWtmWorkTimeHeaderList(paramMap);
		} catch(Exception e) {
			Log.Error(e.getLocalizedMessage());
			message = "조회에 실패 하였습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", message);
		Log.DebugEnd();
		return mv;
	}
	
	/**
	 * getWorkTimeList2 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getWtmWorkTimeList2", method = RequestMethod.POST )
	public ModelAndView getWtmWorkTimeList2(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<>();
		String message = "";
		try {
			list = wtmWorkTimeService.getWtmWorkTimeList2(paramMap);
		} catch(Exception e) {
			Log.Error(e.getLocalizedMessage());
			message = "조회에 실패 하였습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", message);
		Log.DebugEnd();
		return mv;
	}
	
	/**
	 * 변경신청 삭제
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveWorkTime", method = RequestMethod.POST )
	public ModelAndView deleteSabApp(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		
		String message = "";
		int resultCnt = -1;
		try{
			resultCnt = wtmWorkTimeService.saveWorkTime(convertMap);
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
	 * workTime 단건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getUserIntervalDate", method = RequestMethod.POST )
	public ModelAndView getUserIntervalDate(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
	
		Map<?, ?> map = null;
		String Message = "";
	
		try{
			map = wtmWorkTimeService.getUserIntervalDate(paramMap);
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
	 * workTime 단건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getUserAuthCheck", method = RequestMethod.POST )
	public ModelAndView getUserAuthCheck(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
	
		Map<?, ?> map = null;
		String Message = "";
	
		try{
			map = wtmWorkTimeService.getUserAuthCheck(paramMap);
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

}
