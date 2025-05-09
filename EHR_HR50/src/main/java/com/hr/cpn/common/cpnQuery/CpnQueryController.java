package com.hr.cpn.common.cpnQuery;

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
 * 급여 공통쿼리 Controller
 *
 * @author JM
 *
 */
@Controller
@RequestMapping({"/CpnQuery.do", "/PayCalcCre.do", "/PayCalcReCre.do", "/PayCalculator.do", "/RetroEleSetMgr.do", "/RetroExceAllowDedMgr.do"
			   , "/RetroCalcCre.do", "/RetroCalcWorkSta.do", "/RetroToPayMgr.do", "/RetroPersonal.do", "/PayDayChkStd.do", "/PayEleCalcSta.do"
			   , "/PayAggrSta.do", "/WelfarePayDataMgr.do", "/WelfareHisResultMgr.do", "/SepPayEmpMgr.do", "/SepExceMgr.do", "/SepCalcBasicMgr.do", "/SepCalcResultSta.do"
			   , "/SepTaxDefMgr.do", "/SepDcCalcMgr.do", "/SepMonPayMgr.do", "/PayActionSta.do", "/PayPrintSta.do", "/PayPartiPopSta.do", "/GLInterfaceCalMgr.do"
			   , "/StaPenAddBackMgr.do", "/HealthInsAddBackMgr.do", "/PayUploadCal.do", "/FlexPayUpload.do", "/SepWorkDayExceMgr.do"})
public class CpnQueryController {

	/**
	 * 급여 공통쿼리 서비스
	 */
	@Inject
	@Named("CpnQueryService")
	private CpnQueryService cpnQueryService;

	/**
	 * 급여 공통쿼리  조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getCpnQueryList", method = RequestMethod.POST )
	public ModelAndView getCpnQueryList(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		Log.Debug("queryId [" + paramMap.get("queryId").toString() + "]");

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		String procNm = "";
		String Message = "";
		List<?> list = new ArrayList<Object>();

		if (paramMap.get("procNm") != null && !"".equals(paramMap.get("procNm").toString())) {
			procNm = paramMap.get("procNm").toString();
		}

		try{
			list = cpnQueryService.getCpnQueryList(paramMap);
		}catch(Exception e){
			Message = procNm + " 조회에 실패하였습니다.";
		}

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);

		Log.DebugEnd();
		return mv;
	}

	/**
	 * 급여 공통쿼리 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveCpnQuery", method = RequestMethod.POST )
	public ModelAndView saveCpnQuery(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		Log.Debug("queryId [" + paramMap.get("queryId").toString() + "]");

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		String procNm = "마감";
		String message = "";
		int resultCnt = -1;

		if (paramMap.get("procNm") != null && !"".equals(paramMap.get("procNm").toString())) {
			procNm = paramMap.get("procNm").toString();
			if("2".equals(paramMap.get("procNm").toString()) ) {
				procNm = "마감취소" ;
			}
		}

		try{
			resultCnt = cpnQueryService.saveCpnQuery(paramMap);
			if(resultCnt > 0){ message = procNm + " 되었습니다."; } else{ message = procNm + " 처리된 내용이 없습니다."; }
		}catch(Exception e){
			resultCnt = -1; message = procNm + "실패하였습니다.";
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
}