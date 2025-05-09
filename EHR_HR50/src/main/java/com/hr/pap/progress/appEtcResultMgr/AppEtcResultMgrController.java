package com.hr.pap.progress.appEtcResultMgr;

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
 * 기타평가점수결과반영 Controller
 * @author gjyoo
 *
 */
@Controller
@RequestMapping(value="/AppEtcResultMgr.do", method=RequestMethod.POST )
public class AppEtcResultMgrController extends ComController {
	
	/**
	 * 기타평가점수결과반영 View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewAppEtcResultMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewAppEtcResultMgr() throws Exception {
		return "pap/progress/appEtcResultMgr/appEtcResultMgr";
	}

	/**
	 * 기타평가점수결과반영 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAppEtcResultList", method = RequestMethod.POST )
	public ModelAndView getEtcResultList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}

	/**
	 * 기타평가점수결과반영 저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveAppEtcResultMgr", method = RequestMethod.POST )
	public ModelAndView saveEtcResultMgr(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return saveData(session, request, paramMap);
	}
}
