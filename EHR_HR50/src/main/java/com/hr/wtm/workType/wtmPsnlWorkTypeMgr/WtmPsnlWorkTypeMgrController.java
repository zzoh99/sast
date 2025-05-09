package com.hr.wtm.workType.wtmPsnlWorkTypeMgr;

import com.hr.common.logger.Log;
import com.hr.wtm.workType.wtmWorkTypeMgr.WtmWorkClassTarget;
import com.hr.wtm.workType.wtmWorkTypeMgr.WtmWorkTypeMgrService;
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
 * 개인근무유형관리 Controller
 *
 * @author OJS
 *
 */
@Controller
@RequestMapping(value="/WtmPsnlWorkTypeMgr.do", method=RequestMethod.POST )
public class WtmPsnlWorkTypeMgrController {

	@Inject
	@Named("WtmPsnlWorkTypeMgrService")
	private WtmPsnlWorkTypeMgrService wtmPsnlWorkTypeMgrService;

	@Inject
	@Named("WorkTypeMgrService")
	private WtmWorkTypeMgrService wtmWorkTypeMgrService;

	/**
	 * 개인별 근무유형관리 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewWtmPsnlWorkTypeMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public ModelAndView viewWtmPsnlWorkTypeMgr( @RequestParam Map<String, Object> paramMap) {
		Log.DebugStart();

		ModelAndView mv = new ModelAndView();
		mv.setViewName("wtm/workType/wtmPsnlWorkTypeMgr/wtmPsnlWorkTypeMgr");

		if (paramMap.containsKey("workClassCd")) {
			mv.addObject("selectedWorkClassCd", paramMap.get("workClassCd"));
		} else {
			mv.addObject("selectedWorkClassCd", null); // 또는 기본값 설정
		}
		Log.DebugEnd();

		return mv;
	}

	/**
	 * 근무유형관리 Edit Layer
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewWtmPsnlWorkTypeTargetLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewWtmPsnlWorkTypeTargetLayer() throws Exception {
		return "wtm/workType/wtmPsnlWorkTypeMgr/wtmPsnlWorkTypeTargetLayer";
	}

	/**
	 * 근무유형관리 Edit Layer
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewWtmPsnlWorkTypeEditLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewWtmPsnlWorkTypeEditLayer() throws Exception {
		return "wtm/workType/wtmPsnlWorkTypeMgr/wtmPsnlWorkTypeEditLayer";
	}

	/**
	 * 근무유형관리 대상 추가 Layer
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewWtmPsnlWorkTypeAddTargetLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewWtmPsnlWorkTypeAddTargetLayer() throws Exception {
		return "wtm/workType/wtmPsnlWorkTypeMgr/wtmPsnlWorkTypeAddTargetLayer";
	}

	/**
	 * 근무유형 리스트 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getWtmPsnlWorkTypeMgrWorkClassList", method = RequestMethod.POST )
	public ModelAndView getWtmPsnlWorkTypeMgrWorkClassList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));

		Map map  = null;
		String Message = "";
		try{
			map = wtmPsnlWorkTypeMgrService.getWtmPsnlWorkTypeMgrWorkClassList(paramMap);
		}catch(Exception e){
			Message="조회에 실패 하였습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", map);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 개인별 근무유형 리스트 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getWtmPsnlWorkTypeMgrList", method = RequestMethod.POST )
	public ModelAndView getWtmPsnlWorkTypeMgrList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = wtmPsnlWorkTypeMgrService.getWtmPsnlWorkTypeMgrList(paramMap);
			Log.Debug(list.toString());
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
	 * 개인별 근무유형 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getWtmPsnlWorkTypeMgrDet", method = RequestMethod.POST )
	public ModelAndView getWtmPsnlWorkTypeMgrDet(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));

		Map<?,?> resultMap  = new HashMap<>();
		String Message = "";
		try{
			resultMap = wtmPsnlWorkTypeMgrService.getWtmPsnlWorkTypeMgrDet(paramMap);
			Log.Debug(resultMap.toString());
		}catch(Exception e){
			Message="조회에 실패 하였습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", resultMap);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 근무유형관리 리스트 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getWtmPsnlWorkClassCdList", method = RequestMethod.POST )
	public ModelAndView getWtmPsnlWorkClassCdList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = wtmPsnlWorkTypeMgrService.getWtmPsnlWorkClassCdList(paramMap);

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
	 * 근무조 Group 리스트 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getWtmPsnlWorkGroupCdList", method = RequestMethod.POST )
	public ModelAndView getWtmPsnlWorkGroupCdList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = wtmPsnlWorkTypeMgrService.getWtmPsnlWorkGroupCdList(paramMap);

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
	@RequestMapping(params="cmd=saveWtmPsnlWorkTypeMgr", method = RequestMethod.POST )
	public ModelAndView saveWtmWorkClassMgr(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));

		Map<String, Object> resultMap = new HashMap<>();
		String message = "";
		try{
			resultMap = wtmPsnlWorkTypeMgrService.saveWtmPsnlWorkTypeMgr(paramMap);
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
	 * 근무유형관리 대상 target 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getWtmPsnlWorkTargetList", method = RequestMethod.POST )
	public ModelAndView getWtmPsnlWorkTargetList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = wtmPsnlWorkTypeMgrService.getWtmPsnlWorkTargetList(paramMap);
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
	@RequestMapping(params="cmd=getWtmPsnlWorkTargetOrgList", method = RequestMethod.POST )
	public ModelAndView getWtmPsnlWorkTargetOrgList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = wtmPsnlWorkTypeMgrService.getWtmPsnlWorkTargetOrgList(paramMap);
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
	 * 근무유형 대상자 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveWtmPsnlWorkTarget", method = RequestMethod.POST )
	public ModelAndView saveWtmPsnlWorkTarget(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap,
			@RequestBody Map<String, Object> bodyMap) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.putAll(bodyMap);

		int resultCnt = -1;
		String message = "";

		try {
			Log.Debug(paramMap.toString());
			resultCnt = wtmPsnlWorkTypeMgrService.saveWtmPsnlWorkTarget(paramMap);
			if (resultCnt > 0) {
				message = "저장 되었습니다.";
			} else {
				message = "저장에 실패 하였습니다.";
			}
		} catch(Exception e) {
			e.printStackTrace();
			Log.Error(" ** 근무유형 대상자 추가에 실패하였습니다. >> " + e.getLocalizedMessage());
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
	 * 근무유형관리 삭제
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=deleteWtmPsnlWorkMgr", method = RequestMethod.POST )
	public ModelAndView deleteWtmPsnlWorkMgr(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));

		int resultCnt = -1;
		String message = "";
		try{
				resultCnt = wtmPsnlWorkTypeMgrService.deleteWtmPsnlWorkMgr(paramMap);
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
	 * 근무유형 대상자 삭제
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=deleteWtmPsnlWorkClassTarget", method = RequestMethod.POST )
	public ModelAndView deleteWtmPsnlWorkClassMgr(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));

		int resultCnt = -1;
		String message = "";
		try{
			resultCnt = wtmPsnlWorkTypeMgrService.deleteWtmPsnlWorkClassTarget(paramMap);
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
}
