package com.hr.cpn.personalPay.perPayPartiUserSta;
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
 * 월별급여지급현황 Controller
 *
 * @author JM
 *
 */
@Controller
@RequestMapping(value="/PerPayPartiUserSta.do", method=RequestMethod.POST )
public class PerPayPartiUserStaController {

	/**
	 * 월별급여지급현황 서비스
	 */
	@Inject
	@Named("PerPayPartiUserStaService")
	private PerPayPartiUserStaService perPayPartiUserStaService;

	/**
	 * 월별급여지급현황 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewPerPayPartiUserSta", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewPerPayPartiUserSta() throws Exception {
		return "cpn/personalPay/perPayPartiUserSta/perPayPartiUserSta";
	}

	/**
	 * 월별급여지급현황 Sub Main View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewPerPayPartiUserStaSubMain", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewPerPayPartiUserStaSubMain() throws Exception {
		return "cpn/personalPay/perPayPartiUserSta/perPayPartiUserStaSubMain";
	}

	/**
	 * 월별급여지급현황 계산내역TAB View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewPerPayPartiUserStaCalc", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewPerPayPartiUserStaCalc() throws Exception {
		return "cpn/personalPay/perPayPartiUserSta/perPayPartiUserStaCalc";
	}

	/**
	 * 월별급여지급현황 계산내역TAB 계산방법보기 View Layer
	 *
	 * @return String
	 * @throws Exception
	 */

	@RequestMapping(params="cmd=viewPerPayPartiUserStaCalcFormulaLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewPerPayPartiUserStaCalcFormulaLayer() throws Exception {
		return "cpn/personalPay/perPayPartiUserSta/perPayPartiUserStaCalcFormulaLayer";
	}

	/**
	 * 월별급여지급현황 기타내역TAB View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewPerPayPartiUserStaEtc", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewPerPayPartiUserStaEtc() throws Exception {
		return "cpn/personalPay/perPayPartiUserSta/perPayPartiUserStaEtc";
	}

	/**
	 * 월별급여지급현황 항목세부내역TAB View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewPerPayPartiUserStaDtl", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewPerPayPartiUserStaDtl() throws Exception {
		return "cpn/personalPay/perPayPartiUserSta/perPayPartiUserStaDtl";
	}

	/**
	 * 월별급여지급현황 최근급여일자 단건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getLatestPaymentInfoMap", method = RequestMethod.POST )
	public ModelAndView getLatestPaymentInfoMap(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		String Message = "";
		Map<?, ?> map = null;

		try{
			map = perPayPartiUserStaService.getLatestPaymentInfoMap(paramMap);
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
	 * 월별급여지급현황 계산내역TAB 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPerPayPartiUserStaList", method = RequestMethod.POST )
	public ModelAndView getPerPayPartiUserStaList(
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
			list = perPayPartiUserStaService.getPerPayPartiUserStaList(paramMap);
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
	 * 월별급여지급현황 계산내역TAB 세금내역 단건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPerPayPartiUserStaTaxMap", method = RequestMethod.POST )
	public ModelAndView getPerPayPartiUserStaTaxMap(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		String Message = "";
		Map<?, ?> map = null;

		try{
			map = perPayPartiUserStaService.getPerPayPartiUserStaTaxMap(paramMap);
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
	 * 월별급여지급현황 기타내역TAB 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPerPayPartiUserStaEtcList", method = RequestMethod.POST )
	public ModelAndView getPerPayPartiUserStaEtcList(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		List<?> list = new ArrayList<Object>();
		String Message = "";

		try{
			list = perPayPartiUserStaService.getPerPayPartiUserStaEtcList(paramMap);
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
	 * 월별급여지급현황 항목세부내역TAB 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPerPayPartiUserStaDtlList", method = RequestMethod.POST )
	public ModelAndView getPerPayPartiUserStaDtlList(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		List<?> list = new ArrayList<Object>();
		String Message = "";

		try{
			list = perPayPartiUserStaService.getPerPayPartiUserStaDtlList(paramMap);
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
