package com.hr.cpn.payRetire.sepEmpRsMgr;
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

import com.hr.common.code.CommonCodeService;
import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;

/**
 * 퇴직금기본내역 Controller
 *
 * @author JM
 *
 */
@Controller
@SuppressWarnings("unchecked")
@RequestMapping(value="/SepEmpRsMgr.do", method=RequestMethod.POST )
public class SepEmpRsMgrController {

	/**
	 * 퇴직금기본내역 서비스
	 */
	@Inject
	@Named("SepEmpRsMgrService")
	private SepEmpRsMgrService sepEmpRsMgrService;

	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;

	/**
	 * 퇴직금기본내역 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewSepEmpRsMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewSepEmpRsMgr() throws Exception {
		return "cpn/payRetire/sepEmpRsMgr/sepEmpRsMgr";
	}

	/**
	 * 퇴직금기본내역 기본사항TAB View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewSepEmpRsMgrBasic", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewSepEmpRsMgrBasic() throws Exception {
		return "cpn/payRetire/sepEmpRsMgr/sepEmpRsMgrBasic";
	}

	/**
	 * 퇴직금기본내역 평균임금TAB View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewSepEmpRsMgrAverageIncome", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewSepEmpRsMgrAverageIncome() throws Exception {
		return "cpn/payRetire/sepEmpRsMgr/sepEmpRsMgrAverageIncome";
	}

	/**
	 * 퇴직금기본내역 퇴직금계산내역TAB View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewSepEmpRsMgrSeverancePayCalc", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewSepEmpRsMgrSeverancePayCalc() throws Exception {
		return "cpn/payRetire/sepEmpRsMgr/sepEmpRsMgrSeverancePayCalc";
	}

	/**
	 * 퇴직금기본내역 퇴직종합정산TAB View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewSepEmpRsMgrRetireCalc", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewSepEmpRsMgrRetireCalc() throws Exception {
		return "cpn/payRetire/sepEmpRsMgr/sepEmpRsMgrRetireCalc";
	}

	/**
	 * 퇴직금기본내역 전근무지사항TAB View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewSepEmpRsMgrBeforeWork", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewSepEmpRsMgrBeforeWork() throws Exception {
		return "cpn/payRetire/sepEmpRsMgr/sepEmpRsMgrBeforeWork";
	}

	/**
	 * 사회보험통합관리 좌측 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getSepEmpRsMgrListLeft", method = RequestMethod.POST )
	public ModelAndView getSepEmpRsMgrListLeft(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = sepEmpRsMgrService.getSepEmpRsMgrListLeft(paramMap);
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

	/**
	 * 퇴직금기본내역 기본사항TAB 단건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getSepEmpRsMgrBasicMap", method = RequestMethod.POST )
	public ModelAndView getSepEmpRsMgrBasicMap(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		String Message = "";
		Map<?, ?> map = null;

		try{
			map = sepEmpRsMgrService.getSepEmpRsMgrBasicMap(paramMap);
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
	 * 퇴직금기본내역 평균임금TAB 급여 항목리스트 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getSepEmpRsMgrAverageIncomePayTitleList", method = RequestMethod.POST )
	public ModelAndView getSepEmpRsMgrAverageIncomePayTitleList(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		List<?> list = new ArrayList<Object>();
		String Message = "";

		try{
			list = sepEmpRsMgrService.getSepEmpRsMgrAverageIncomePayTitleList(paramMap);
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
	 * 퇴직금기본내역 평균임금TAB 급여 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getSepEmpRsMgrAverageIncomePayList", method = RequestMethod.POST )
	public ModelAndView getSepEmpRsMgrAverageIncomePayList(
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
			// 퇴직금기본내역 평균임금TAB 급여 항목리스트 조회
			titleList = sepEmpRsMgrService.getSepEmpRsMgrAverageIncomePayTitleList(paramMap);

			for(int i = 0 ; i < titleList.size() ; i++){
				mapElement = new HashMap<String, String>();
				Map<String, String> map = (Map<String, String>) titleList.get(i);
				mapElement.put("elementCd", map.get("elementCd").toString());
				titles.add(mapElement);
				paramMap.put("titles", titles);
			}

			list = sepEmpRsMgrService.getSepEmpRsMgrAverageIncomePayList(paramMap);
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
	 * 퇴직금기본내역 평균임금TAB 상여 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getSepEmpRsMgrAverageIncomeBonusList", method = RequestMethod.POST )
	public ModelAndView getSepEmpRsMgrAverageIncomeBonusList(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		List<?> list = new ArrayList<Object>();
		String Message = "";

		try{
			list = sepEmpRsMgrService.getSepEmpRsMgrAverageIncomeBonusList(paramMap);
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
	 * 퇴직금기본내역 평균임금TAB 연차 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getSepEmpRsMgrAverageIncomeAnnualList", method = RequestMethod.POST )
	public ModelAndView getSepEmpRsMgrAverageIncomeAnnualList(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		List<?> list = new ArrayList<Object>();
		String Message = "";

		try{
			list = sepEmpRsMgrService.getSepEmpRsMgrAverageIncomeAnnualList(paramMap);
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
	 * 퇴직금기본내역 평균임금TAB 퇴직금계산내역 단건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getSepEmpRsMgrSeverancePayMap", method = RequestMethod.POST )
	public ModelAndView getSepEmpRsMgrSeverancePayMap(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		String Message = "";
		Map<?, ?> map = null;

		try{
			map = sepEmpRsMgrService.getSepEmpRsMgrSeverancePayMap(paramMap);
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
	 * 퇴직금기본내역 퇴직금계산내역TAB 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getSepEmpRsMgrSeverancePayCalcList", method = RequestMethod.POST )
	public ModelAndView getSepEmpRsMgrSeverancePayCalcList(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		List<?> list = new ArrayList<Object>();
		String Message = "";

		try{
			list = sepEmpRsMgrService.getSepEmpRsMgrSeverancePayCalcList(paramMap);
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
	 * 퇴직금기본내역 퇴직종합정산TAB 지급내역 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getSepEmpRsMgrRetireCalcPayList", method = RequestMethod.POST )
	public ModelAndView getSepEmpRsMgrRetireCalcPayList(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		List<?> list = new ArrayList<Object>();
		String Message = "";

		try{
			list = sepEmpRsMgrService.getSepEmpRsMgrRetireCalcPayList(paramMap);
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
	 * 퇴직금기본내역 퇴직종합정산TAB 공제내역 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getSepEmpRsMgrRetireCalcDeductionList", method = RequestMethod.POST )
	public ModelAndView getSepEmpRsMgrRetireCalcDeductionList(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		List<?> list = new ArrayList<Object>();
		String Message = "";

		try{
			list = sepEmpRsMgrService.getSepEmpRsMgrRetireCalcDeductionList(paramMap);
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
	 * 퇴직금기본내역 전근무지사항TAB 단건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getSepEmpRsMgrBeforeWorkMap", method = RequestMethod.POST )
	public ModelAndView getSepEmpRsMgrBeforeWorkMap(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		String Message = "";
		Map<?, ?> map = null;

		try{
			map = sepEmpRsMgrService.getSepEmpRsMgrBeforeWorkMap(paramMap);
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
	 * 퇴직금기본내역 IRP정보 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveSepEmpRsMgrIrpInfo", method = RequestMethod.POST )
	public ModelAndView saveSepEmpRsMgrIrpInfo(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		String message = "";
		int resultCnt = -1;

		try{
			resultCnt = sepEmpRsMgrService.saveSepEmpRsMgrIrpInfo(paramMap);
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
	 * 퇴직금기본내역 평균임금TAB 급여 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveSepEmpRsMgrAverageIncomePay", method = RequestMethod.POST )
	public ModelAndView saveSepEmpRsMgrAverageIncomePay(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");

		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		convertMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		List<Map<String, Object>> insertList = (List<Map<String, Object>>)convertMap.get("insertRows");
		List<Map<String, Object>> mergeList = (List<Map<String, Object>>)convertMap.get("mergeRows");

		List<Map<String,Object>> dupList = new ArrayList<Map<String,Object>>();

		for(Map<String,Object> mp : insertList) {
			Map<String,Object> dupMap = new HashMap<String,Object>();
			dupMap.put("ENTER_CD",convertMap.get("ssnEnterCd"));
			dupMap.put("PAY_ACTION_CD",mp.get("payActionCd"));
			dupMap.put("SABUN",mp.get("sabun"));
			dupMap.put("CAL_FYMD",mp.get("calFymd"));
			dupList.add(dupMap);
		}

		List<Serializable> elementInfo = new ArrayList<Serializable>();

		for(Map<String,Object> mp : mergeList) {
			//Map<String, Object> mergeMap = new HashMap<String,Object>();

			String[] detailElementCdList = mp.get("detailElementCd").toString().split(",");
			String[] detailMonList = mp.get("detailMon").toString().split(",");

			HashMap<String, String> map = null;

			Log.Debug("detailElementCdList.length      => ["+detailElementCdList.length+"]");

			for(int i = 0 ; i < detailElementCdList.length ; i++) {
				map = new HashMap<String, String>();
				map.put("payActionCd", mp.get("payActionCd").toString());
				map.put("sabun", mp.get("sabun").toString());
				map.put("calFymd", mp.get("calFymd").toString());
				map.put("elementCd", detailElementCdList[i]);
				map.put("mon", detailMonList[i]);

				elementInfo.add(map);
			}
		}
		convertMap.put("elementInfo", elementInfo);

		String message = "";
		int resultCnt = -1;
		try{
			int dupCnt = 0;

			if(insertList.size() > 0) {
				// 중복체크
				dupCnt = commonCodeService.getDupCnt("TCPN757","ENTER_CD,PAY_ACTION_CD,SABUN,CAL_FYMD","s,s,s,s",dupList);
			}

			if(dupCnt > 0) {
				resultCnt = -1; message="중복된 값이 존재합니다.";
			} else {
				resultCnt = sepEmpRsMgrService.saveSepEmpRsMgrAverageIncomePay(convertMap);
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
	 * 퇴직금기본내역 평균임금TAB 상여 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveSepEmpRsMgrAverageIncomeBonus", method = RequestMethod.POST )
	public ModelAndView saveSepEmpRsMgrAverageIncomeBonus(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");

		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		convertMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		String message = "";
		int resultCnt = -1;

		try{
			resultCnt = sepEmpRsMgrService.saveSepEmpRsMgrAverageIncomeBonus(convertMap);
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
	 * 퇴직금기본내역 평균임금TAB 연차 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveSepEmpRsMgrAverageIncomeAnnual", method = RequestMethod.POST )
	public ModelAndView saveSepEmpRsMgrAverageIncomeAnnual(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");

		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		convertMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		String message = "";
		int resultCnt = -1;

		try{
			resultCnt = sepEmpRsMgrService.saveSepEmpRsMgrAverageIncomeAnnual(convertMap);
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
	 * 퇴직금재계산
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=prcP_CPN_SEP_PAY_MAIN", method = RequestMethod.POST )
	public ModelAndView prcP_CPN_SEP_PAY_MAIN(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<?, ?> map = sepEmpRsMgrService.prcP_CPN_SEP_PAY_MAIN(paramMap);
		
		if (map != null) {
			Log.Debug("map[" + map + "] sqlcode[" + map.get("sqlcode") + "] sqlerrm[" + map.get("sqlerrm") + "]");
			resultMap.put("Code", "0");
			if (map.get("sqlcode") != null && !"OK".equals(map.get("sqlcode").toString())) {
				resultMap.put("Code", map.get("sqlcode").toString());
				if (map.get("sqlerrm") != null) {
					resultMap.put("Message", map.get("sqlerrm").toString());
				} else {
					resultMap.put("Message", "퇴직금재계산 오류입니다.");
				}
			}
		} else {
			resultMap.put("Message", "퇴직금재계산 오류입니다.");
		}

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Result", resultMap);

		Log.DebugEnd();
		return mv;
	}
}