package com.hr.pap.appResultGradeMgr;

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
 * 최종평가결과업로드 Controller
 * @author gjyoo
 *
 */
@Controller
@RequestMapping(value="/AppResultGradeMgr.do", method=RequestMethod.POST )
public class AppResultGradeMgrController extends ComController {

	/**
	 * 최종평가결과업로드 View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewAppResultGradeMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewAppResultGradeMgr() throws Exception {
		return "pap/appResultGradeMgr/appResultGradeMgr";
	}

	/**
	 * 최종평가결과업로드 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAppResultGradeMgrList", method = RequestMethod.POST )
	public ModelAndView getAppResultGradeMgrList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}

	/**
	 * 최종평가결과업로드 저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveAppResultGradeMgr", method = RequestMethod.POST )
	public ModelAndView saveAppResultGradeMgr(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return saveData(session, request, paramMap);
	}
}
