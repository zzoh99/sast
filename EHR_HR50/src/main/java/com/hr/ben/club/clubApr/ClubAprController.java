package com.hr.ben.club.clubApr;

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
 * ClubApr Controller
 *
 * @author EW
 *
 */
@Controller
@RequestMapping(value="/ClubApr.do", method=RequestMethod.POST )
public class ClubAprController extends ComController{
	/**
	 * ClubApr 서비스
	 */
	@Inject
	@Named("ClubAprService")
	private ClubAprService clubAprService;

	/**
	 * ClubApr View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewClubApr",method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewClubApr() throws Exception {
		return "ben/club/clubApr/clubApr";
	}

	/**
	 * ClubApr 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getClubAprList", method = RequestMethod.POST )
	public ModelAndView getClubAprList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}


	/**
	 * ClubApr 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveClubApr", method = RequestMethod.POST )
	public ModelAndView saveClubApr(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();
		return saveData(session, request, paramMap);
	}
	
	
	
}
