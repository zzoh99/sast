package com.hr.ben.resort.resortMgr;

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
 * 리조트관리 Controller
 *
 * @author ksj
 *
 */
@Controller
@RequestMapping(value="/ResortMgr.do", method=RequestMethod.POST )
public class ResortMgrController extends ComController {
	/**
	 * 리조트관리 서비스
	 */
	@Inject
	@Named("ResortMgrService")
	private ResortMgrService resortMgrService;

	/**
	 * 리조트관리 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewResortMgr",method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewResortMgr() throws Exception {
		return "ben/resort/resortMgr/resortMgr";
	}
	
	/**
	 * 리조트관리 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getResortMgrList", method = RequestMethod.POST )
	public ModelAndView getResortMgrList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}
	
	
	/**
	 * 리조트관리 저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveResortMgr", method = RequestMethod.POST )
	public ModelAndView saveResortMgr(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return saveData(session, request, paramMap);
	}
}
