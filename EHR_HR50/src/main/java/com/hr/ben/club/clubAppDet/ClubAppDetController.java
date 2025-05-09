package com.hr.ben.club.clubAppDet;

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
 * ClubAppDet Controller
 */
@Controller
@RequestMapping({"/ClubAppDet.do", "/ClubApp.do"})
public class ClubAppDetController extends ComController {

	/**
	 * ClubAppDet 서비스
	 */
	@Inject
	@Named("ClubAppDetService")
	private ClubAppDetService clubAppDetService;

	/**
	 * ClubAppDet View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewClubAppDet",method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewClubAppDet() throws Exception {
		return "ben/club/clubAppDet/clubAppDet";
	}
	
	/**
	 * ClubAppDet 단건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getClubAppDetMap", method = RequestMethod.POST )
	public ModelAndView getClubAppDetMap(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataMap(session, request, paramMap);
	}

	/**
	 * ClubAppDet 중복 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getClubAppDetDupChk", method = RequestMethod.POST )
	public ModelAndView getClubAppDetDupChk(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataMap(session, request, paramMap);
	}
	
	/**
	 * ClubAppDet 동호회(콤보선택시) 단건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getClubAppDetClubMap", method = RequestMethod.POST )
	public ModelAndView getClubAppDetClubMap(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataMap(session, request, paramMap);
	}

	/**
	 * ClubAppDet 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveClubAppDet", method = RequestMethod.POST )
	public ModelAndView saveClubAppDet(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return saveData(session, request, paramMap);
	}

	/**
	 * 동호회명 selector 세팅
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getClubAppDetClubName", method = RequestMethod.POST )
	public ModelAndView getClubAppDetClubName(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}
	
}
