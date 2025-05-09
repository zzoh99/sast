package com.hr.wtm.request.wtmAttendTimeAdjAppDet;

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
 * 출퇴근시간 변경신청 Controller
 *
 * @author EW
 *
 */
@Controller
@RequestMapping({"/WtmAttendTimeAdjApp.do","/WtmAttendTimeAdjAppDet.do"})
public class WtmAttendTimeAdjAppDetController {
	/**
	 * 출퇴근시간 변경신청 서비스
	 */
	@Inject
	@Named("WtmAttendTimeAdjAppDetService")
	private WtmAttendTimeAdjAppDetService wtmAttendTimeAdjAppDetService;

	/**
	 * 출퇴근시간 변경신청 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewWtmAttendTimeAdjAppDet", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewWtmAttendTimeAdjAppDet() throws Exception {
		return "wtm/request/wtmAttendTimeAdjAppDet/wtmAttendTimeAdjAppDet";
	}

	/**
	 * 출퇴근시간 변경신청 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getWtmAttendTimeAdjAppDetList", method = RequestMethod.POST )
	public ModelAndView getWtmAttendTimeAdjAppDetList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = wtmAttendTimeAdjAppDetService.getWtmAttendTimeAdjAppDetList(paramMap);
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
	 * 출퇴근시간 변경신청 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveWtmAttendTimeAdjAppDet", method = RequestMethod.POST )
	public ModelAndView saveWtmAttendTimeAdjAppDet(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		convertMap.put("tdYmd", paramMap.get("tdYmd"));
		convertMap.put("searchApplSeq", paramMap.get("searchApplSeq"));
		convertMap.put("searchApplSabun", paramMap.get("searchApplSabun"));
		convertMap.put("reason", paramMap.get("reason"));

		String message = "";
		int resultCnt = -1;
		try{
			resultCnt =wtmAttendTimeAdjAppDetService.saveWtmAttendTimeAdjAppDet(convertMap);
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
	 * 출퇴근시간 변경신청 월마감 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getWtmAttendTimeAdjAppDetEndYn", method = RequestMethod.POST )
	public ModelAndView getWtmAttendTimeAdjAppDetEndYn(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		
		Map<?, ?> map = null;
		String Message = "";
	
		try{
			map = wtmAttendTimeAdjAppDetService.getWtmAttendTimeAdjAppDetEndYn(paramMap);
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
	 * 출퇴근시간 변경신청 DupCheck 단건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getWtmAttendTimeAdjAppDetDupCheck", method = RequestMethod.POST )
	public ModelAndView getWtmAttendTimeAdjAppDetDupCheck(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		
		Map<?, ?> map = null;
		String Message = "";
	
		try{
			map = wtmAttendTimeAdjAppDetService.getWtmAttendTimeAdjAppDetDupCheck(paramMap);
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
