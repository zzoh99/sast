package com.hr.cpn.payRetire.annualIncomeTable;
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
 * 연간소득현황 Controller
 *
 * @author EW
 *
 */
@Controller
@RequestMapping(value="/AnnualIncomeTable.do", method=RequestMethod.POST )
public class AnnualIncomeTableController {
	/**
	 * 연간소득현황 서비스
	 */
	@Inject
	@Named("AnnualIncomeTableService")
	private AnnualIncomeTableService annualIncomeTableService;

	/**
	 * 연간소득현황 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewAnnualIncomeTable", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewAnnualIncomeTable() throws Exception {
		return "cpn/payRetire/annualIncomeTable/annualIncomeTable";
	}

	/**
	 * 연간소득현황(세부내역) 팝업 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewAnnualIncomeTablePop", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewAnnualIncomeTablePop() throws Exception {
		return "cpn/payRetire/annualIncomeTable/annualIncomeTablePop";
	}

	/**
	 * 연간소득현황 헤더 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAnnualIncomeTableHeaderList", method = RequestMethod.POST )
	public ModelAndView getAnnualIncomeTableHeaderList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = annualIncomeTableService.getAnnualIncomeTableHeaderList(paramMap);
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
	 * 연간소득현황 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAnnualIncomeTableList", method = RequestMethod.POST )
	public ModelAndView getAnnualIncomeTableList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		List<?> headerList  = new ArrayList<Object>();
		List<?> list  = new ArrayList<Object>();

		String querySelect = "";
		String Message = "";
		try{

			// headerList = annualIncomeTableService.getAnnualIncomeTableHeaderList(paramMap);
			headerList = annualIncomeTableService.getAnnualIncomeCodeList(paramMap);

			if ( headerList.size() > 0) {
				for ( int i = 0 ; i < headerList.size() ; i++ ){

					String code = (String) ((Map<String, Object>) headerList.get(i)).get("code");
					//querySelect = querySelect + (",SUM(DECODE(D.CODE, '"+code+"', D.MON)) AS "+code);
					
					querySelect += (",SUM((SELECT SUM(DECODE(ADJ_ELEMENT_CD,'"+code+"', TAX_MON)) FROM TCPN815 WHERE ENTER_CD = A.ENTER_CD AND SABUN = A.SABUN AND WORK_YY = A.WORK_YY AND ADJUST_TYPE = A.ADJUST_TYPE AND YM = A.YM)) AS "+code+"_TAX\n");
					querySelect += (",SUM((SELECT SUM(DECODE(ADJ_ELEMENT_CD,'"+code+"', NOTAX_MON)) FROM TCPN815 WHERE ENTER_CD = A.ENTER_CD AND SABUN = A.SABUN AND WORK_YY = A.WORK_YY AND ADJUST_TYPE = A.ADJUST_TYPE AND YM = A.YM)) AS "+code+"_NOTAX\n");
				}
				Log.Debug("querySelect : " + querySelect);

			}
			paramMap.put("querySelect", querySelect);

			list = annualIncomeTableService.getAnnualIncomeTableList(paramMap);
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
}

