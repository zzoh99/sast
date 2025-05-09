package com.hr.sys.system.creQueryMgr;

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
import com.hr.common.com.ComService;
import com.hr.common.logger.Log;

/**
 * 로그관리
 * 
 * @author ParkMoohun
 */
@Controller
@RequestMapping(value="/CreQueryMgr.do", method=RequestMethod.POST )
public class CreQueryMgrController {
	/**
	 * 공통 서비스
	 */
	@Inject
	@Named("ComService")
	private ComService comService;

	@Inject
	@Named("CreQueryMgrService")
	private CreQueryMgrService creQueryMgrService;

	/**
	 * 쿼리생성 화면
	 * 
	 * @param paramMap
	 * @param request
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewCreQueryMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewCreQueryMgr(
			@RequestParam Map<String, Object> paramMap,
			HttpServletRequest request) throws Exception {
		Log.Debug("CreQueryMgr.viewCreQueryMgr");
		return "sys/system/creQueryMgr/creQueryMgr";
	}

	/**
	 * 리스트 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getCreQueryMgrList", method = RequestMethod.POST )
	public ModelAndView getCreQueryMgrList(HttpSession session,
			HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		List<?> result = comService.getDataList(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", result);
		Log.DebugEnd();
		return mv;
	}
}
