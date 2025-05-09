package com.hr.tim.workApp.otWorkOrgApr;
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

/**
 * 연장근무사전승인 Controller
 *
 * @author 이름
 *
 */
@Controller
@RequestMapping(value="/OtWorkOrgApr.do", method=RequestMethod.POST )
public class OtWorkOrgAprController extends ComController {
	/**
	 * 연장근무사전승인 서비스
	 */
	@Inject
	@Named("OtWorkOrgAprService")
	private OtWorkOrgAprService otWorkOrgAprService;


	/**
	 * 연장근무사전승인 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewOtWorkOrgApr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewOtWorkOrgApr() throws Exception {
		return "tim/workApp/otWorkOrgApr/otWorkOrgApr";
	}
	

	/**
	 * 연장근무사전승인 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getOtWorkOrgAprList", method = RequestMethod.POST )
	public ModelAndView getOtWorkOrgAprList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}
	

}
