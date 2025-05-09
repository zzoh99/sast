package com.hr.cpn.personalPay.perPayPartiAdminSta;
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
 * 개인별급여세부내역(관리자) Controller
 *
 * @author JM
 *
 */
@Controller
@RequestMapping({"/PerPayPartiAdminSta.do", "/PayCalculator.do", "/PerPayPartiTermUSta.do"})
public class PerPayPartiAdminStaController {

	/**
	 * 개인별급여세부내역(관리자) 서비스
	 */
	@Inject
	@Named("PerPayPartiAdminStaService")
	private PerPayPartiAdminStaService perPayPartiAdminStaService;

	/**
	 * 개인별급여세부내역(관리자) View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewPerPayPartiAdminSta", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewPerPayPartiAdminSta() throws Exception {
		return "cpn/personalPay/perPayPartiAdminSta/perPayPartiAdminSta";
	}

	/**
	 * 개인별급여세부내역(관리자) Sub Main View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewPerPayPartiAdminStaSubMain", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewPerPayPartiAdminStaSubMain() throws Exception {
		return "cpn/personalPay/perPayPartiAdminSta/perPayPartiAdminStaSubMain";
	}

	/**
	 * 개인별급여세부내역(관리자) 계산내역TAB View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewPerPayPartiAdminStaCalc", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewPerPayPartiAdminStaCalc() throws Exception {
		return "cpn/personalPay/perPayPartiAdminSta/perPayPartiAdminStaCalc";
	}

	/**
	 * 개인별급여세부내역(관리자) 기타내역TAB View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewPerPayPartiAdminStaEtc", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewPerPayPartiAdminStaEtc() throws Exception {
		return "cpn/personalPay/perPayPartiAdminSta/perPayPartiAdminStaEtc";
	}

	/**
	 * 개인별급여세부내역(관리자) 항목세부내역TAB View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewPerPayPartiAdminStaDtl", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewPerPayPartiAdminStaDtl() throws Exception {
		return "cpn/personalPay/perPayPartiAdminSta/perPayPartiAdminStaDtl";
	}

	/**
	 * 개인별급여세부내역(관리자) 최근급여일자 단건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAdminLatestPaymentInfoMap", method = RequestMethod.POST )
	public ModelAndView getAdminLatestPaymentInfoMap(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		String Message = "";
		Map<?, ?> map = null;

		try{
			map = perPayPartiAdminStaService.getAdminLatestPaymentInfoMap(paramMap);
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
	 * 개인별급여세부내역(관리자) 계산내역TAB 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPerPayPartiAdminStaList", method = RequestMethod.POST )
	public ModelAndView getPerPayPartiAdminStaList(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		List<?> list = new ArrayList<Object>();
		String Message = "";

		try{
			// 항목구분(A.지급 D.공제)
			// 공제분류(ER_CAG.회사부담금) 제외
			list = perPayPartiAdminStaService.getPerPayPartiAdminStaList(paramMap);
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
	 * 개인별급여세부내역(관리자) 계산내역TAB 세금내역 단건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPerPayPartiAdminStaTaxMap", method = RequestMethod.POST )
	public ModelAndView getPerPayPartiAdminStaTaxMap(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		String Message = "";
		Map<?, ?> map = null;

		try{
			map = perPayPartiAdminStaService.getPerPayPartiAdminStaTaxMap(paramMap);
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
	 * 개인별급여세부내역(관리자) 기타내역TAB 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPerPayPartiAdminStaEtcList", method = RequestMethod.POST )
	public ModelAndView getPerPayPartiAdminStaEtcList(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		List<?> list = new ArrayList<Object>();
		String Message = "";

		try{
			list = perPayPartiAdminStaService.getPerPayPartiAdminStaEtcList(paramMap);
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
	 * 개인별급여세부내역(관리자) 항목세부내역TAB 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPerPayPartiAdminStaDtlList", method = RequestMethod.POST )
	public ModelAndView getPerPayPartiAdminStaDtlList(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		List<?> list = new ArrayList<Object>();
		String Message = "";

		try{
			list = perPayPartiAdminStaService.getPerPayPartiAdminStaDtlList(paramMap);
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