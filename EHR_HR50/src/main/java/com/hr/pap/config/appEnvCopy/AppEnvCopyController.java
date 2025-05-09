package com.hr.pap.config.appEnvCopy;

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
 * 평가환경복사 Controller
 * @author gjyoo
 *
 */
@Controller
@RequestMapping(value="/AppEnvCopy.do", method=RequestMethod.POST )
public class AppEnvCopyController extends ComController {
	
	/**
	 * 평가환경복사 View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewAppEnvCopy", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewAppEnvCopy() throws Exception {
		return "pap/config/appEnvCopy/appEnvCopy";
	}

	/**
	 * 평가환경 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAppEnvCopyList", method = RequestMethod.POST )
	public ModelAndView getAppEnvCopyList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}

	/**
	 * 평가환경 단건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAppEnvCopyMap", method = RequestMethod.POST )
	public ModelAndView getAppEnvCopyMap(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataMap(session, request, paramMap);
	}

	/**
	 * 평가환경복사 - 프로시저 호출
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=prcAppEnvCopy", method = RequestMethod.POST )
	public ModelAndView prcAppEnvCopy(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();  
		return execPrc(session, request, paramMap);
	}
}
