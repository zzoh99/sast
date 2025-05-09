package com.hr.pap.config.appPromPointMgr;

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
 * 직위별포인트 Controller
 * @author 
 *
 */
@Controller
@RequestMapping(value="/AppPromPointMgr.do", method=RequestMethod.POST )
public class AppPromPointMgrController extends ComController {

	
	/**
	 * 직위별포인트 View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewAppPromPointMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewAppPromPointMgr() throws Exception {
		return "pap/config/appPromPointMgr/appPromPointMgr";
	}

	/**
	 * 직위별포인트 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAppPromPointMgrList", method = RequestMethod.POST )
	public ModelAndView getAppGradePointMgrList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}

	/**
	 * 직위별포인트 저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveAppPromPointMgr", method = RequestMethod.POST )
	public ModelAndView saveAppPromPointMgr(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return saveData(session, request, paramMap);
	}
}
