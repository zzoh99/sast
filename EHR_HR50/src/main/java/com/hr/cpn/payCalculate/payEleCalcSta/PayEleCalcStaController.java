package com.hr.cpn.payCalculate.payEleCalcSta;
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
 * 항목별계산내역 Controller
 *
 * @author JM
 *
 */
@Controller
@RequestMapping(value="/PayEleCalcSta.do", method=RequestMethod.POST )
public class PayEleCalcStaController {

	/**
	 * 항목별계산내역 서비스
	 */
	@Inject
	@Named("PayEleCalcStaService")
	private PayEleCalcStaService payEleCalcStaService;

	/**
	 * 항목별계산내역 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewPayEleCalcSta", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewPayEleCalcSta() throws Exception {
		return "cpn/payCalculate/payEleCalcSta/payEleCalcSta";
	}

	/**
	 * 항목별계산내역 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPayEleCalcStaList", method = RequestMethod.POST )
	public ModelAndView getPayEleCalcStaList(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

		List<?> list = new ArrayList<Object>();
		String Message = "";

		try{
			if (paramMap.get("byReportNmYn") != null && "on".equals(paramMap.get("byReportNmYn"))) {
				// 항목별계산내역 (Report명) 조회
				list = payEleCalcStaService.getPayEleCalcStaByReportNmList(paramMap);
			} else {
				// 항목별계산내역 조회
				list = payEleCalcStaService.getPayEleCalcStaList(paramMap);
			}
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
