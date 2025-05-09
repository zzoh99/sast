package com.hr.cpn.payCalculate.payAggrSta;
import java.util.ArrayList;
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

import com.hr.common.logger.Log;

/**
 * 급여집계(직급/부서별) Controller
 *
 * @author JM
 *
 */
@Controller
@RequestMapping(value="/PayAggrSta.do", method=RequestMethod.POST )
public class PayAggrStaController {

	/**
	 * 급여집계(직급/부서별) 서비스
	 */
	@Inject
	@Named("PayAggrStaService")
	private PayAggrStaService payAggrStaService;

	/**
	 * 급여집계(직급/부서별) View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewPayAggrSta", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewPayAggrSta() throws Exception {
		return "cpn/payCalculate/payAggrSta/payAggrSta";
	}

	/**
	 * 급여집계(직급/부서별) 수당집계TAB View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewPayAggrStaAllowanceTotal", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewPayAggrStaAllowanceTotal() throws Exception {
		return "cpn/payCalculate/payAggrSta/payAggrStaAllowanceTotal";
	}

	/**
	 * 급여집계(직급/부서별) 공제집계TAB View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewPayAggrStaDeductionTotal", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewPayAggrStaDeductionTotal() throws Exception {
		return "cpn/payCalculate/payAggrSta/payAggrStaDeductionTotal";
	}

	/**
	 * 급여집계(직급/부서별) 직급집계TAB View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewPayAggrStaJikgubTotal", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewPayAggrStaJikgubTotal() throws Exception {
		return "cpn/payCalculate/payAggrSta/payAggrStaJikgubTotal";
	}

	/**
	 * 급여집계(직급/부서별) 부서집계TAB View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewPayAggrStaOrgTotal", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewPayAggrStaOrgTotal() throws Exception {
		return "cpn/payCalculate/payAggrSta/payAggrStaOrgTotal";
	}

	/**
	 * 급여집계(직급/부서별) 수당집계TAB 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPayAggrStaAllowanceTotalList", method = RequestMethod.POST )
	public ModelAndView getPayAggrStaAllowanceTotalList(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		List<?> list = new ArrayList<Object>();
		String Message = "";

		try{
			list = payAggrStaService.getPayAggrStaAllowanceTotalList(paramMap);
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
	 * 급여집계(직급/부서별) 공제집계TAB 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPayAggrStaDeductionTotalList", method = RequestMethod.POST )
	public ModelAndView getPayAggrStaDeductionTotalList(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		List<?> list = new ArrayList<Object>();
		String Message = "";

		try{
			list = payAggrStaService.getPayAggrStaDeductionTotalList(paramMap);
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
	 * 급여집계(직급/부서별) 직급집계TAB 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPayAggrStaJikgubTotalList", method = RequestMethod.POST )
	public ModelAndView getPayAggrStaJikgubTotalList(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		List<?> list = new ArrayList<Object>();
		String Message = "";

		try{
			list = payAggrStaService.getPayAggrStaJikgubTotalList(paramMap);
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
	 * 급여집계(직급/부서별) 부서집계TAB 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPayAggrStaOrgTotalList", method = RequestMethod.POST )
	public ModelAndView getPayAggrStaOrgTotalList(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		List<?> list = new ArrayList<Object>();
		String Message = "";

		try{
			list = payAggrStaService.getPayAggrStaOrgTotalList(paramMap);
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
}