package com.hr.ben.loan.loanRepApr;

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
@RequestMapping(value="/LoanRepApr.do", method=RequestMethod.POST )
public class LoanRepAprController extends ComController {

	@Inject
	@Named("LoanRepAprService")
	private LoanRepAprService loanRepAprService;

	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;

	/**
	 * 대출승인관리 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewLoanRepApr",method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewLoanRepApr() throws Exception {
		return "ben/loan/loanRepApr/loanRepApr";
	}

	/**
	 * 대출 상세 조회 Popup View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewLoanRepAprDet",method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewLoanRepAprDet() throws Exception {
		return "ben/loan/loanRepApr/loanRepAprDet";
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
	@RequestMapping(params="cmd=getLoanRepAprList", method = RequestMethod.POST )
	public ModelAndView getLoanRepAprList(
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
	@RequestMapping(params="cmd=saveLoanRepApr", method = RequestMethod.POST )
	public ModelAndView saveLoanRepApr(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return saveData(session, request, paramMap);
	}


}
