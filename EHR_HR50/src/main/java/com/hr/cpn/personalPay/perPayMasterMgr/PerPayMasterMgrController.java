package com.hr.cpn.personalPay.perPayMasterMgr;
import java.util.*;
import java.util.stream.Collectors;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import com.hr.cpn.personalPay.perPayYearMgr.PerPayYearMgrService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.hr.common.code.CommonCodeService;
import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;
import com.nhncorp.lucy.security.xss.XssPreventer;

/**
 * 급여기본사항 Controller
 *
 * @author JM
 *
 */
@Controller
@RequestMapping(value="/PerPayMasterMgr.do", method=RequestMethod.POST )
public class PerPayMasterMgrController {

	/**
	 * 급여기본사항 서비스
	 */
	@Inject
	@Named("PerPayMasterMgrService")
	private PerPayMasterMgrService perPayMasterMgrService;

	@Inject
	@Named("PerPayYearMgrService")
	private PerPayYearMgrService perPayYearMgrService;

	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;

	/**
	 * 급여기본사항 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewPerPayMasterMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewPerPayMasterMgr() throws Exception {
		return "cpn/personalPay/perPayMasterMgr/perPayMasterMgr";
	}

	/**
	 * 급여기본사항 기본사항TAB View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewPerPayMasterMgrBasic", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewPerPayMasterMgrBasic() throws Exception {
		return "cpn/personalPay/perPayMasterMgr/perPayMasterMgrBasic";
	}

	/**
	 * 급여기본사항 지급/공제 예외사항TAB View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewPerPayMasterMgrException", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewPerPayMasterMgrException() throws Exception {
		return "cpn/personalPay/perPayMasterMgr/perPayMasterMgrException";
	}

	/**
	 * 급여기본사항 연봉이력TAB View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewPerPayMasterMgrAnnualIncome", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewPerPayMasterMgrAnnualIncome() throws Exception {
		return "cpn/personalPay/perPayMasterMgr/perPayMasterMgrAnnualIncome";
	}

	/**
	 * 급여기본사항 퇴직금중간정산TAB View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewPerPayMasterMgrSeverancePay", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewPerPayMasterMgrSeverancePay() throws Exception {
		return "cpn/personalPay/perPayMasterMgr/perPayMasterMgrSeverancePay";
	}

	/**
	 * 급여기본사항 급여압류TAB View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewPerPayMasterMgrPayAttach", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewPerPayMasterMgrPayAttach() throws Exception {
		return "cpn/personalPay/perPayMasterMgr/perPayMasterMgrPayAttach";
	}

	/**
	 * 급여기본사항 사회보험TAB View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewPerPayMasterMgrSocialInsurance", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewPerPayMasterMgrSocialInsurance() throws Exception {
		return "cpn/personalPay/perPayMasterMgr/perPayMasterMgrSocialInsurance";
	}
	
	/**
	 * 급여기본사항 임금피크 TAB View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewPerPayMasterMgrSalaryPeak", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewPerPayMasterMgrSalaryPeak() throws Exception {
		return "cpn/personalPay/perPayMasterMgr/perPayMasterMgrSalaryPeak";
	}

	/**
	 * 급여기본사항 대출현황TAB View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewPerPayMasterMgrLoanInfo", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewPerPayMasterMgrLoanInfo() throws Exception {
		return "cpn/personalPay/perPayMasterMgr/perPayMasterMgrLoanInfo";
	}

	/**
	 * 급여기본사항 기본사항TAB 연봉정보 단건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPerPayMasterMgrAnnualIncomeMap", method = RequestMethod.POST )
	public ModelAndView getPerPayMasterMgrAnnualIncomeMap(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));
//		paramMap.put("columnInfo", XssPreventer.unescape(paramMap.get("columnInfo").toString()));
		
		String Message = "";
		Map<?, ?> map = null;

		try{
			List<Map> columnInfo = (List<Map>) perPayYearMgrService.getPerPayYearMgrTitleList(paramMap);
			List<String> elementCd = Arrays.asList(columnInfo.get(0).get("elementCd").toString().split("\\|"));
			List<String> elementAlias = elementCd.stream()
					.map(element -> "ELE_" + element)
					.collect(Collectors.toList());

			paramMap.put("elementCd", elementCd);
			paramMap.put("elementAlias", elementAlias);

			map = perPayMasterMgrService.getPerPayMasterMgrAnnualIncomeMap(paramMap);
		}catch(Exception e){
			Message="조회에 실패하였습니다.";
		}

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Map",map);
		mv.addObject("Message", Message);

		Log.DebugEnd();
		return mv;
	}

	/**
	 * 급여기본사항 기본사항TAB 과세정보 단건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPerPayMasterMgrTaxInfoMap", method = RequestMethod.POST )
	public ModelAndView getPerPayMasterMgrTaxInfoMap(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		String Message = "";
		Map<?, ?> map = null;

		try{
			map = perPayMasterMgrService.getPerPayMasterMgrTaxInfoMap(paramMap);
		}catch(Exception e){
			Message="조회에 실패하였습니다.";
		}

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Map",map);
		mv.addObject("Message", Message);

		Log.DebugEnd();
		return mv;
	}

	/**
	 * 급여기본사항 기본사항TAB 수당기준 단건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPerPayMasterMgrAllowYnInfoMap", method = RequestMethod.POST )
	public ModelAndView getPerPayMasterMgrAllowYnInfoMap(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		String Message = "";
		Map<?, ?> map = null;

		try{
			map = perPayMasterMgrService.getPerPayMasterMgrAllowYnInfoMap(paramMap);
		}catch(Exception e){
			Message="조회에 실패하였습니다.";
		}

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Map",map);
		mv.addObject("Message", Message);

		Log.DebugEnd();
		return mv;
	}

	/**
	 * 급여기본사항 기본사항TAB 임금피크 단건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPerPayMasterMgrPeekInfoMap", method = RequestMethod.POST )
	public ModelAndView getPerPayMasterMgrPeekInfoMap(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		String Message = "";
		Map<?, ?> map = null;

		try{
			map = perPayMasterMgrService.getPerPayMasterMgrPeekInfoMap(paramMap);
		}catch(Exception e){
			Message="조회에 실패하였습니다.";
		}

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Map",map);
		mv.addObject("Message", Message);

		Log.DebugEnd();
		return mv;
	}

	/**
	 * 급여기본사항 기본사항TAB 고정수당 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPerPayMasterMgrfixAllowanceList", method = RequestMethod.POST )
	public ModelAndView getPerPayMasterMgrfixAllowanceList(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		List<?> list = new ArrayList<Object>();
		String Message = "";

		try{
			list = perPayMasterMgrService.getPerPayMasterMgrfixAllowanceList(paramMap);
		}catch(Exception e){
			Message="조회에 실패하였습니다.";
		}

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);

		Log.DebugEnd();
		return mv;
	}

	/**
	 * 급여기본사항 기본사항TAB 계좌정보 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPerPayMasterMgrAccountInfoList", method = RequestMethod.POST )
	public ModelAndView getPerPayMasterMgrAccountInfoList(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		List<?> list = new ArrayList<Object>();
		String Message = "";

		try{
			list = perPayMasterMgrService.getPerPayMasterMgrAccountInfoList(paramMap);
		}catch(Exception e){
			Message="조회에 실패하였습니다.";
		}

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);

		Log.DebugEnd();
		return mv;
	}

	/**
	 * 급여기본사항 기본사항TAB 과세정보 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPerPayMasterMgrTaxInfoList", method = RequestMethod.POST )
	public ModelAndView getPerPayMasterMgrTaxInfoList(
				HttpSession session
			, 	HttpServletRequest request
			,	@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		List<?> list = new ArrayList<Object>();
		String Message = "";

		try {
			list = perPayMasterMgrService.getPerPayMasterMgrTaxInfoList(paramMap);
		} catch(Exception e) {
			Message="조회에 실패하였습니다.";
		}

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);

		Log.DebugEnd();

		return mv;
	}

	/**
	 * 급여기본사항 지급/공제 예외사항TAB 지급 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPerPayMasterMgrPayList", method = RequestMethod.POST )
	public ModelAndView getPerPayMasterMgrPayList(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		List<?> list = new ArrayList<Object>();
		String Message = "";

		try{
			list = perPayMasterMgrService.getPerPayMasterMgrPayList(paramMap);
		}catch(Exception e){
			Message="조회에 실패하였습니다.";
		}

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);

		Log.DebugEnd();
		return mv;
	}

	/**
	 * 급여기본사항 지급/공제 예외사항TAB 공제 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPerPayMasterMgrDeductionList", method = RequestMethod.POST )
	public ModelAndView getPerPayMasterMgrDeductionList(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		List<?> list = new ArrayList<Object>();
		String Message = "";

		try{
			list = perPayMasterMgrService.getPerPayMasterMgrDeductionList(paramMap);
		}catch(Exception e){
			Message="조회에 실패하였습니다.";
		}

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);

		Log.DebugEnd();
		return mv;
	}

	/**
	 * 급여기본사항 연봉이력TAB 연봉이력 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPerPayMasterMgrAnnualIncomeList", method = RequestMethod.POST )
	public ModelAndView getPerPayMasterMgrAnnualIncomeList(
				HttpSession session
			, 	HttpServletRequest request
			,	@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		List<?> list   = new ArrayList<Object>();
		String Message = "";
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",   session.getAttribute("ssnSabun"));
//		paramMap.put("columnInfo", XssPreventer.unescape(paramMap.get("columnInfo").toString()));
		
		try {
			List<Map> columnInfo = (List<Map>) perPayYearMgrService.getPerPayYearMgrTitleList(paramMap);
			List<String> elementCd = Arrays.asList(columnInfo.get(0).get("elementCd").toString().split("\\|"));
			List<String> elementAlias = elementCd.stream()
					.map(element -> "ELE_" + element)
					.collect(Collectors.toList());

			paramMap.put("elementCd", elementCd);
			paramMap.put("elementAlias", elementAlias);

			list = perPayMasterMgrService.getPerPayMasterMgrAnnualIncomeList(paramMap);
		} catch(Exception e) {
			Message="조회에 실패하였습니다.";
		}

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);

		Log.DebugEnd();

		return mv;
	}

	/**
	 * 급여기본사항 퇴직금중간정산TAB 퇴직금예외기간 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPerPayMasterMgrExceptionTermList", method = RequestMethod.POST )
	public ModelAndView getPerPayMasterMgrExceptionTermList(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		List<?> list = new ArrayList<Object>();
		String Message = "";

		try{
			list = perPayMasterMgrService.getPerPayMasterMgrExceptionTermList(paramMap);
		}catch(Exception e){
			Message="조회에 실패하였습니다.";
		}

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);

		Log.DebugEnd();
		return mv;
	}

	/**
	 * 급여기본사항 퇴직금중간정산TAB 중간정산내역 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPerPayMasterMgrInterimPayList", method = RequestMethod.POST )
	public ModelAndView getPerPayMasterMgrInterimPayList(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		List<?> list = new ArrayList<Object>();
		String Message = "";

		try{
			list = perPayMasterMgrService.getPerPayMasterMgrInterimPayList(paramMap);
		}catch(Exception e){
			Message="조회에 실패하였습니다.";
		}

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);

		Log.DebugEnd();
		return mv;
	}

	/**
	 * 급여기본사항 급여압류TAB 채권현황 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPerPayMasterMgrBondStateList", method = RequestMethod.POST )
	public ModelAndView getPerPayMasterMgrBondStateList(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		List<?> list = new ArrayList<Object>();
		String Message = "";

		try{
			list = perPayMasterMgrService.getPerPayMasterMgrBondStateList(paramMap);
		}catch(Exception e){
			Message="조회에 실패하였습니다.";
		}

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);

		Log.DebugEnd();
		return mv;
	}

	/**
	 * 급여기본사항 급여압류TAB 공제현황 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPerPayMasterMgrDeductionStateList", method = RequestMethod.POST )
	public ModelAndView getPerPayMasterMgrDeductionStateList(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		List<?> list = new ArrayList<Object>();
		String Message = "";

		try{
			list = perPayMasterMgrService.getPerPayMasterMgrDeductionStateList(paramMap);
		}catch(Exception e){
			Message="조회에 실패하였습니다.";
		}

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);

		Log.DebugEnd();
		return mv;
	}

	/**
	 * 급여기본사항 사회보험TAB 현재불입상태 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPerPayMasterMgrPayStatusList", method = RequestMethod.POST )
	public ModelAndView getPerPayMasterMgrPayStatusList(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		List<?> list = new ArrayList<Object>();
		String Message = "";

		try{
			list = perPayMasterMgrService.getPerPayMasterMgrPayStatusList(paramMap);
		}catch(Exception e){
			Message="조회에 실패하였습니다.";
		}

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);

		Log.DebugEnd();
		return mv;
	}

	/**
	 * 급여기본사항 사회보험TAB 년도별 건강/요양보험료정산 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPerPayMasterMgrPremiumCalcList", method = RequestMethod.POST )
	public ModelAndView getPerPayMasterMgrPremiumCalcList(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		List<?> list = new ArrayList<Object>();
		String Message = "";

		try{
			list = perPayMasterMgrService.getPerPayMasterMgrPremiumCalcList(paramMap);
		}catch(Exception e){
			Message="조회에 실패하였습니다.";
		}

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);

		Log.DebugEnd();
		return mv;
	}

	/**
	 * 급여기본사항 대출현황TAB 대출현황 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPerPayMasterMgrLoanStateList", method = RequestMethod.POST )
	public ModelAndView getPerPayMasterMgrLoanStateList(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		List<?> list = new ArrayList<Object>();
		String Message = "";

		try{
			list = perPayMasterMgrService.getPerPayMasterMgrLoanStateList(paramMap);
		}catch(Exception e){
			Message="조회에 실패하였습니다.";
		}

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);

		Log.DebugEnd();
		return mv;
	}

	/**
	 * 급여기본사항 대출현황TAB 항목별 상환내역 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPerPayMasterMgrRepayList", method = RequestMethod.POST )
	public ModelAndView getPerPayMasterMgrRepayList(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		List<?> list = new ArrayList<Object>();
		String Message = "";

		try{
			list = perPayMasterMgrService.getPerPayMasterMgrRepayList(paramMap);
		}catch(Exception e){
			Message="조회에 실패하였습니다.";
		}

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);

		Log.DebugEnd();
		return mv;
	}

	/**
	 * 급여기본사항 기본사항TAB 과세정보 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=savePerPayMasterMgrTaxInfo", method = RequestMethod.POST )
	public ModelAndView savePerPayMasterMgrTaxInfo(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		convertMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		String message = "";
		int resultCnt = -1;

		try{
			resultCnt = perPayMasterMgrService.savePerPayMasterMgrTaxInfo(convertMap);
			if(resultCnt > 0){ message="저장 되었습니다."; } else{ message="저장된 내용이 없습니다."; }
		}catch(Exception e){
			resultCnt = -1; message="저장에 실패하였습니다.";
		}

		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("Code", resultCnt);
		resultMap.put("Message", message);

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Result", resultMap);

		Log.DebugEnd();
		return mv;
	}

	/**
	 * 급여기본사항 기본사항TAB 수당기준 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=savePerPayMasterMgrAllowYnInfo", method = RequestMethod.POST )
	public ModelAndView savePerPayMasterMgrAllowYnInfo(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		String message = "";
		int resultCnt = -1;

		try{
			resultCnt = perPayMasterMgrService.savePerPayMasterMgrAllowYnInfo(paramMap);
			if(resultCnt > 0){ message="저장 되었습니다."; } else{ message="저장된 내용이 없습니다."; }
		}catch(Exception e){
			resultCnt = -1; message="저장에 실패하였습니다.";
		}

		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("Code", resultCnt);
		resultMap.put("Message", message);

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Result", resultMap);

		Log.DebugEnd();
		return mv;
	}

	/**
	 * 급여기본사항 기본사항TAB 계좌정보 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=savePerPayMasterMgrAccountInfo", method = RequestMethod.POST )
	public ModelAndView savePerPayMasterMgrAccountInfo(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");

		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		convertMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		List<Map> insertList = (List<Map>)convertMap.get("insertRows");
		List<Map<String,Object>> dupList = new ArrayList<Map<String,Object>>();

		for(Map<String,Object> mp : insertList) {
			Map<String,Object> dupMap = new HashMap<String,Object>();
			dupMap.put("ENTER_CD",convertMap.get("ssnEnterCd"));
			dupMap.put("SABUN",mp.get("sabun"));
			dupMap.put("ACCOUNT_TYPE",mp.get("accountType"));
			dupMap.put("BANK_CD",mp.get("bankCd"));
			dupMap.put("ACCOUNT_NO",mp.get("accountNo"));
			dupList.add(dupMap);
		}

		String message = "";
		int resultCnt = -1;

		try{
			int dupCnt = 0;

			if(insertList.size() > 0) {
				// 중복체크
				dupCnt = commonCodeService.getDupCnt("TCPN180","ENTER_CD,SABUN,ACCOUNT_TYPE,SDATE","s,s,s,s",dupList);
			}

			if(dupCnt > 0) {
				resultCnt = -1; message="중복된 값이 존재합니다.";
			} else {
				resultCnt = perPayMasterMgrService.savePerPayMasterMgrAccountInfo(convertMap);
				if(resultCnt > 0){ message="저장 되었습니다."; } else{ message="저장된 내용이 없습니다."; }
			}
		}catch(Exception e){
			resultCnt = -1; message="저장에 실패하였습니다.";
		}

		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("Code", resultCnt);
		resultMap.put("Message", message);

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Result", resultMap);

		Log.DebugEnd();
		return mv;
	}

	/**
	 * 급여기본사항 지급/공제 예외사항TAB 지급/공제 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=savePerPayMasterMgrPayDeduction", method = RequestMethod.POST )
	public ModelAndView savePerPayMasterMgrPayDeduction(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");

		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		convertMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		List<Map> insertList = (List<Map>)convertMap.get("insertRows");
		List<Map<String,Object>> dupList = new ArrayList<Map<String,Object>>();

		for(Map<String,Object> mp : insertList) {
			Map<String,Object> dupMap = new HashMap<String,Object>();
			dupMap.put("ENTER_CD",convertMap.get("ssnEnterCd"));
			dupMap.put("SABUN",mp.get("sabun"));
			dupMap.put("ELEMENT_CD",mp.get("elementCd"));
			dupMap.put("SDATE",mp.get("sdate"));
			dupList.add(dupMap);
		}

		String message = "";
		int resultCnt = -1;

		try{
			int dupCnt = 0;

			if(insertList.size() > 0) {
				// 중복체크
				dupCnt = commonCodeService.getDupCnt("TCPN292","ENTER_CD,SABUN,ELEMENT_CD,SDATE","s,s,s,s",dupList);
			}

			if(dupCnt > 0) {
				resultCnt = -1; message="중복된 값이 존재합니다.";
			} else {
				resultCnt = perPayMasterMgrService.savePerPayMasterMgrPayDeduction(convertMap);
				if(resultCnt > 0){ message="저장 되었습니다."; } else{ message="저장된 내용이 없습니다."; }
			}
		}catch(Exception e){
			resultCnt = -1; message="저장에 실패하였습니다.";
		}

		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("Code", resultCnt);
		resultMap.put("Message", message);

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Result", resultMap);

		Log.DebugEnd();
		return mv;
	}


	/**
	 * 급여기본사항 기본사항TAB 퇴직금추가계액 단건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPerPayMasterMgrMap", method = RequestMethod.POST )
	public ModelAndView getPerPayMasterMgrMap(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		String Message = "";
		Map<?, ?> map = null;

		try{
			map = perPayMasterMgrService.getPerPayMasterMgrMap(paramMap);
		}catch(Exception e){
			Message="조회에 실패하였습니다.";
		}

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Map",map);
		mv.addObject("Message", Message);

		Log.DebugEnd();
		return mv;
	}

    @RequestMapping(params="cmd=getYearCombo", method = RequestMethod.POST )
    public ModelAndView getYearCombo(
            HttpSession session,  HttpServletRequest request,
            @RequestParam Map<String, Object> paramMap ) throws Exception {
        Log.DebugStart();

        paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
        paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

        List<?> list  = new ArrayList<Object>();
        String Message = "";
        try{
            list = perPayMasterMgrService.getYearCombo(paramMap);
        }catch(Exception e){
            Message="조회에 실패 하였습니다.";
        }
        ModelAndView mv = new ModelAndView();
        mv.setViewName("jsonView");
        mv.addObject("DATA", list);
        mv.addObject("Message", Message);
        Log.DebugEnd();
        return mv;
    }

    @RequestMapping(params="cmd=getPerPayMasterMgrSalaryPeak", method = RequestMethod.POST )
    public ModelAndView getPerPayMasterMgrSalaryPeak(
            HttpSession session,  HttpServletRequest request,
            @RequestParam Map<String, Object> paramMap ) throws Exception {
        Log.DebugStart();

        paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
        paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

        List<?> list  = new ArrayList<Object>();
        String Message = "";
        try{
            list = perPayMasterMgrService.getPerPayMasterMgrSalaryPeak(paramMap);
        }catch(Exception e){
            Message="조회에 실패 하였습니다.";
        }
        ModelAndView mv = new ModelAndView();
        mv.setViewName("jsonView");
        mv.addObject("DATA", list);
        mv.addObject("Message", Message);
        Log.DebugEnd();
        return mv;
    }

    @RequestMapping(params="cmd=getPerPayMasterMgrSalaryPeakCalc", method = RequestMethod.POST )
    public ModelAndView getPerPayMasterMgrSalaryPeakCalc(
            HttpSession session,  HttpServletRequest request,
            @RequestParam Map<String, Object> paramMap ) throws Exception {
        Log.DebugStart();

        paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
        paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

        List<?> list  = new ArrayList<Object>();
        String Message = "";
        try{
            list = perPayMasterMgrService.getPerPayMasterMgrSalaryPeakCalc(paramMap);
        }catch(Exception e){
            Message="조회에 실패 하였습니다.";
        }
        ModelAndView mv = new ModelAndView();
        mv.setViewName("jsonView");
        mv.addObject("DATA", list);
        mv.addObject("Message", Message);
        Log.DebugEnd();
        return mv;
    }


    @RequestMapping(params="cmd=savePerPayMasterMgrSalaryPeak", method = RequestMethod.POST )
    public ModelAndView savePerPayMasterMgrSalaryPeak(HttpSession session,
                                              @RequestParam Map<String, Object> paramMap,
                                              HttpServletRequest request) {
        Log.DebugEnd();
        Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
        convertMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
        convertMap.put("ssnSabun", 		session.getAttribute("ssnSabun"));
        Log.Debug(convertMap.toString());

        String message = "";
        int cnt = 0;
        try {
            cnt = perPayMasterMgrService.savePerPayMasterMgrSalaryPeak(convertMap);
            if (cnt > 0) {
                message = "저장되었습니다.";
            } else {
                message="저장된 내용이 없습니다.";
            }
        } catch (Exception e) {
            Log.Debug(e.getMessage());cnt=-1; message="저장 실패하였습니다.";
        }

        Map resultMap = new HashMap();
        resultMap.put("Code",cnt);
        resultMap.put("Message",message);
        ModelAndView mv = new ModelAndView();
        mv.setViewName("jsonView");
        mv.addObject("Result", 	resultMap);
        Log.DebugStart();
        return mv;
    }
}