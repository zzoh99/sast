package com.hr.pap.config.appClassMgr;

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
 * 차수별 평가등급관리 Controller
 * @author gjyoo
 *
 */
@Controller
@RequestMapping(value="/AppClassMgr.do", method=RequestMethod.POST )
public class AppClassMgrController extends ComController {

	/**
	 * 차수별 평가등급관리 View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewAppClassMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewAppClassMgr() throws Exception {
		return "pap/config/appClassMgr/appClassMgr";
	}

	/**
	 * 차수별 평가등급관리 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAppClassMgrList", method = RequestMethod.POST )
	public ModelAndView getAppClassMgrList(HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}

	/**
	 * 차수별 평가등급관리 저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveAppClassMgr", method = RequestMethod.POST )
	public ModelAndView saveAppClassMgr(HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		return saveData(session, request, paramMap);
	}
}
