package com.hr.pap.progress.appResultMgr;
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
/**
 * 평가결과종합관리 Controller
 *
 * @author JCY
 *
 */
@Controller
@RequestMapping(value="/AppResultMgr.do", method=RequestMethod.POST )
public class AppResultMgrController extends ComController {
	/**
	 * 평가결과종합관리 서비스
	 */
	@Inject
	@Named("AppResultMgrService")
	private AppResultMgrService appResultMgrService;

	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;

	/**
	 * 평가결과관리 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewAppResultMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewAppResultMgr() throws Exception {
		return "pap/progress/appResultMgr/appResultMgr";
	}
	
	/**
	 * 직책자평가관리 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewAppDirectorResultMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewAppDirectorResultMgr() throws Exception {
		return "pap/progress/appResultMgr/appDirectorResult";
	}

	/**
	 * 평가결과종합관리 그룹결과 팝업 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewAppResultMgrGrpPopup", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewAppResultMgrGrpPopup() throws Exception {
		return "pap/progress/appResultMgr/appResultMgrGrpPopup";
	}

	/**
	 * 평가결과종합관리 그룹결과 팝업 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAppResultMgrGrpPopupList", method = RequestMethod.POST )
	public ModelAndView getAppResultMgrGrpPopupList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}

	/**
	 * 평가결과종합관리 단건 조회(평가ID정보 조회)
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAppResultMgrMap", method = RequestMethod.POST )
	public ModelAndView getAppResultMgrMap(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

		Map<?, ?> map = appResultMgrService.getAppResultMgrMap(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("map", map);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 평가결과관리 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAppResultMgrList", method = RequestMethod.POST )
	public ModelAndView getAppResultMgrList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}

	/**
	 * 평가결과관리 저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveAppResultMgr", method = RequestMethod.POST )
	public ModelAndView saveAppResultMgr(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return saveData(session, request, paramMap);
	}

	/**
	 * 평가결과관리 > 점수상세 Popup View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewAppResultMgrDetailPopup", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewAppResultMgrDetailPopup() throws Exception {
		return "pap/progress/appResultMgr/appResultMgrDetailPopup";
	}

	/**
	 * 평가결과관리 > 점수상세 Popup 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAppResultMgrDetailPopupList", method = RequestMethod.POST )
	public ModelAndView getAppResultMgrDetailPopupList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}

	/**
	 * 평가결과관리 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewAppDirectorResult", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewAppDirectorResult() throws Exception {
		return "pap/progress/appResultMgr/appDirectorResult";
	}

	/**
	 * 직책자평가내역 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAppDirectorResultMgrList", method = RequestMethod.POST )
	public ModelAndView getAppDirectorResultMgrList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}

	@RequestMapping(params="cmd=getEvalRankingList", method = RequestMethod.POST )
	public ModelAndView getEvalRankingList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}
}
