package com.hr.tim.workApp.extenWorkApr;
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
 * 연장근무추가승인 Controller
 *
 * @author EW
 *
 */
@Controller
@RequestMapping(value="/ExtenWorkApr.do", method=RequestMethod.POST )
public class ExtenWorkAprController extends ComController {
	/**
	 * 연장근무추가승인 서비스
	 */
	@Inject
	@Named("ExtenWorkAprService")
	private ExtenWorkAprService extenWorkAprService;

	/**연장근무추가승인
	 * extenWorkApr View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewExtenWorkApr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewExtenWorkApr() throws Exception {
		return "tim/workApp/extenWorkApr/extenWorkApr";
	}


	/**
	 * 연장근무추가승인 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getExtenWorkAprList", method = RequestMethod.POST )
	public ModelAndView getExtenWorkAprList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}

}
