package com.hr.pap.evaluation.appCoachingApr;
import java.util.HashMap;
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
 * Coaching관리 Controller 
 * 
 * @author JCY
 *
 */
@Controller
@RequestMapping({"/EvaMain.do", "/AppCoachingApr.do"})
public class AppCoachingAprController extends ComController {
	/**
	 * Coaching관리 서비스
	 */
	@Inject
	@Named("AppCoachingAprService")
	private AppCoachingAprService appCoachingAprService;
	
	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;
	
	/**
	 * Coaching관리View(화면 로드)
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewAppCoachingApr", method = {RequestMethod.POST, RequestMethod.GET} )
	public ModelAndView viewAppCoachingApr(
		HttpSession session,  HttpServletRequest request, 
		@RequestParam Map<String, Object> paramMap ) throws Exception {
		
		ModelAndView mv = new ModelAndView();
		mv.setViewName("pap/evaluation/appCoachingApr/appCoachingApr");
		mv.addObject("map", paramMap);
		
		return mv;
	}

	/**
	 * Coaching관리View(팝업 로드)
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewAppCoachingAprPop", method = {RequestMethod.POST, RequestMethod.GET} )
	public ModelAndView viewAppCoachingAprPop(
		HttpSession session,  HttpServletRequest request, 
		@RequestParam Map<String, Object> paramMap ) throws Exception {
		
		ModelAndView mv = new ModelAndView();
		mv.setViewName("pap/evaluation/appCoachingApr/appCoachingAprPop");
		mv.addObject("map", paramMap);
		
		return mv;
	}
	
	/**
	 * 신청 팝업 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveCoachingAprPop", method = RequestMethod.POST )
	public ModelAndView saveCoachingAprPop(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();

		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

		String message = "";
		int resultCnt = -1;
		try{
			resultCnt =appCoachingAprService.saveCoachingAprPop(paramMap);
			if(resultCnt > 0){ message="저장되었습니다."; } else{ message="저장된 내용이 없습니다."; }
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
	 * 중복체크
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getCoachingAprDupChk", method = RequestMethod.POST )
	public ModelAndView getCoachingAprDupChk(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		Map<?, ?> map = appCoachingAprService.getCoachingAprDupChk(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("map", map);
		Log.DebugEnd();
		return mv;
	}
	
	/**
	 * Coaching 내역 상세 View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewCoachingInsertPop", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewCoachingInsertPop() throws Exception {
		return "pap/evaluation/appCoachingApr/coachingInsertPop";
	}

	/**
	 * 세부내역 단건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAppCoachingAprMap", method = RequestMethod.POST )
	public ModelAndView getAppCoachingAprMap(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataMap(session, request, paramMap);
	}

	/**
	 * 피평가자 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAppCoachingAprList1", method = RequestMethod.POST )
	public ModelAndView getAppCoachingAprList1(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}

	/**
	 * Coaching 내역 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAppCoachingAprList2", method = RequestMethod.POST )
	public ModelAndView getAppCoachingAprList2(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}

	/**
	 * Coaching 내역 저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveAppCoachingApr", method = RequestMethod.POST )
	public ModelAndView saveAppCoachingApr(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return saveData(session, request, paramMap);
	}
}
