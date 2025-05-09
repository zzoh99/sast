package com.hr.pap.config.appPeopleLst;

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
 * 나의 평가자 Controller
 * @author gjyoo
 *
 */
@Controller
@RequestMapping(value="/AppPeopleLst.do", method=RequestMethod.POST )
public class AppPeopleLstController extends ComController {

	/**
	 * 나의 평가자 View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewAppPeopleLst", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewAppPeopleLst() throws Exception {
		return "pap/config/appPeopleLst/appPeopleLst";
	}

	/**
	 * 나의 평가자 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAppPeopleLstList", method = RequestMethod.POST )
	public ModelAndView getAppPeopleLstList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}
}
