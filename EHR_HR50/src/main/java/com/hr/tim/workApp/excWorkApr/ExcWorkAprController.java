package com.hr.tim.workApp.excWorkApr;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
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

import com.hr.common.com.ComController;
import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;

/**
 * 당직승인 Controller
 *
 * @author EW
 *
 */
@Controller
@RequestMapping(value="/ExcWorkApr.do", method=RequestMethod.POST )
public class ExcWorkAprController extends ComController {
	/**
	 * 당직승인 서비스
	 */
	@Inject
	@Named("ExcWorkAprService")
	private ExcWorkAprService excWorkAprService;

	/**
	 * 당직승인 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewExcWorkApr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewExcWorkApr() throws Exception {
		return "tim/workApp/excWorkApr/excWorkApr";
	}
	/**
	 * 당직승인 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getExcWorkAprList", method = RequestMethod.POST )
	public ModelAndView getExcWorkAprList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}


}
