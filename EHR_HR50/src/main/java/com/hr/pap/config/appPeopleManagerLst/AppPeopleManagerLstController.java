package com.hr.pap.config.appPeopleManagerLst;

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
 * 나의피평가자 Controller
 * @author gjyoo
 *
 */
@Controller
@RequestMapping(value="/AppPeopleManagerLst.do", method=RequestMethod.POST )
public class AppPeopleManagerLstController extends ComController {
	
	/**
	 * 나의피평가자 View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewAppPeopleManagerLst", method = {RequestMethod.POST, RequestMethod.GET} )
	public String view() throws Exception {
		return "pap/config/appPeopleManagerLst/appPeopleManagerLst";
	}

	/**
	 * 나의피평가자 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAppPeopleManagerLstList", method = RequestMethod.POST )
	public ModelAndView getAppPeopleManagerLstList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}
}
