package com.hr.sys.other.psnalSchedualMgr;
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

/**
 * 개인별알림관리 Controller 
 * 
 * @author 이름
 *
 */
@Controller
@RequestMapping(value="/PsnalSchedualMgr.do", method=RequestMethod.POST )
public class PsnalSchedualMgrController extends ComController {
	/**
	 * 개인별알림관리 서비스
	 */
	@Inject
	@Named("PsnalSchedualMgrService")
	private PsnalSchedualMgrService psnalSchedualMgrService;	
	
	
	
	/**
	 * 개인별알림관리 View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewPsnalSchedualMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewPsnalSchedualMgr() throws Exception {
		return "sys/other/psnalSchedualMgr/psnalSchedualMgr";
	}
	
	/**
	 * 개인별알림관리 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPsnalSchedualMgrList", method = RequestMethod.POST )
	public ModelAndView getPsnalSchedualMgrList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}
	
	
	/**
	 * 개인별알림관리 저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=savePsnalSchedualMgr", method = RequestMethod.POST )
	public ModelAndView savePsnalSchedualMgr(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();  
		
		return saveData(session, request, paramMap);
	}

}
