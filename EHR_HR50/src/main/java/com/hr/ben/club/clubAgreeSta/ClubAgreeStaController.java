package com.hr.ben.club.clubAgreeSta;

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
 * ClubAgreeSta Controller
 *
 * @author EW
 *
 */
@Controller
@RequestMapping(value="/ClubAgreeSta.do", method=RequestMethod.POST )
public class ClubAgreeStaController extends ComController{
	/**
	 * ClubAgreeSta 서비스
	 */
	@Inject
	@Named("ClubAgreeStaService")
	private ClubAgreeStaService clubAgreeStaService;

	/**
	 * ClubAgreeSta View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewClubAgreeSta",method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewClubAgreeSta() throws Exception {
		return "ben/club/clubAgreeSta/clubAgreeSta";
	}

	/**
	 * ClubAgreeSta 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getClubAgreeStaList", method = RequestMethod.POST )
	public ModelAndView getClubAgreeStaList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}


	/**
	 * ClubAgreeSta 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveClubAgreeSta", method = RequestMethod.POST )
	public ModelAndView saveClubAgreeSta(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();
		return saveData(session, request, paramMap);
	}
	
	
	
}
