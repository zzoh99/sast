package com.hr.tim.annual.annualPlanAgrMgr;
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
 * 연차촉진 관리 Controller 
 * 
 * @author 이름
 *
 */
@Controller
@RequestMapping(value="/AnnualPlanAgrMgr.do", method=RequestMethod.POST )
public class AnnualPlanAgrMgrController extends ComController {
	/**
	 * 연차촉진 관리 서비스
	 */
	@Inject
	@Named("AnnualPlanAgrMgrService")
	private AnnualPlanAgrMgrService annualPlanAgrStdService;	
	
	
	/**
	 * 연차촉진 관리 View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewAnnualPlanAgrMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewAnnualPlanAgrStd() throws Exception {
		return "tim/annual/annualPlanAgrMgr/annualPlanAgrMgr";
	}
	
	/**
	 * 연차촉진 관리 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAnnualPlanAgrMgrList", method = RequestMethod.POST )
	public ModelAndView getAnnualPlanAgrMgrList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}
	
	
	/**
	 * 연차촉진 관리 저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveAnnualPlanAgrMgr", method = RequestMethod.POST )
	public ModelAndView saveAnnualPlanAgrMgr(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return saveData(session, request, paramMap);
	}


	/**
	 * 연차촉진 메일발송 프로시저
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=prcAnnualPlanAgrMgrMail", method = RequestMethod.POST )
	public ModelAndView prcAnnualPlanAgrMgrMail(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return execPrc(session, request, paramMap);
	}

	

}
