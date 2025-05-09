package com.hr.pap.config.appRate;

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
 * 평가반영비율관리 Controller
 * @author gjyoo
 *
 */
@Controller
@RequestMapping(value="/AppRate.do", method=RequestMethod.POST )
public class AppRateController extends ComController {
	
	/**
	 * 평가반영비율관리 View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewAppRate", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewAppRate() throws Exception {
		return "pap/config/appRate/appRate";
	}
	
	/**
	 * 평가반영비율관리 > 평가차수 탭 View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewAppRateTab1", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewAppRateTab1() throws Exception {
		return "pap/config/appRate/appRateTab1";
	}

	/**
	 * 평가반영비율관리 > 평가차수 탭 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAppRateTab1", method = RequestMethod.POST )
	public ModelAndView getAppRateTab1(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}

	/**
	 * 평가반영비율관리 > 평가차수 탭 저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveAppRateTab1", method = RequestMethod.POST )
	public ModelAndView saveAppRateTab1(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return saveData(session, request, paramMap);
	}
	
	/**
	 * 평가반영비율관리 > 종합평가 탭 View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewAppRateTab2", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewAppRateTab2() throws Exception {
		return "pap/config/appRate/appRateTab2";
	}

	/**
	 * 평가반영비율관리 > 종합평가 탭 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAppRateTab2", method = RequestMethod.POST )
	public ModelAndView getAppRateTab2(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}
	
	/**
	 * 평가반영비율관리 > 종합평가 탭 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAppRateTab2ScopeCd", method = RequestMethod.POST )
	public ModelAndView getAppRateTab2ScopeCd(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}

	/**
	 * 평가반영비율관리 > 종합평가 탭 저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveAppRateTab2", method = RequestMethod.POST )
	public ModelAndView saveAppRateTab2(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return saveData(session, request, paramMap);
	}

	/**
	 * 평가반영비율관리 > 종합평가 탭 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAppRateTab2TblNm", method = RequestMethod.POST )
	public ModelAndView getAppRateTab2TblNm(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}
}
