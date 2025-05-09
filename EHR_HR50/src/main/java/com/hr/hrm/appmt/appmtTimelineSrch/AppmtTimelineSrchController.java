package com.hr.hrm.appmt.appmtTimelineSrch;

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
 * 발령 Timeline 조회
 * @author gjyoo
 *
 */
@Controller
@RequestMapping(value="/AppmtTimelineSrch.do", method=RequestMethod.POST ) 
public class AppmtTimelineSrchController extends ComController {

	
	/**
	 * 발령 Timeline 조회 View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewAppmtTimelineSrch", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewAppmtTimelineSrch() throws Exception {
		return "hrm/appmt/appmtTimelineSrch/appmtTimelineSrch";
	}

	/**
	 * 발령 Timeline 조회 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAppmtTimelineSrchList", method = RequestMethod.POST )
	public ModelAndView getAppmtTimelineSrchList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}

	/**
	 * 조직관리 timeline 조회
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAppmtTimelineList", method = RequestMethod.POST )
	public ModelAndView getAppmtTimelineList(HttpSession session,  HttpServletRequest request,
											 @RequestParam Map<String, Object> paramMap) throws Exception{
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}

	/**
	 * 발령 Timeline 조회 상세내역 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAppmtTimelineSrchDetailList", method = RequestMethod.POST )
	public ModelAndView getAppmtTimelineSrchDetailList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}

	/**
	 * 조직관리 timeline 상세조회
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAppmtTimelineDetailList", method = RequestMethod.POST )
	public ModelAndView getAppmtTimelineDetailList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}

	/**
	 * 조직관리 전사 인원 현황
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAppmtTimelineOrd", method = RequestMethod.POST )
	public ModelAndView getAppmtTimelineOrd(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}

}
