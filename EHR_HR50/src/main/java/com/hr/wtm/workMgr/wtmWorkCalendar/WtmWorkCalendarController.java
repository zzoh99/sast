package com.hr.wtm.workMgr.wtmWorkCalendar;

import com.github.f4b6a3.tsid.TsidCreator;
import com.hr.common.exception.HrException;
import com.hr.common.logger.Log;
import com.hr.common.other.OtherService;
import com.hr.common.util.ParamUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 근태/근무캘린더 Controller
 *
 * @author OJS
 *
 */
@Controller
@RequestMapping(value="/WtmWorkCalendar.do", method=RequestMethod.POST )
public class WtmWorkCalendarController {

	/**
	 * 근태/근무캘린더 Service
	 */
	@Autowired
	private WtmWorkCalendarService wtmWorkCalendarService;

	@Autowired
	private OtherService otherService;

	/**
	 * wtmWorkCalendar View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewWtmWorkCalendar", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewWtmWorkCalendar() throws Exception {
		return "wtm/workMgr/wtmWorkCalendar/wtmWorkCalendar";
	}

	/**
	 * wtmWorkCalendar 근무스케줄 신청 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewWtmReqWorkSchedule", method = {RequestMethod.POST, RequestMethod.GET} )
	public ModelAndView viewWtmReqWorkSchedule( @RequestParam Map<String, Object> paramMap) {
		Log.DebugStart();

		ModelAndView mv = new ModelAndView();
		mv.setViewName("wtm/workMgr/wtmWorkCalendar/wtmReqWorkSchedule");
		mv.addAllObjects(paramMap);
		Log.DebugEnd();

		return mv;
	}

	/**
	 * wtmWorkCalendar 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getWtmWorkCalendarList", method = RequestMethod.POST )
	public ModelAndView getWtmWorkCalendarList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		paramMap.put("ssnGrpCd", 	session.getAttribute("ssnGrpCd"));

		List<?> inOutTime = null;
		List<?> workList  = new ArrayList<Object>();
		List<?> attendList  = new ArrayList<Object>();

		String Message = "";
		try{
			inOutTime = wtmWorkCalendarService.getWtmWorkCalendarInOutList(paramMap);
			workList = wtmWorkCalendarService.getWtmWorkCalendarWorkList(paramMap);
			attendList = wtmWorkCalendarService.getWtmWorkCalendarAttendList(paramMap);
		}catch(Exception e){
			Message="조회에 실패 하였습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("INOUT", inOutTime);
		mv.addObject("WORK", workList);
		mv.addObject("ATTEND", attendList);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 잔여 휴가 내역 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getWtmWorkCalendarVacationMap", method = RequestMethod.POST )
	public ModelAndView getWtmWorkCalendarVacationMap(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		Map<?, ?> map = null;
		String Message = "";

		try{
			map = wtmWorkCalendarService.getWtmWorkCalendarVacationMap(paramMap);
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

	@RequestMapping(params="cmd=getWtmWorkCalendarWorkTimeMap", method = RequestMethod.POST )
	public ModelAndView getWtmWorkCalendarWorkTimeMap(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");

		try{
			mv.addObject("DATA", wtmWorkCalendarService.getWtmWorkCalendarWorkTimeMap(paramMap));
		}catch(Exception e){
			mv.addObject("Message", "조회에 실패 하였습니다.");
			Log.Debug(e.getMessage());
		}

		Log.DebugEnd();
		return mv;
	}

	/**
	 * 출퇴근시간변경 신청 삭제
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=deleteWtmCalendarAttendTimeAdjApp", method = RequestMethod.POST )
	public ModelAndView deleteWtmCalendarAttendTimeAdjApp(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));
		paramMap.put("ssnAdminYn", session.getAttribute("ssnAdminYn"));

		String message = "";
		int resultCnt = -1;
		try {

			resultCnt = wtmWorkCalendarService.deleteWtmCalendarAttendTimeAdjApp(paramMap);

			if (resultCnt > 0) {
				message = com.hr.common.language.LanguageUtil.getMessage("msg.alertSaveOkV1", null, "저장 되었습니다."); } else{ message=com.hr.common.language.LanguageUtil.getMessage("msg.alertSaveNoData", null, "저장된 내용이 없습니다.");
			}

		} catch(HrException e) {
			Log.Error(e.getLocalizedMessage());
			message = e.getLocalizedMessage();
		} catch(Exception e) {
			Log.Error(e.getLocalizedMessage());
			message=com.hr.common.language.LanguageUtil.getMessage("msg.alertSaveFail2", null, "저장에 실패하였습니다.");
		}

		Map<String, Object> resultMap = new HashMap<>();
		resultMap.put("Code", resultCnt);
		resultMap.put("Message", message);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Result", resultMap);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 근태 신청 삭제
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=deleteWtmAttendCalendar", method = RequestMethod.POST )
	public ModelAndView deleteWtmAttendCalendar(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));
		paramMap.put("ssnAdminYn", session.getAttribute("ssnAdminYn"));

		String message = "";
		int resultCnt = -1;
		try {

			resultCnt = wtmWorkCalendarService.deleteWtmAttendCalendar(paramMap);
			
			if (resultCnt > 0) {
				message = com.hr.common.language.LanguageUtil.getMessage("msg.alertSaveOkV1", null, "저장 되었습니다."); } else{ message=com.hr.common.language.LanguageUtil.getMessage("msg.alertSaveNoData", null, "저장된 내용이 없습니다.");
			}
			
		} catch(HrException e) {
			Log.Error(e.getLocalizedMessage());
			message = e.getLocalizedMessage();
		} catch(Exception e) {
			Log.Error(e.getLocalizedMessage());
			message=com.hr.common.language.LanguageUtil.getMessage("msg.alertSaveFail2", null, "저장에 실패하였습니다.");
		}

		Map<String, Object> resultMap = new HashMap<>();
		resultMap.put("Code", resultCnt);
		resultMap.put("Message", message);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Result", resultMap);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 근무 신청 삭제
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=deleteWtmWorkCalendar", method = RequestMethod.POST )
	public ModelAndView deleteWtmWorkCalendar(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));
		paramMap.put("ssnAdminYn", session.getAttribute("ssnAdminYn"));

		String message = "";
		int resultCnt = -1;
		try {

			resultCnt = wtmWorkCalendarService.deleteWtmWorkCalendar(paramMap);

			if (resultCnt > 0) {
				message = com.hr.common.language.LanguageUtil.getMessage("msg.alertSaveOkV1", null, "저장 되었습니다."); } else{ message=com.hr.common.language.LanguageUtil.getMessage("msg.alertSaveNoData", null, "저장된 내용이 없습니다.");
			}

		} catch(HrException e) {
			Log.Error(e.getLocalizedMessage());
			message = e.getLocalizedMessage();
		} catch(Exception e) {
			Log.Error(e.getLocalizedMessage());
			message=com.hr.common.language.LanguageUtil.getMessage("msg.alertSaveFail2", null, "저장에 실패하였습니다.");
		}

		Map<String, Object> resultMap = new HashMap<>();
		resultMap.put("Code", resultCnt);
		resultMap.put("Message", message);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Result", resultMap);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 신청자 근무유형 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getWtmWorkCalendarWorkClass", method = RequestMethod.POST )
	public ModelAndView getWtmWorkCalendarWorkClass(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		Map<?, ?> map = null;
		String Message = "";

		try{
			map = wtmWorkCalendarService.getWtmWorkCalendarWorkClass(paramMap);
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
	 * 전체 근태 코드 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getWtmWorkCalendarGntCdList", method = RequestMethod.POST )
	public ModelAndView getWtmWorkCalendarGntCdList(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		List<?> list  = new ArrayList<Object>();
		String Message = "";

		try{
			list = wtmWorkCalendarService.getWtmWorkCalendarGntCdList(paramMap);
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
	 * 전체 근무 코드 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getWtmWorkCalendarWorkCdList", method = RequestMethod.POST )
	public ModelAndView getWtmWorkCalendarWorkCdList(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		List<?> list  = new ArrayList<Object>();
		String Message = "";

		try{
			list = wtmWorkCalendarService.getWtmWorkCalendarWorkCdList(paramMap);
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
	 * 기준 코드 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getWtmWorkCalendarBaseCd", method = RequestMethod.POST )
	public ModelAndView getWtmWorkCalendarBaseCd(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		Map<?,?> map  = new HashMap<>();
		String Message = "";

		try{
			map = wtmWorkCalendarService.getWtmWorkCalendarBaseCd(paramMap);
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
	 * 회사 휴일 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getWtmWorkCalendarHolidays", method = RequestMethod.POST )
	public ModelAndView getWtmWorkCalendarHolidays(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = wtmWorkCalendarService.getWtmWorkCalendarHolidays(paramMap);
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
	 * 근무스케줄 신청일자 기준 근무달력 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getReqWorkScheduleDayList", method = RequestMethod.POST )
	public ModelAndView getReqWorkScheduleDayList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		List<?>[] list  = null;

		String Message = "";
		try{
			list = wtmWorkCalendarService.getReqWorkScheduleDayList(paramMap);
		}catch(Exception e){
			Message="조회에 실패 하였습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
        if (list != null) {
            mv.addObject("DAY", list[0]);
            mv.addObject("SCHEDULE", list[1]);
        }
        mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 근무스케줄 신청 저장
	 */
	@RequestMapping(params="cmd=saveWtmReqWorkSchedule", method = RequestMethod.POST )
	public ModelAndView saveWtmReqWorkSchedule(
			HttpSession session,  HttpServletRequest request,
			@RequestBody Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();

		String message = "";
		int resultCnt = -1;

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		try{
			// 기준일자의 근무유형 가져오기
			Map<?, ?> resultMap = wtmWorkCalendarService.getWtmWorkCalendarWorkClass(paramMap);
			paramMap.put("workClassCd", resultMap.get("workClassCd").toString());

			// 신청서 순번 채번
			Map params = new HashMap();
			params.put("seqId", "APPL");
			String applSeq = otherService.getSequence(params).get("getSeq").toString();
			paramMap.put("applSeq", applSeq);

			resultCnt = wtmWorkCalendarService.saveWtmReqWorkSchedule(paramMap);
			if (resultCnt > 0) {
				message = "저장 되었습니다.";
			} else if (resultCnt == 0) {
				message = "저장된 자료가 없습니다.";
			} else {
				message = "저장에 실패 하였습니다.";
			}
		} catch(HrException he){
			resultCnt = -1;
			message = he.getMessage();
		} catch(Exception e){
			resultCnt = -1;
			message="저장에 실패하였습니다.";
		}

		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("Code", resultCnt);
		resultMap.put("Data", paramMap);
		resultMap.put("Message", message);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Result", resultMap);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 근무스케쥴 신청 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getWtmReqWorkScheduleDet", method = RequestMethod.POST )
	public ModelAndView getWtmReqWorkScheduleDet(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = wtmWorkCalendarService.getWtmReqWorkScheduleDet(paramMap);
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
