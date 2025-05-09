package com.hr.ben.loan.loanMgr;

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
 * 대출이자생성관리 Controller
 *
 * @author JM
 *
 */
@Controller
@RequestMapping(value="/LoanMgr.do", method=RequestMethod.POST )
public class LoanMgrController extends ComController {

	/**
	 * 대출이자생성관리 서비스
	 */
	@Inject
	@Named("LoanMgrService")
	private LoanMgrService loanMgrService;

	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;

	/**
	 * 대출이자생성관리 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewLoanMgr",method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewLoanMgr() throws Exception {
		return "ben/loan/loanMgr/loanMgr";
	}

	/**
	 * 대출이자생성관리 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getLoanMgrList", method = RequestMethod.POST )
	public ModelAndView getLoanMgrList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}

	/**
	 * 대출이자생성관리 저장
	 */
	@RequestMapping(params="cmd=saveLoanMgr", method = RequestMethod.POST )
	public ModelAndView saveLoanMgr(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return saveData(session, request, paramMap);
	}

	/**
	 * 대출금 월 마감관리 자료생성
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=prcLoanMgr", method = RequestMethod.POST )
	public ModelAndView prcLoanMgr(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return execPrc(session, request, paramMap);
	}
	
	/**
	 * 중도상환 팝업 View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewLoanMgrRepPop",method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewLoanRepayMgrRepPopup() throws Exception {
		return "ben/loan/loanMgr/loanMgrRepPop";
	}	

	 /**
     * 중도상환 팝업 View Layer
     * 
     * @return String
     * @throws Exception
     */
    @RequestMapping(params="cmd=viewLoanMgrRepLayer",method = {RequestMethod.POST, RequestMethod.GET} )
    public String viewLoanRepayMgrRepLayer() throws Exception {
        return "ben/loan/loanMgr/loanMgrRepLayer";
    }   

    
	/**
	 * 중도상환 등록
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=prcLoanMgrRepReg", method = RequestMethod.POST )
	public ModelAndView prcLoanMgrRepReg(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return execPrc(session, request, paramMap);
	}

}
