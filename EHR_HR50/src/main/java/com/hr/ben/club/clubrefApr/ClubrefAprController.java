package com.hr.ben.club.clubrefApr;

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
 * ClubrefApr Controller
 *
 * @author EW
 *
 */
@Controller
@RequestMapping(value="/ClubrefApr.do", method=RequestMethod.POST )
public class ClubrefAprController extends ComController{
	/**
	 * ClubrefApr 서비스
	 */
	@Inject
	@Named("ClubrefAprService")
	private ClubrefAprService clubrefAprService;

	/**
	 * ClubrefApr View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewClubrefApr",method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewClubrefApr() throws Exception {
		return "ben/club/clubrefApr/clubrefApr";
	}

	/**
	 * ClubrefApr 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getClubrefAprList", method = RequestMethod.POST )
	public ModelAndView getClubrefAprList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}

	
}
