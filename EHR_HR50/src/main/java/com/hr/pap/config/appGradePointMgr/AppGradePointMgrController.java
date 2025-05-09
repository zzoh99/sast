package com.hr.pap.config.appGradePointMgr;

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
 * 평가등급별점수관리 Controller
 * @author gjyoo
 *
 */
@Controller
@RequestMapping(value="/AppGradePointMgr.do", method=RequestMethod.POST )
public class AppGradePointMgrController extends ComController {

	
	/**
	 * 평가등급별점수관리 View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewAppGradePointMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewAppGradePointMgr() throws Exception {
		return "pap/config/appGradePointMgr/appGradePointMgr";
	}

	/**
	 * 평가등급별점수관리 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAppGradePointMgrList", method = RequestMethod.POST )
	public ModelAndView getAppGradePointMgrList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}

	/**
	 * 평가등급별점수관리 저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveAppGradePointMgr", method = RequestMethod.POST )
	public ModelAndView saveAppGradePointMgr(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return saveData(session, request, paramMap);
	}
}
