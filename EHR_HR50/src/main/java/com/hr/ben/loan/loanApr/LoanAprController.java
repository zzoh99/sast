package com.hr.ben.loan.loanApr;

import com.hr.common.code.CommonCodeService;
import com.hr.common.com.ComController;
import com.hr.common.logger.Log;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.Map;

/**
 * 대출승인관리 Controller
 *
 * @author bckim
 *
 */

@Controller
@RequestMapping(value="/LoanApr.do", method=RequestMethod.POST )
public class LoanAprController extends ComController {

	@Inject
	@Named("LoanAprService")
	private LoanAprService loanAprService;

	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;

	/**
	 * 대출승인관리 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewLoanApr",method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewLoanApr() throws Exception {
		return "ben/loan/loanApr/loanApr";
	}

	/**
	 * 대출 상세 조회 Popup View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewLoanAprDet",method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewLoanAprDet() throws Exception {
		return "ben/loan/loanApr/loanAprDet";
	}

	/**
	 * 대출승인관리 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getLoanAprList", method = RequestMethod.POST )
	public ModelAndView getLoanAprList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}

	/**
	 * 대출승인관리 저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveLoanApr", method = RequestMethod.POST )
	public ModelAndView saveLoanApr(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return saveData(session, request, paramMap);
	}


}
