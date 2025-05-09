package com.hr.pap.config.appGradeOrgRateMgr;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.hr.common.com.ComController;
import com.hr.common.logger.Log;

/**
 * 배분기준표 Controller
 * @author gjyoo
 *
 */
@Controller
@RequestMapping({"/AppGradeOrgRateMgr.do","/AppGradeSeqCd2.do", "/AppGradeSeqCd6.do","/AppGradeFinal.do"})
public class AppGradeOrgRateMgrController extends ComController {
	
	/**
	 * 배분기준표 View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewAppGradeOrgRateMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewAppGradeOrgRateMgr() throws Exception {
		return "pap/config/appGradeOrgRateMgr/appGradeOrgRateMgr";
	}

	/**
	 * 배분기준표 기준배분비율 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAppGradeOrgRateMgrList1", method = RequestMethod.POST )
	public ModelAndView getAppGradeOrgRateMgrList1(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}

	/**
	 * 배분기준표 기준배분비율 저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveAppGradeOrgRateMgr1", method = RequestMethod.POST )
	public ModelAndView saveAppGradeOrgRateMgr1(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return saveData(session, request, paramMap);
	}

	/**
	 * 배분기준표 인원배분기준표 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAppGradeOrgRateMgrList2", method = RequestMethod.POST )
	public ModelAndView getAppGradeOrgRateMgrList2(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}

	/**
	 * 배분기준표 인원배분기준표 저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveAppGradeOrgRateMgr2", method = RequestMethod.POST )
	public ModelAndView saveAppGradeOrgRateMgr2(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return saveData(session, request, paramMap);
	}

	/**
	 * 평가그룹별 인원배분계획 생성 - 프로시저 호출
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=prcAppGradeOrgRateMgr", method = RequestMethod.POST )
	public ModelAndView prcAppGradeOrgRateMgr(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();  
		return execPrc(session, request, paramMap);
	}
	
	/**
	 * 배분기준표 > 평가그룹인원 팝업 View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewAppGradeOrgRateMgrPop", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewAppGradeOrgRateMgrPop() throws Exception {
		return "pap/config/appGradeOrgRateMgr/appGradeOrgRateMgrPop";
	}

	/**
	 *  다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAppGradeOrgRateMgrPopList1", method = RequestMethod.POST )
	public ModelAndView getAppGradeOrgRateMgrPopList1(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}
}
