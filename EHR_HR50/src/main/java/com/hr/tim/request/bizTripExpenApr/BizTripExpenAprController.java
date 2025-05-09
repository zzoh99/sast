package com.hr.tim.request.bizTripExpenApr;
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
 * 출장 승인 Controller
 *
 * @author EW
 *
 */
@Controller
@RequestMapping(value="/BizTripExpenApr.do", method=RequestMethod.POST )
public class BizTripExpenAprController  extends ComController {
	/**
	 * 출장 승인 서비스
	 */
	@Inject
	@Named("BizTripExpenAprService")
	private BizTripExpenAprService bizTripExpenAprService;

	/**
	 * 출장 승인 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewBizTripExpenApr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewHolWorkApr() throws Exception {
		return "tim/request/bizTripExpenApr/bizTripExpenApr";
	}
	
	/**
	 * 출장 승인 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getBizTripExpenAprList", method = RequestMethod.POST )
	public ModelAndView getBizTripExpenAprList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}
	

}
