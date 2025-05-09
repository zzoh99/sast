package com.hr.wtm.workMgr.wtmShiftSchMgr;

import com.hr.common.exception.HrException;
import com.hr.common.logger.Log;
import com.hr.common.other.OtherService;
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
 * 교대조 스케줄 관리 Controller
 *
 * @author OJS
 *
 */
@Controller
@RequestMapping(value="/WtmShiftSchMgr.do", method=RequestMethod.POST )
public class WtmShiftSchMgrController {

	/**
	 * 교대조 스케줄 관리 Service
	 */
	@Autowired
	private WtmShiftSchMgrService wtmShiftSchMgrService;

	/**
	 * 교대조 스케줄 관리 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewWtmShiftSchMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public ModelAndView viewWtmShiftSchMgr( @RequestParam Map<String, Object> paramMap) {
		Log.DebugStart();

		ModelAndView mv = new ModelAndView();
		mv.setViewName("wtm/workMgr/wtmShiftSchMgr/wtmShiftSchMgr");
		mv.addObject("selectedWorkClassCd", paramMap.get("workClassCd"));
		mv.addObject("selectedWorkGroupCd", paramMap.get("workGroupCd"));
		Log.DebugEnd();

		return mv;
	}

	/**
	 * 교대조 스케줄 설정 Layer View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewWtmShiftSchMgrChipLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public ModelAndView viewWtmShiftSchMgrChipLayer(@RequestParam Map<String, Object> paramMap) {
		Log.DebugStart();

		ModelAndView mv = new ModelAndView();
		mv.setViewName("wtm/workMgr/wtmShiftSchMgr/wtmShiftSchMgrChipLayer");
		mv.addObject("selectedWorkClassCd", paramMap.get("workClassCd"));
		mv.addObject("selectedWorkGroupCd", paramMap.get("workGroupCd"));
		Log.DebugEnd();

		return mv;
	}

	/**
	 * 교대조 스케줄 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getWorkScheduleList", method = RequestMethod.POST )
	public ModelAndView getWorkScheduleList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = wtmShiftSchMgrService.getWorkScheduleList(paramMap);
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
	 * 근무스케줄 상세 설정 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getWorkClassSchDetailList", method = RequestMethod.POST )
	public ModelAndView getWorkClassSchDetailList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		//교대조 상세설정테이블(TWTM035)에 데이터가 있으면 그 스케줄을 보여주고,
		//TWTM035에 저장된 데이터가 없다면 근무조 패턴(TWTM034)으로 상세 데이터 넘기기
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));

		List<?> list  = new ArrayList<Object>();
		List<?> list2  = new ArrayList<Object>();
		String Message = "";
		try{
			list = wtmShiftSchMgrService.getWorkClassSchDetailList(paramMap);
			list2 = wtmShiftSchMgrService.getWorkClassSchDetailWorkHours(paramMap);

		}catch(Exception e){
			Message="조회에 실패 하였습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("HOURS", list2);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 근무스케줄 상세 설정 임시저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveWorkClassSchDetail", method = RequestMethod.POST )
	public ModelAndView saveWorkClassSchDetail(
			HttpSession session,  HttpServletRequest request,
			@RequestBody Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));

		int resultCnt = -1;
		String message = "";
		try{
			resultCnt = wtmShiftSchMgrService.saveWorkClassSchDetail(paramMap);
			if (resultCnt > 0) {
				message = "임시저장 되었습니다.";
			} else {
				message = "임시저장에 실패 하였습니다.";
			}
		} catch (HrException e) {
			message = e.getMessage();
		} catch(Exception e){
			Log.Error(" ** 근무스케줄 상세설정 임시저장 시 오류가 발생하였습니다. >> " + e.getLocalizedMessage());
			message = "임시저장에 실패 하였습니다.";
		}

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Code", resultCnt);
		mv.addObject("Message", message);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 근무스케줄 반영
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveWorkClassSchDetailApply", method = RequestMethod.POST )
	public ModelAndView saveWorkClassSchDetailApply(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));

		int resultCnt = -1;
		String message = "";
		try{
			resultCnt = wtmShiftSchMgrService.saveWorkClassSchDetailApply(paramMap);
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
			message = "저장에 실패 하였습니다.";
		}

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Code", resultCnt);
		mv.addObject("Message", message);
		Log.DebugEnd();
		return mv;
	}
}
