package com.hr.sys.other.logMgr;

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
import com.hr.common.util.ParamUtils;
import com.hr.common.logger.Log;

/**
 * 로그관리
 * 
 * @author ParkMoohun
 */
@Controller
@RequestMapping(value="/LogMgr.do", method=RequestMethod.POST )
public class LogMgrController {

	@Inject
	@Named("LogMgrService")
	private LogMgrService logMgrService;

	/**
	 * 로그관리 화면
	 * 
	 * @param paramMap
	 * @param request
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewLogMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewLogMgr(
			@RequestParam Map<String, Object> paramMap,
			HttpServletRequest request) throws Exception {
		Log.Debug("LogMgrController.viewLogMgr");
		return "sys/other/logMgr/logMgr";
	}

	/**
	 * 로그관리 리스트 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getLogMgrList", method = RequestMethod.POST )
	public ModelAndView getLogMgrList(HttpSession session,
			HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		paramMap.put("enterCd", session.getAttribute("ssnEnterCd"));
		List<?> result = logMgrService.getPwrSrchCdElemtMgrList(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", result);
		Log.DebugEnd();
		return mv;
	}
}
