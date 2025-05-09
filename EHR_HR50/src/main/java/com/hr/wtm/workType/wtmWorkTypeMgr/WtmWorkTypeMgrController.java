package com.hr.wtm.workType.wtmWorkTypeMgr;

import com.hr.common.exception.HrException;
import com.hr.common.logger.Log;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
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
 * 근무유형관리 Controller
 *
 * @author OJS
 *
 */
@Controller
@RequestMapping(value="/WtmWorkTypeMgr.do", method=RequestMethod.POST )
public class WtmWorkTypeMgrController {

	/**
	 * 근태마감기준일설정 서비스
	 */
	@Inject
	@Named("WorkTypeMgrService")
	private WtmWorkTypeMgrService wtmWorkTypeMgrService;

	/**
	 * 근무유형관리 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewWtmWorkTypeMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewWtmWorkTypeMgr() throws Exception {
		return "wtm/workType/wtmWorkTypeMgr/wtmWorkTypeMgr";
	}

	@RequestMapping(params="cmd=viewWtmWorkClassMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public ModelAndView viewWtmWorkClassMgr( @RequestParam Map<String, Object> paramMap) {
		Log.DebugStart();

		ModelAndView mv = new ModelAndView();
		mv.setViewName("wtm/workType/wtmWorkTypeMgr/wtmWorkClassMgr");
		mv.addObject("selectedWorkClassCd", paramMap.get("workClassCd"));
		Log.DebugEnd();

		return mv;
	}

	@RequestMapping(params="cmd=viewWtmWorkClassApprLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewWtmWorkClassApprLayer() throws Exception {
		return "wtm/workType/wtmWorkTypeMgr/wtmWorkClassApprLayer";
	}

	@RequestMapping(params="cmd=viewWtmWorkPreViewLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewWtmWorkPreViewLayer() throws Exception {
		return "wtm/workType/wtmWorkTypeMgr/wtmWorkPreViewLayer";
	}

	@RequestMapping(params="cmd=viewWtmWorkClassTargetLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewWtmWorkClassTargetLayer() throws Exception {
		return "wtm/workType/wtmWorkTypeMgr/wtmWorkClassTargetLayer";
	}

	@RequestMapping(params="cmd=viewWtmWorkGroupTargetLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewWtmWorkGroupTargetLayer() throws Exception {
		return "wtm/workType/wtmWorkTypeMgr/wtmWorkGroupTargetLayer";
	}

	@RequestMapping(params="cmd=viewWtmWorkUnassignedEmpLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewWtmWorkUnassignedEmpLayer() throws Exception {
		return "wtm/workType/wtmWorkTypeMgr/wtmWorkUnassignedEmpLayer";
	}

	@RequestMapping(params="cmd=viewWtmWorkClassShiftTargetLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewWtmWorkClassShiftTargetLayer() throws Exception {
		return "wtm/workType/wtmWorkTypeMgr/wtmWorkClassShiftTargetLayer";
	}

	@RequestMapping(params="cmd=viewWtmWorkClassSchDetail", method = {RequestMethod.POST, RequestMethod.GET} )
	public ModelAndView viewWtmWorkClassSchDetail( @RequestParam Map<String, Object> paramMap) {
		Log.DebugStart();

		ModelAndView mv = new ModelAndView();
		mv.setViewName("wtm/workType/wtmWorkTypeMgr/wtmWorkClassSchDetail");
		mv.addObject("selectedWorkClassCd", paramMap.get("workClassCd"));
		mv.addObject("selectedWorkGroupCd", paramMap.get("workGroupCd"));
		Log.DebugEnd();

		return mv;
	}

	/**
	 * 근무유형관리 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getWtmWorkClassMgrList", method = RequestMethod.POST )
	public ModelAndView getWtmWorkClassMgrList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = wtmWorkTypeMgrService.getWtmWorkClassMgrList(paramMap);

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
	 * 근무유형관리 타이틀 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getWtmWorkClassCdList", method = RequestMethod.POST )
	public ModelAndView getWtmWorkClassCdList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = wtmWorkTypeMgrService.getWtmWorkClassCdList(paramMap);

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
	 * 근무유형관리 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveWtmWorkClassMgr", method = RequestMethod.POST )
	public ModelAndView saveWtmWorkClassMgr(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));

		Map<String, Object> resultMap = new HashMap<>();
		String message = "";
		try{
			resultMap = wtmWorkTypeMgrService.saveWtmWorkClassMgr(paramMap);
			String code = resultMap.get("Code").toString();
			if (Integer.parseInt(code) > 0) {
				message = "저장 되었습니다.";
			} else {
				message = "저장에 실패 하였습니다.";
			}
		}catch(Exception e){
			message = "저장에 실패 하였습니다.";
		}

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", resultMap);
		mv.addObject("Message", message);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 근무유형 사용 여부 체크
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveWtmWorkClassUseYn", method = RequestMethod.POST )
	public ModelAndView saveWtmWorkClassUseYn(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));

		int resultCnt = -1;
		String message = "";
		try{
			resultCnt = wtmWorkTypeMgrService.saveWtmWorkClassUseYn(paramMap);
			if (resultCnt > 0) {
				message = "저장 되었습니다.";
			} else {
				message = "저장에 실패 하였습니다.";
			}
		}catch(Exception e){
			message = "저장에 실패 하였습니다.";
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
	 * 근무유형관리 삭제
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=deleteWtmWorkClassMgr", method = RequestMethod.POST )
	public ModelAndView deleteWtmWorkClassMgr(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));

		int resultCnt = -1;
		String message = "";
		try{
			resultCnt = wtmWorkTypeMgrService.deleteWtmWorkClassMgr(paramMap);
			if (resultCnt > 0) {
				message = "삭제 되었습니다.";
			} else {
				message = "삭제 실패 하였습니다.";
			}
		}catch(Exception e){
			message = "삭제 실패 하였습니다.";
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
	 * 기본근무유형 설정
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveWorkClassDefYn", method = RequestMethod.POST )
	public ModelAndView saveWorkClassDefYn(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		int resultCnt = -1;
		String message = "";
		try{
			resultCnt = wtmWorkTypeMgrService.saveWorkClassDefYn(paramMap);
			if (resultCnt > 0) {
				message = "저장 되었습니다.";
			} else {
				message = "저장에 실패 하였습니다.";
			}
		}catch(Exception e){
			message = "저장에 실패 하였습니다.";
		}

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Code", resultCnt);
		mv.addObject("Message", message);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 근무유형관리 타이틀 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getWorkClassEmpList", method = RequestMethod.POST )
	public ModelAndView getWorkClassEmpList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = wtmWorkTypeMgrService.getWorkClassEmpList(paramMap);

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
	 * 근무유형관리 교대조 스케줄 조회
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
			list = wtmWorkTypeMgrService.getWorkScheduleList(paramMap);
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
	 * 근무유형관리 교대조 스케줄 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getWorkGroupList", method = RequestMethod.POST )
	public ModelAndView getWorkGroupList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = wtmWorkTypeMgrService.getWorkGroupList(paramMap);
			paramMap.remove("patterns");
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
	 * 근무유형관리 교대근무 스케줄 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveWtmWorkSchedule", method = RequestMethod.POST )
	public ModelAndView saveWtmWorkSchedule(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		int resultCnt = -1;
		String message = "";
		try{
			resultCnt = wtmWorkTypeMgrService.saveWtmWorkSchedule(paramMap);
			if (resultCnt > 0) {
				message = "저장 되었습니다.";
			} else {
				message = "저장에 실패 하였습니다.";
			}
		}catch(Exception e){
			message = "저장에 실패 하였습니다.";
		}

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Code", resultCnt);
		mv.addObject("DATA", paramMap);
		mv.addObject("Message", message);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 근무유형관리 교대근무 근무조 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveWtmWorkGroup", method = RequestMethod.POST )
	public ModelAndView saveWtmWorkGroup(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("sdate", "19000101");
		paramMap.put("edate", "29991231");

		int resultCnt = -1;
		String message = "";
		Map<String, Object> group = new HashMap<>();

		try{
			resultCnt = wtmWorkTypeMgrService.saveWtmWorkGroup(paramMap);
			if (resultCnt > 0) {
				group = (Map<String, Object>) wtmWorkTypeMgrService.getWorkGroupList(paramMap).get(0);
				message = "저장 되었습니다.";
			} else {
				message = "저장에 실패 하였습니다.";
			}
		}catch(Exception e){
			message = "저장에 실패 하였습니다.";
		}

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Code", resultCnt);
		mv.addObject("Message", message);
		mv.addObject("DATA", group);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 근무유형관리 스케줄 삭제
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=deleteWtmWorkSchedule", method = RequestMethod.POST )
	public ModelAndView deleteWtmWorkSchedule(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));

		int resultCnt = -1;
		String message = "";
		try{
			resultCnt = wtmWorkTypeMgrService.deleteWtmWorkSchedule(paramMap);
//			if (resultCnt > 0) {
				message = "삭제 되었습니다.";
//			} else {
//				message = "삭제 실패 하였습니다.";
//			}
		}catch(Exception e){
			message = "삭제 실패 하였습니다.";
			resultCnt = -1;
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
	 * 근무유형관리 근무조 삭제
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=deleteWtmWorkGroup", method = RequestMethod.POST )
	public ModelAndView deleteWtmWorkGroup(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));

		int resultCnt = -1;
		String message = "";
		try{
			resultCnt = wtmWorkTypeMgrService.deleteWtmWorkGroup(paramMap);
//			if (resultCnt > 0) {
				message = "삭제 되었습니다.";
//			} else {
//				message = "삭제 실패 하였습니다.";
//			}
		}catch(Exception e){
			resultCnt = -1;
			message = "삭제 실패 하였습니다.";
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
	 * 근무유형관리 교대조 대상자 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getWtmWorkClassUnassignedEmpList", method = RequestMethod.POST )
	public ModelAndView getWtmWorkClassEmpList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = wtmWorkTypeMgrService.getWtmWorkClassUnassignedEmpList(paramMap);
			paramMap.remove("patterns");
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
	 * 근무유형관리 대상 target 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getWtmWorkTargetList", method = RequestMethod.POST )
	public ModelAndView getWtmWorkTargetList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = wtmWorkTypeMgrService.getWtmWorkTargetList(paramMap);
			paramMap.remove("patterns");
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
	 * 근무유형관리 근무조 대상 target 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getWtmWorkGroupTargetList", method = RequestMethod.POST )
	public ModelAndView getWtmWorkGroupTargetList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = wtmWorkTypeMgrService.getWtmWorkGroupTargetList(paramMap);
			paramMap.remove("patterns");
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
	 * 근무유형관리 대상 조직도 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getWtmWorkTargetOrgList", method = RequestMethod.POST )
	public ModelAndView getWtmWorkTargetOrgList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = wtmWorkTypeMgrService.getWtmWorkTargetOrgList(paramMap);
			paramMap.remove("patterns");
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
	 * 근무유형 대상자 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveWtmWorkClassTarget", method = RequestMethod.POST )
	public ModelAndView saveWtmWorkClassTarget(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("targets", WtmWorkClassTarget.from(paramMap));

		int resultCnt = -1;
		String message = "";

		try{
			resultCnt = wtmWorkTypeMgrService.saveWtmWorkClassTarget(paramMap);
			if (resultCnt > 0) {
				message = "저장 되었습니다.";
			} else {
				message = "저장에 실패 하였습니다.";
			}
		}catch(Exception e){
			message = "저장에 실패 하였습니다.";
		}

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Code", resultCnt);
		mv.addObject("Message", message);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 교대조 target 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getWtmWorkShiftTargetList", method = RequestMethod.POST )
	public ModelAndView getWtmWorkShiftTargetList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = wtmWorkTypeMgrService.getWtmWorkShiftTargetList(paramMap);
			paramMap.remove("patterns");
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
	 * 교대조 target 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getWorkGroupEmpList", method = RequestMethod.POST )
	public ModelAndView getWorkGroupEmpList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = wtmWorkTypeMgrService.getWorkGroupEmpList(paramMap);
			paramMap.remove("patterns");
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
	 * 근무조 대상자 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveWtmWorkClassShiftTarget", method = RequestMethod.POST )
	public ModelAndView saveWtmWorkClassShiftTarget(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("targets", WtmWorkClassShiftTarget.from(paramMap));

		int resultCnt = -1;
		String message = "";

		try{
			resultCnt = wtmWorkTypeMgrService.saveWtmWorkClassShiftTarget(paramMap);
			if (resultCnt > 0) {
				message = "저장 되었습니다.";
			} else {
				message = "저장에 실패 하였습니다.";
			}
		}catch(Exception e){
			message = "저장에 실패 하였습니다.";
		}

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Code", resultCnt);
		mv.addObject("Message", message);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 근무스케줄 신청 설정 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getWtmWorkClassApplCdList", method = RequestMethod.POST )
	public ModelAndView getWtmWorkClassApplCdList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = wtmWorkTypeMgrService.getWtmWorkClassApplCdList(paramMap);
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
	 * 근무스케줄 신청 설정 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveWtmWorkClassApplCd", method = RequestMethod.POST )
	public ModelAndView saveWtmWorkClassApplCd(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));

		int resultCnt = -1;
		String message = "";
		String applCd = "";
		try{
			Map resMap = wtmWorkTypeMgrService.saveWtmWorkClassApplCd(paramMap);
			resultCnt = (int) resMap.get("cnt");
			applCd = (String) resMap.get("applCd");
			if (resultCnt > 0) {
				message = "저장 되었습니다.";
			} else {
				message = "저장에 실패 하였습니다.";
			}
		}catch(Exception e){
			message = "저장에 실패 하였습니다.";
		}

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Code", resultCnt);
		mv.addObject("ApplCd", applCd);
		mv.addObject("Message", message);
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
			list = wtmWorkTypeMgrService.getWorkClassSchDetailList(paramMap);
			list2 = wtmWorkTypeMgrService.getWorkClassSchDetailWorkHours(paramMap);

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
	 * 근무스케줄 상세 설정 저장
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
			resultCnt = wtmWorkTypeMgrService.saveWorkClassSchDetail(paramMap);
			if (resultCnt > 0) {
				message = "저장 되었습니다.";
			} else {
				message = "저장에 실패 하였습니다.";
			}
		}catch(Exception e){
			message = "저장에 실패 하였습니다.";
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
			resultCnt = wtmWorkTypeMgrService.saveWorkClassSchDetailApply(paramMap);
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
