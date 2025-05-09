package com.hr.cpn.payRetire.sepCalcResultSta;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.HashMap;
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
 * 퇴직금결과내역 Controller
 *
 * @author JM
 *
 */
@Controller
@RequestMapping(value="/SepCalcResultSta.do", method=RequestMethod.POST )
public class SepCalcResultStaController {

	/**
	 * 퇴직금결과내역 서비스
	 */
	@Inject
	@Named("SepCalcResultStaService")
	private SepCalcResultStaService sepCalcResultStaService;

	/**
	 * 퇴직금결과내역 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewSepCalcResultSta", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewSepCalcResultSta() throws Exception {
		return "cpn/payRetire/sepCalcResultSta/sepCalcResultSta";
	}

	/**
	 * 퇴직금결과내역 기본사항TAB View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewSepCalcResultStaBasic", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewSepCalcResultStaBasic() throws Exception {
		return "cpn/payRetire/sepCalcResultSta/sepCalcResultStaBasic";
	}

	/**
	 * 퇴직금결과내역 평균임금TAB View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewSepCalcResultStaAverageIncome", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewSepCalcResultStaAverageIncome() throws Exception {
		return "cpn/payRetire/sepCalcResultSta/sepCalcResultStaAverageIncome";
	}

	/**
	 * 퇴직금결과내역 퇴직금계산내역TAB View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewSepCalcResultStaSeverancePayCalc", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewSepCalcResultStaSeverancePayCalc() throws Exception {
		return "cpn/payRetire/sepCalcResultSta/sepCalcResultStaSeverancePayCalc";
	}

	/**
	 * 퇴직금결과내역 퇴직종합정산TAB View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewSepCalcResultStaRetireCalc", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewSepCalcResultStaRetireCalc() throws Exception {
		return "cpn/payRetire/sepCalcResultSta/sepCalcResultStaRetireCalc";
	}

	/**
	 * 퇴직금결과내역 전근무지사항TAB View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewSepCalcResultStaBeforeWork", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewSepCalcResultStaBeforeWork() throws Exception {
		return "cpn/payRetire/sepCalcResultSta/sepCalcResultStaBeforeWork";
	}

	/**
	 * 퇴직금결과내역 기본사항TAB 단건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getSepCalcResultStaBasicMap", method = RequestMethod.POST )
	public ModelAndView getSepCalcResultStaBasicMap(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		String Message = "";
		Map<?, ?> map = null;
		try{
			map = sepCalcResultStaService.getSepCalcResultStaBasicMap(paramMap);
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
	 * 퇴직금결과내역 평균임금TAB 급여 항목리스트 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getSepCalcResultStaAverageIncomePayTitleList", method = RequestMethod.POST )
	public ModelAndView getSepCalcResultStaAverageIncomePayTitleList(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		List<?> list = new ArrayList<Object>();
		String Message = "";

		try{
			list = sepCalcResultStaService.getSepCalcResultStaAverageIncomePayTitleList(paramMap);
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
	 * 퇴직금결과내역 평균임금TAB 급여 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getSepCalcResultStaAverageIncomePayList", method = RequestMethod.POST )
	public ModelAndView getSepCalcResultStaAverageIncomePayList(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		HashMap<String, String> mapElement = null;
		List<?> titleList = new ArrayList<Object>();
		List<Serializable> titles = new ArrayList<Serializable>();
		List<?> list = new ArrayList<Object>();
		String Message = "";

		try{
			// 퇴직금결과내역 평균임금TAB 급여 항목리스트 조회
			titleList = sepCalcResultStaService.getSepCalcResultStaAverageIncomePayTitleList(paramMap);

		    for(int i = 0 ; i < titleList.size() ; i++){
		    	mapElement = new HashMap<String, String>();
				Map<String, String> map = (Map)titleList.get(i);
				mapElement.put("elementCd", map.get("elementCd").toString());
				titles.add(mapElement);
				paramMap.put("titles", titles);
		    }

			list = sepCalcResultStaService.getSepCalcResultStaAverageIncomePayList(paramMap);
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
	 * 퇴직금결과내역 평균임금TAB 상여 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getSepCalcResultStaAverageIncomeBonusList", method = RequestMethod.POST )
	public ModelAndView getSepCalcResultStaAverageIncomeBonusList(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		List<?> list = new ArrayList<Object>();
		String Message = "";

		try{
			list = sepCalcResultStaService.getSepCalcResultStaAverageIncomeBonusList(paramMap);
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
	 * 퇴직금결과내역 평균임금TAB 연차 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getSepCalcResultStaAverageIncomeAnnualList", method = RequestMethod.POST )
	public ModelAndView getSepCalcResultStaAverageIncomeAnnualList(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		List<?> list = new ArrayList<Object>();
		String Message = "";

		try{
			list = sepCalcResultStaService.getSepCalcResultStaAverageIncomeAnnualList(paramMap);
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
	 * 퇴직금결과내역 퇴직금계산내역TAB 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getSepCalcResultStaSeverancePayCalcList", method = RequestMethod.POST )
	public ModelAndView getSepCalcResultStaSeverancePayCalcList(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		List<?> list = new ArrayList<Object>();
		String Message = "";

		try{
			list = sepCalcResultStaService.getSepCalcResultStaSeverancePayCalcList(paramMap);
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
	 * 퇴직금결과내역 퇴직종합정산TAB 지급내역 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getSepCalcResultStaRetireCalcPayList", method = RequestMethod.POST )
	public ModelAndView getSepCalcResultStaRetireCalcPayList(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		List<?> list = new ArrayList<Object>();
		String Message = "";

		try{
			list = sepCalcResultStaService.getSepCalcResultStaRetireCalcPayList(paramMap);
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
	 * 퇴직금결과내역 퇴직종합정산TAB 공제내역 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getSepCalcResultStaRetireCalcDeductionList", method = RequestMethod.POST )
	public ModelAndView getSepCalcResultStaRetireCalcDeductionList(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		List<?> list = new ArrayList<Object>();
		String Message = "";

		try{
			list = sepCalcResultStaService.getSepCalcResultStaRetireCalcDeductionList(paramMap);
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
	 * 퇴직금결과내역 전근무지사항TAB 단건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getSepCalcResultStaBeforeWorkMap", method = RequestMethod.POST )
	public ModelAndView getSepCalcResultStaBeforeWorkMap(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		String Message = "";
		Map<?, ?> map = null;
		try{
			map = sepCalcResultStaService.getSepCalcResultStaBeforeWorkMap(paramMap);
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
}