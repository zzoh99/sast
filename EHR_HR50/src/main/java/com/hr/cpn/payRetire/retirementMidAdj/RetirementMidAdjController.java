package com.hr.cpn.payRetire.retirementMidAdj;

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
 * 중간정산일자관리 Controller
 * @author gjyoo
 *
 */
@Controller
@RequestMapping(value="/RetirementMidAdj.do", method=RequestMethod.POST )
public class RetirementMidAdjController extends ComController {
	
	/**
	 * 중간정산일자관리 View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewRetirementMidAdj", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewRetirementMidAdj() throws Exception {
		return "cpn/payRetire/retirementMidAdj/retirementMidAdj";
	}

	/**
	 * 중간정산일자관리 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getRetirementMidAdjList", method = RequestMethod.POST )
	public ModelAndView getRetirementMidAdjList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}

	/**
	 * 중간정산일자관리 저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveRetirementMidAdj", method = RequestMethod.POST )
	public ModelAndView saveRetirementMidAdj(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return saveData(session, request, paramMap);
	}
}
