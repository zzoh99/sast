package com.hr.ben.club.clubpayApr;

import com.hr.common.com.ComController;
import com.hr.common.logger.Log;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.Map;

/**
 * ClubpayApr Controller
 *
 * @author EW
 *
 */
@Controller
@RequestMapping(value="/ClubpayApr.do", method=RequestMethod.POST )
public class ClubpayAprController extends ComController{
	/**
	 * ClubpayApr 서비스
	 */
	@Inject
	@Named("ClubpayAprService")
	private ClubpayAprService clubpayAprService;

	/**
	 * ClubpayApr View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewClubpayApr",method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewClubpayApr() throws Exception {
		return "ben/club/clubpayApr/clubpayApr";
	}

	/**
	 * ClubpayApr 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getClubpayAprList", method = RequestMethod.POST )
	public ModelAndView getClubpayAprList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}

	
}
