package com.hr.ben.loan.loanRepAppDet;

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
 * 대출금 세부내역 Controller
 *
 * @author bckim
 *
 */
@Controller
@RequestMapping({"/LoanRepAppDet.do", "/LoanRepApp.do"})
public class LoanRepAppDetController extends ComController {

	/**
	 * 대출금 세부내역 서비스
	 */
	@Inject
	@Named("LoanRepAppDetService")
	private LoanRepAppDetService loanRepAppDetService;

	/**
	 * 대출금 세부내역 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewLoanRepAppDet",method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewLoanRepAppDet() throws Exception {
		return "ben/loan/loanRepAppDet/loanRepAppDet";
	}

	/**
	 * 대출정보 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getLoanRepAppDetLoanInfo", method = RequestMethod.POST )
	public ModelAndView getLoanRepAppDetUseInfo(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}

	/**
	 * 이자 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getLoanRepAppDetIntMon", method = RequestMethod.POST )
	public ModelAndView getLoanRepAppDetMon(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataMap(session, request, paramMap);
	}
	
	/**
	 * 대출금 세부내역 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getLoanRepAppDetMap", method = RequestMethod.POST )
	public ModelAndView getLoanRepAppDetMap(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataMap(session, request, paramMap);
	}

	/**
	 * 대출상환신청 중복 체크 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getLoanRepAppDetDupChk", method = RequestMethod.POST )
	public ModelAndView getLoanRepAppDetDupChk(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataMap(session, request, paramMap);
	}

	/**
	 * 대출 담당자 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveLoanRepAppDetAdmin", method = RequestMethod.POST )
	public ModelAndView saveLoanRepAppDetAdmin(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return saveData(session, request, paramMap);
	}

	/**
	 * 대출금 세부내역 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveLoanRepAppDet", method = RequestMethod.POST )
	public ModelAndView saveLoanRepAppDet(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return saveData(session, request, paramMap);
	}

}
