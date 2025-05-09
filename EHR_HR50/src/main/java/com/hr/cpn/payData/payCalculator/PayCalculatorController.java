package com.hr.cpn.payData.payCalculator;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.hr.common.code.CommonCodeService;
import com.hr.common.com.ComController;
import com.hr.common.com.ComService;
import com.hr.common.execPrc.ExecPrcAsyncService;
import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;
import com.hr.cpn.payCalculate.payCalcCre.PayCalcCreProcService;
import com.hr.cpn.payCalculate.payCalcCre.PayCalcCreService;
import com.hr.cpn.payCalculate.payDayMgr.PayDayMgrService;

@Controller
@RequestMapping(value="/PayCalculator.do", method=RequestMethod.POST )
public class PayCalculatorController extends ComController  {

	@Autowired
	private ComService comService;
	
	@Autowired
	private CommonCodeService commonCodeService;
	
	@Autowired
	private PayDayMgrService payDayMgrService;
	
	@Autowired
	private PayCalculatorService payCalculatorService;
	
	@Autowired
	private PayCalcCreService payCalcCreService;
	
	@Autowired
	private PayCalcCreProcService payCalcCreProcService;
	
	@Autowired
	private ExecPrcAsyncService execPrcAsyncService;
	
	
	@RequestMapping(params="cmd=viewPayCalculator", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewPayCalculator() throws Exception {
		return "cpn/payData/payCalculator/payCalculator";
	}
	
	@RequestMapping(params="cmd=viewPayTargetAddLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewPayTargetAddLayer() throws Exception {
		return "cpn/payData/payCalculator/payTargetAddLayer";
	}
	
	@RequestMapping(params="cmd=viewPayCalcSummaryLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewPayCalcSummaryLayer() throws Exception {
		return "cpn/payData/payCalculator/payCalcSummaryLayer";
	}
	
	@RequestMapping(params="cmd=viewPayCalcTabs", method = {RequestMethod.POST, RequestMethod.GET} )
	public ModelAndView viewPayCalcTabs(@RequestParam String payActionCd
									  , HttpServletRequest request
									  , HttpSession session) throws Exception {
		ModelAndView mv = new ModelAndView();
		
		//사업장 코드
		Map<String, Object> param = new HashMap<>();
		param.put("queryId", "getOrgMapItemBpCdList");
		mv.addObject("orgCds", commonCodeService.getCommonNSCodeList(param));
		
		//급여구분코드
		param.put("queryId", "getCpnPayCdList");
		mv.addObject("payCds", commonCodeService.getCommonNSCodeList(param));
		
		//세금계산방법
		param.put("grpCd", "C00110");
		param.put("queryId", "C00110");
		mv.addObject("calMtCds", commonCodeService.getCommonCodeList(param));
		
		//적용일수
		param.put("grpCd", "C00160");
		param.put("queryId", "C00110");
		mv.addObject("bonCalcTypes", commonCodeService.getCommonCodeList(param));
		
		//적용구분
		param.put("grpCd", "C00019");
		param.put("queryId", "C00019");
		mv.addObject("bonApplTypes", commonCodeService.getCommonCodeList(param));

		//지급방법
		param.put("grpCd", "C00016");
		param.put("queryId", "C00016");
		mv.addObject("paymentMethods", commonCodeService.getCommonCodeList(param));
		
		ObjectMapper mapper = new ObjectMapper();
		
		param.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		param.put("payActionCd", payActionCd);
		param.put("cmd", "getPayCalcCreBasicMap");
		
		String payAction = mapper.writeValueAsString(comService.getDataMap(param));
		
		param.put("cmd", "getPayCalcCrePeopleMap");
		
		String basic = mapper.writeValueAsString(comService.getDataMap(param));
		
		mv.addObject("basic", basic);
		mv.addObject("payAction", payAction);
		mv.setViewName("cpn/payData/payCalculator/payCalcTabs");
		return mv;
	}
	
	/**
	 * PAY_ACTION 정보 수정
	 * 
	 * @param param
	 * @param session
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPayAction", method = RequestMethod.POST )
	public ModelAndView getPayAction(@RequestParam Map<String, Object> param
								   , HttpSession session) throws Exception {
		ModelAndView mv = new ModelAndView();
		
		Map<String, Object> data = new HashMap<>();
		
		String payActionCd = (String) param.get("payActionCd");
		Map<String, Object> p = new HashMap<>();
		p.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		p.put("payActionCd", payActionCd);
		p.put("cmd", "getPayCalcCreBasicMap");
		
		data.put("payAction", comService.getDataMap(p));
		
		param.put("cmd", "getPayCalcCrePeopleMap");
		data.put("basic", comService.getDataMap(param));
		
		mv.setViewName("jsonView");
		mv.addObject("DATA", data);
		return mv;
	}
	
	/**
	 * 급여계산 대상자 조회
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPaySearchTargetList", method = RequestMethod.POST )
	public ModelAndView getPaySearchTargetList(@RequestParam Map<String, Object> param) throws Exception {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", payCalculatorService.getSearchTargetList(param));
		return mv;
	}
	
	/**
	 * 급여계산 요약정보 조회
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPaymentSummary", method = RequestMethod.POST )
	public ModelAndView getPayementSummary(@RequestParam Map<String, Object> param) throws Exception {
		Map<String, Object> data = new HashMap<>();
		
		data.put("peoples", payCalculatorService.getPaymentStaticsPeoples(param));
		data.put("amount", payCalculatorService.getPaymentStatics(param));
		data.put("compare", payCalculatorService.getPaymentThenPrev(param));
		
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", data);
		
		return mv;
	}
	
	@RequestMapping(params="cmd=getPaymentTransferInfo", method = RequestMethod.POST )
	public ModelAndView getPaymentTransferInfo(@RequestParam Map<String, Object> param
											 , HttpSession session) throws Exception {
		Log.DebugStart();
		param.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		param.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		
		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try {
			list = payCalculatorService.getPaymentTransferInfo(param);
		} catch (Exception e) {
			Message = "조회에 실패 하였습니다.";
		}
		
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		
		return mv;
	}
	
	
	/**
	 * 급여계산서 (개인) 해당 사원 정보 조회
	 * 
	 * @param param
	 * @param session
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPayCalcPersonalInfo", method = RequestMethod.POST )
	public ModelAndView getPayCalcPersonalInfo(@RequestParam Map<String, Object> param
											 , HttpSession session) throws Exception {
		Log.DebugStart();
		param.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		param.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", payCalculatorService.getPayCalcPersonalInfo(param));
		
		return mv;
	}
	
	/**
	 * 급여계산서 (개인) 해당 사원의 근무시간 조회
	 * 
	 * @param param
	 * @param session
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPayCalcWorkTime", method = RequestMethod.POST )
	public ModelAndView getPayCalcWorkTime(@RequestParam Map<String, Object> param
										 , HttpSession session) throws Exception {
		Log.DebugStart();
		param.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", payCalculatorService.getPayCalcWorkTime(param));
		
		return mv;
	}
	
	/**
	 * 급여계산서 (개인) 급여관련 정보와 급여 산출 기준 제공
	 * 
	 * @param param
	 * @param session
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPayCalcFormila", method = RequestMethod.POST )
	public ModelAndView getPayCalcFormila(@RequestParam Map<String, Object> param
										, HttpSession session) throws Exception {
		Log.DebugStart();
		param.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", payCalculatorService.getPayCalcFormila(param));
		
		return mv;
	}
	
	/**
	 * 선택된 타겟 대상자 삽입
	 * 
	 * @param param
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(params="cmd=saveSelectTarget", method = RequestMethod.POST )
	public ModelAndView saveSelectTarget(@RequestBody Map<String, Object> param
							   , HttpSession session) throws Exception {
		Map<String, Object> r = new HashMap<>();
		
		int code = 0;
		String message = "";
		
		Map<String, Object> p = (Map<String, Object>) param.get("p");
		List<Map<String, Object>> rows = (List<Map<String, Object>>) param.get("data");
		
		p.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		p.put("ssnSabun", session.getAttribute("ssnSabun"));
		
		//중복검사
		@SuppressWarnings("serial")
		List<Map<String, Object>> dups = rows.stream().map(row -> new HashMap<String, Object>() {{
			put("ENTER_CD", p.get("ssnEnterCd")); put("PAY_ACTION_CD", p.get("payActionCd")); put("SABUN", row.get("tSabun"));
		}}).collect(Collectors.toList());
		
		int count =  commonCodeService.getDupCnt("TCPN203", "ENTER_CD,PAY_ACTION_CD,SABUN", "s,s,s", dups);
		if (count > 0) {
			code = -1;
			message = "중복된 값이 존재합니다.";
		} else {
			//삽입 작업
			count = payCalculatorService.savePayTarget(p, rows);
			message = count > 0 ? "저장되었습니다.":"저장된 값이 없습니다.";
		}
		
		r.put("Code", code);
		r.put("Message", message);
		
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Result", r);
		
		return mv;
	}
	
	/**
	 * 급여명세서 (NEW)
	 * 
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewPayCalcPopup", method = {RequestMethod.POST, RequestMethod.GET} )
	public String perPayPartiTermNewAStaPopup() throws Exception {
		return "cpn/payData/payCalculator/payCalcPopup";
	}
	
	@RequestMapping(params="cmd=viewPayCalcLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewPayCalcLayer() throws Exception {
		return "cpn/payData/payCalculator/payCalcLayer";
	}
	
	
	/**
	 * 221Popup(세부내역) 팝업 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=payDayMgrPopup", method = RequestMethod.POST )
	public String payDayMgrPopup() throws Exception {
		return "cpn/payCalculate/payDayMgr/payDayMgrPopup";
	}
	@RequestMapping(params="cmd=viewPayDayMgrLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public String payDayMgrLayer() throws Exception {
		return "cpn/payCalculate/payDayMgr/payDayMgrLayer";
	}
	
	/**
	 * (세부내역)  View 전용 화면
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=payDayViewPopup", method = RequestMethod.POST )
	public String payDayViewPopup() throws Exception {
		return "cpn/payCalculate/payDayMgr/payDayViewPopup";
	}
	
	/**
	 * 221Popup(세부내역) 팝업 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewPayDayMgrPop", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewPayDayMgrPop() throws Exception {
		return "cpn/payCalculate/payDayMgr/payDayMgrPop";
	}
	@RequestMapping(params="cmd=viewPayDayMgrLayer2", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewPayDayMgrLayer2() throws Exception {
		return "cpn/payCalculate/payDayMgr/payDayMgrLayer2";
	}

	/**
	 * 221Popup(세부내역) 팝업 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewPayDayChPopup", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewPayDayChPopup() throws Exception {
		return "cpn/payCalculate/payDayMgr/payDayChPopup";
	}
	
	/**
	 * 급여일자 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPayDayMgrList", method = RequestMethod.POST )
	public ModelAndView getPayDayMgrList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}

	/**
	 *  단건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPayDayMgrMap", method = RequestMethod.POST )
	public ModelAndView getPayDayMgrMap(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataMap(session, request, paramMap);
	}

	/**
	 * 221Popup 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPayDayMgrPopList", method = RequestMethod.POST )
	public ModelAndView getPayDayMgrPopList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = payDayMgrService.getPayDayMgrPopList(paramMap);
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
	 * 221Popup 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=savePayDayMgrPop", method = RequestMethod.POST )
	public ModelAndView savePayDayMgrPop(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

		String message = "";
		int resultCnt = -1;
		try{
			resultCnt =payDayMgrService.savePayDayMgrPop(convertMap);
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
	 * 급여일자관리 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(params="cmd=savePayDayMgr", method = RequestMethod.POST )
	public ModelAndView savePayDayMgr(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

		List<Map<String, Object>> insertList = (List<Map<String, Object>>)convertMap.get("insertRows");
		List<Map<String,Object>> dupList = new ArrayList<Map<String,Object>>();


		for(Map<String,Object> mp : insertList) {
			Map<String,Object> dupMap = new HashMap<String,Object>();
			dupMap.put("ENTER_CD",convertMap.get("ssnEnterCd"));
			dupMap.put("PAY_ACTION_CD",mp.get("payActionCd"));

			dupMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
			dupMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

			dupList.add(dupMap);
		}

		String message = "";
		int resultCnt = -1;

		try{
			int dupCnt = 0;

			if(insertList.size() > 0) {
				// 중복체크
				dupCnt = commonCodeService.getDupCnt("TCPN201","ENTER_CD,PAY_ACTION_CD","s,s",dupList);
			}

			if(dupCnt > 0) {
				resultCnt = -1; message="중복된 값이 존재합니다.";
			} else {


				// 급여일자 데이터 입력 및 삭제
				resultCnt =payDayMgrService.savePayDayMgr(convertMap);

				if(resultCnt > 0){ message="저장되었습니다."; }
				else{ message="저장된 내용이 없습니다."; }
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
	 * 221Popup(세부내역) 팝업 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPayDayChPopupList", method = RequestMethod.POST )
	public ModelAndView getPayDayChPopupList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}
	
	
	/**
	 * 기본사항조회 단건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPayCalcCreBasicMap", method = RequestMethod.POST )
	public ModelAndView getPayCalcCreBasicMap(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataMap(session, request, paramMap);
	}

	/**
	 * 대상자 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPayCalcCrePeopleSetList", method = RequestMethod.POST )
	public ModelAndView getPayCalcCrePeopleSetList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}

	/**
	 * 대상자 단건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPayCalcCrePeopleMap", method = RequestMethod.POST )
	public ModelAndView getPayCalcCrePeopleMap(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataMap(session, request, paramMap);
	}

	/**
	 * 마감현황 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPayCalcCreCloseList", method = RequestMethod.POST )
	public ModelAndView getPayCalcCreCloseList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}

	/**
	 * 급여계산 오류확인 팝업 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewPayCalcCreErrorPopup", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewPayCalcCreErrorPopup() throws Exception {
		return "cpn/payCalculate/payCalcCre/payCalcCreErrorPopup";
	}

	/**
	 * 오류 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPayCalcCreErrorList", method = RequestMethod.POST )
	public ModelAndView getPayCalcCreErrorList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}
	
	/**
	 * 급여계산 대상자기준 팝업 급여대상자 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(params="cmd=savePayCalcCrePeopleSet", method = RequestMethod.POST )
	public ModelAndView savePayCalcCrePeopleSet(HttpSession session
											 , HttpServletRequest request
											 , @RequestParam Map<String, Object> paramMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		try {
			Log.DebugStart();
			Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request, paramMap.get("s_SAVENAME").toString(),"");
			convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
			convertMap.put("ssnSabun",session.getAttribute("ssnSabun"));

			List<Map<String, Object>> insertList = (List<Map<String, Object>>) convertMap.get("insertRows");
			List<Map<String, Object>> dupList = new ArrayList<Map<String,Object>>();

			for(Map<String,Object> mp : insertList) {
				Map<String,Object> dupMap = new HashMap<String,Object>();
				dupMap.put("ENTER_CD",convertMap.get("ssnEnterCd"));
				dupMap.put("PAY_ACTION_CD",mp.get("payActionCd"));
				dupMap.put("SABUN",mp.get("sabun"));
				dupList.add(dupMap);
			}

			String message = "";
			int resultCnt = 0;

			try{
				int dupCnt = 0;

				if(insertList.size() > 0) {
					// 중복체크
					dupCnt = commonCodeService.getDupCnt("TCPN203","ENTER_CD,PAY_ACTION_CD,SABUN","s,s,s",dupList);
				}

				if(dupCnt > 0) {
					resultCnt = -1; message="중복된 값이 존재합니다.";
				} else {
					resultCnt = payCalcCreService.savePayCalcCrePeopleSet(convertMap);
					if(resultCnt > 0){ message="저장되었습니다."; } else{ message="저장된 내용이 없습니다."; }
				}
			}catch(Exception e){
				resultCnt = -1; message="저장에 실패하였습니다.";
			}

			Map<String, Object> resultMap = new HashMap<String, Object>();
			resultMap.put("Code", resultCnt);
			resultMap.put("Message", message);
			mv.setViewName("jsonView");
			mv.addObject("Result", resultMap);

			Log.DebugEnd();
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		
		return mv;
	}

	/**
	 * 작업 도중 로그 파일 삭제
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=deleteTSYS904ForPayCalcCre", method = RequestMethod.POST )
	public ModelAndView deleteTSYS904ForPayCalcCre(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		// 열로 된 데이터들을 Map 형태의 연관된 데이터 셋으로 만들기 위해 같이 묶여질 param명을 ,구분자 포함하여 만든다.
		// 파싱할 항목을 , 로 구분하여 스트링형태로 생성
		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		String message = "";
		int resultCnt = 0;

		try{
			resultCnt = payCalcCreService.deleteTSYS904ForPayCalcCre(paramMap);
			if(resultCnt > 0){ message="저장되었습니다."; } else{ message="저장된 내용이 없습니다."; }
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
	 * 급여계산 취소
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=prcP_CPN_CAL_PAY_CANCEL", method = RequestMethod.POST )
	public ModelAndView prcP_CPN_CAL_PAY_CANCEL(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));
		paramMap.put("sabun","");

		Map<?, ?> map = payCalcCreService.prcP_CPN_CAL_PAY_CANCEL(paramMap);

		Log.Debug("map[" + map + "] sqlcode[" + map.get("sqlcode") + "] sqlerrm[" + map.get("sqlerrm") + "]");

		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("Code", "0");

		if (map.get("sqlcode") != null && !"OK".equals(map.get("sqlcode").toString())) {
			resultMap.put("Code", map.get("sqlcode").toString());
			if (map.get("sqlerrm") != null) {
				resultMap.put("Message", map.get("sqlerrm").toString());
			} else {
				resultMap.put("Message", "급여계산 취소 오류입니다.");
			}
		}

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Result", resultMap);

		Log.DebugEnd();
		return mv;
	}

	/**
	 * 상여계산 취소
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=prcP_CPN_BON_PAY_CANCEL", method = RequestMethod.POST )
	public ModelAndView prcP_CPN_BON_PAY_CANCEL(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));
		paramMap.put("sabun","");

		Map<?, ?> map = payCalcCreService.prcP_CPN_BON_PAY_CANCEL(paramMap);

		Log.Debug("map[" + map + "] sqlcode[" + map.get("sqlcode") + "] sqlerrm[" + map.get("sqlerrm") + "]");

		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("Code", "0");

		if (map.get("sqlcode") != null && !"OK".equals(map.get("sqlcode").toString())) {
			resultMap.put("Code", map.get("sqlcode").toString());
			if (map.get("sqlerrm") != null) {
				resultMap.put("Message", map.get("sqlerrm").toString());
			} else {
				resultMap.put("Message", "급여계산 취소 오류입니다.");
			}
		}

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Result", resultMap);

		Log.DebugEnd();
		return mv;
	}

	/**
	 * 개인별 상여계산 취소
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=prcP_CPN_BON_PAY_CANCEL2", method = RequestMethod.POST )
	public ModelAndView prcP_CPN_BON_PAY_CANCEL2(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		Map<?, ?> map = payCalcCreService.prcP_CPN_BON_PAY_CANCEL(paramMap);

		Log.Debug("map[" + map + "] sqlcode[" + map.get("sqlcode") + "] sqlerrm[" + map.get("sqlerrm") + "]");

		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("Code", "0");

		if (map.get("sqlcode") != null && !"OK".equals(map.get("sqlcode").toString())) {
			resultMap.put("Code", map.get("sqlcode").toString());
			if (map.get("sqlerrm") != null) {
				resultMap.put("Message", map.get("sqlerrm").toString());
			} else {
				resultMap.put("Message", "급여계산 취소 오류입니다.");
			}
		}

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Result", resultMap);

		Log.DebugEnd();
		return mv;
	}

	/**
	 * 개인별 급여계산 취소
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=prcP_CPN_CAL_PAY_CANCEL2", method = RequestMethod.POST )
	public ModelAndView prcP_CPN_CAL_PAY_CANCEL2(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		Map<?, ?> map = payCalcCreService.prcP_CPN_CAL_PAY_CANCEL(paramMap);

		Log.Debug("map[" + map + "] sqlcode[" + map.get("sqlcode") + "] sqlerrm[" + map.get("sqlerrm") + "]");

		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("Code", "0");

		if (map.get("sqlcode") != null && !"OK".equals(map.get("sqlcode").toString())) {
			resultMap.put("Code", map.get("sqlcode").toString());
			if (map.get("sqlerrm") != null) {
				resultMap.put("Message", map.get("sqlerrm").toString());
			} else {
				resultMap.put("Message", "급여계산 취소 오류입니다.");
			}
		}

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Result", resultMap);

		Log.DebugEnd();
		return mv;
	}

	/**
	 * 급여계산 대상자기준 팝업 급여대상자 생성
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=prcP_CPN_CAL_EMP_INS", method = RequestMethod.POST )
	public ModelAndView prcP_CPN_CAL_EMP_INS(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));
		paramMap.put("sabun","");

		Map<?, ?> map = payCalcCreService.prcP_CPN_CAL_EMP_INS(paramMap);

		Log.Debug("map[" + map + "] sqlcode[" + map.get("sqlcode") + "] sqlerrm[" + map.get("sqlerrm") + "]");

		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("Code", "0");

		if (map.get("sqlcode") == null || "OK".equals(map.get("sqlcode").toString())) {
			if (map.get("cnt") == null || "0".equals(map.get("cnt").toString())) {
				resultMap.put("Code", "");
				resultMap.put("Message", "생성된 내역이 없습니다.");
			}
		} else {
			resultMap.put("Code", map.get("sqlcode").toString());
			if (map.get("sqlerrm") != null) {
				resultMap.put("Message", map.get("sqlerrm").toString());
			} else {
				resultMap.put("Message", "급여계산 급여대상자 생성 오류입니다.");
			}
		}

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Result", resultMap);

		Log.DebugEnd();
		return mv;
	}
	
	/**
	 * 복리후생연계작업
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=prcP_BEN_PAY_DATA_CREATE_ALL", method = RequestMethod.POST )
	public ModelAndView prcP_BEN_PAY_DATA_CREATE_ALL(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));
		paramMap.put("sabun","");

		Map<?, ?> map = payCalcCreService.prcP_BEN_PAY_DATA_CREATE_ALL(paramMap);

		Log.Debug("map[" + map + "] sqlcode[" + map.get("sqlcode") + "] sqlerrm[" + map.get("sqlerrm") + "]");

		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("Code", "0");

		if (map.get("sqlcode") != null && !"OK".equals(map.get("sqlcode").toString())) {
			resultMap.put("Code", map.get("sqlcode").toString());
			if (map.get("sqlerrm") != null) {
				resultMap.put("Message", map.get("sqlerrm").toString());
			} else {
				resultMap.put("Message", "복리후생연계작업 오류입니다.");
			}
		}

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Result", resultMap);

		Log.DebugEnd();
		return mv;
	}
	
	/**
	 * 급여계산 작업
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=prcP_CPN_CAL_PAY_MAIN", method = RequestMethod.POST )
	public ModelAndView prcP_CPN_CAL_PAY_MAIN(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		Map<String, Object> resultMap = new HashMap<String, Object>();

		try{
			// 20200618 비동기 방식으로 실행
			execPrcAsyncService.execPrc("PayCalcCreProcP_CPN_CAL_PAY_MAIN", paramMap);
			resultMap.put("Code", "0");
			resultMap.put("Message", "급여계산이 실행되었습니다.");
		}catch(Exception e){
			resultMap.put("Code", "");
			resultMap.put("Message", "급여계산 오류입니다.");
		}

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Result", resultMap);

		Log.DebugEnd();
		return mv;
	}

	/**
	 * 상여계산 작업
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=prcP_CPN_BON_PAY_MAIN", method = RequestMethod.POST )
	public ModelAndView prcP_CPN_BON_PAY_MAIN(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		Map<String, Object> resultMap = new HashMap<String, Object>();

		try{
			Map<?, ?> map = payCalcCreProcService.prcP_CPN_BON_PAY_MAIN(paramMap);
			Log.Debug("map[" + map + "] sqlcode[" + map.get("sqlcode") + "] sqlerrm[" + map.get("sqlerrm") + "]");
			resultMap.put("Code", "0");

			if (map.get("sqlcode") != null && !"OK".equals(map.get("sqlcode").toString())) {
				resultMap.put("Code", map.get("sqlcode").toString());
				if (map.get("sqlerrm") != null) {
					resultMap.put("Message", map.get("sqlerrm").toString());
				} else {
					resultMap.put("Message", "급여계산 오류입니다.");
				}
			}
		}catch(Exception e){
			resultMap.put("Code", "");
			resultMap.put("Message", "급여계산 오류입니다.");
		}

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Result", resultMap);

		Log.DebugEnd();
		return mv;
	}

	/**
	 * 급여계산 작업(개인별)
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=prcP_CPN_CAL_PAY_MAIN2", method = RequestMethod.POST )
	public ModelAndView prcP_CPN_CAL_PAY_MAIN2(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		Map<String, Object> resultMap = new HashMap<String, Object>();

		try{
			Map<?, ?> map = payCalcCreProcService.prcP_CPN_CAL_PAY_MAIN2(paramMap);
			Log.Debug("map[" + map + "] sqlcode[" + map.get("sqlcode") + "] sqlerrm[" + map.get("sqlerrm") + "]");
			resultMap.put("Code", "0");

			if (map.get("sqlcode") != null && !"OK".equals(map.get("sqlcode").toString())) {
				resultMap.put("Code", map.get("sqlcode").toString());
				if (map.get("sqlerrm") != null) {
					resultMap.put("Message", map.get("sqlerrm").toString());
				} else {
					resultMap.put("Message", "급여계산 오류입니다.");
				}
			}
		}catch(Exception e){
			resultMap.put("Code", "");
			resultMap.put("Message", "급여계산 오류입니다.");
			Log.Debug(e.getLocalizedMessage());
		}

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Result", resultMap);

		Log.DebugEnd();
		return mv;
	}

	/**
	 * 상여계산 작업(개인별)
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=prcP_CPN_BON_PAY_MAIN2", method = RequestMethod.POST )
	public ModelAndView prcP_CPN_BON_PAY_MAIN2(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		Map<String, Object> resultMap = new HashMap<String, Object>();

		try{
			Map<?, ?> map = payCalcCreProcService.prcP_CPN_BON_PAY_MAIN2(paramMap);
			Log.Debug("map[" + map + "] sqlcode[" + map.get("sqlcode") + "] sqlerrm[" + map.get("sqlerrm") + "]");

			resultMap.put("Code", "0");
			if (map.get("sqlcode") != null && !"OK".equals(map.get("sqlcode").toString())) {
				resultMap.put("Code", map.get("sqlcode").toString());
				if (map.get("sqlerrm") != null) {
					resultMap.put("Message", map.get("sqlerrm").toString());
				} else {
					resultMap.put("Message", "급여계산 오류입니다.");
				}
			}
		}catch(Exception e){
			resultMap.put("Code", "");
			resultMap.put("Message", "급여계산 오류입니다.");
		}

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Result", resultMap);

		Log.DebugEnd();
		return mv;
	}
}
