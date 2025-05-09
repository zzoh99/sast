package com.hr.cpn.personalPay.taxRateExceMgr;
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

import com.hr.common.atuhTable.AuthTableService;
import com.hr.common.code.CommonCodeService;
import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;
/**
 * 세율예외자관리 Controller 
 * 
 * @author 이름
 *
 */
@Controller
@RequestMapping(value="/TaxRateExceMgr.do", method=RequestMethod.POST )
public class TaxRateExceMgrController {
	/**
	 * 세율예외자관리 서비스
	 */
	@Inject
	@Named("TaxRateExceMgrService")
	private TaxRateExceMgrService taxRateExceMgrService;
	
	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;
	
	@Inject
	@Named("AuthTableService")
	private AuthTableService authTableService;
	
	/**
	 * 세율예외자관리 View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewTaxRateExceMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewTaxRateExceMgr() throws Exception {
		return "cpn/personalPay/taxRateExceMgr/taxRateExceMgr";
	}
	/**
	 * 세율예외자관리 View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewTaxRateExceMgr2", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewTaxRateExceMgr2() throws Exception {
		return "taxRateExceMgr/taxRateExceMgr";
	}
	/**
	 * 세율예외자관리 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getTaxRateExceMgrList", method = RequestMethod.POST )
	public ModelAndView getTaxRateExceMgrList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSearchType", 	session.getAttribute("ssnSearchType"));
		
		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			Map<?, ?> query = authTableService.getAuthQueryMap(paramMap);
			Log.Debug("query.get=> "+ query.get("query"));
			paramMap.put("query",query.get("query"));

			list = taxRateExceMgrService.getTaxRateExceMgrList(paramMap);
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
	 * 세율예외자관리 단건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getTaxRateExceMgrMap", method = RequestMethod.POST )
	public ModelAndView getTaxRateExceMgrMap(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		Map<?, ?> map = taxRateExceMgrService.getTaxRateExceMgrMap(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("map", map);
		Log.DebugEnd();
		return mv;
	}
	/**
	 * 세율예외자관리 저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(params="cmd=saveTaxRateExceMgr", method = RequestMethod.POST )
	public ModelAndView saveTaxRateExceMgr(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		
		
		List<Map<String, Object>> insertList = (List<Map<String, Object>>) convertMap.get("insertRows");
		List<Map<String, Object>> dupList = new ArrayList<Map<String,Object>>();
		
		for(Map<String,Object> mp : insertList) {
			Map<String,Object> dupMap = new HashMap<String,Object>();
			dupMap.put("ENTER_CD",convertMap.get("ssnEnterCd"));
			dupMap.put("SABUN",mp.get("sabun"));
			dupMap.put("PAY_CD",mp.get("payCd"));
			dupMap.put("SDATE",mp.get("sdate"));
			dupList.add(dupMap);
		}
		
		String message = "";
		int resultCnt = -1;
		
		try{
			int dupCnt = 0;

			if(insertList.size() > 0) {
				// 중복체크
				dupCnt = commonCodeService.getDupCnt("TCPN104","ENTER_CD,SABUN,PAY_CD,SDATE","s,s,s,s",dupList);
			}

			if(dupCnt > 0) {
				resultCnt = -1; message="중복된 값이 존재합니다.";
			} else {
				
				
				
				for(Map<String,Object> mp : insertList) {
					Map<String,Object> updateMap = new HashMap<String,Object>();

					updateMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
					updateMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
					
					updateMap.put("sabun",mp.get("sabun"));
					updateMap.put("sdate",mp.get("sdate"));
					updateMap.put("payCd",mp.get("payCd"));
					taxRateExceMgrService.updateTaxRateExceMgrEdate(updateMap);
				}
				
				
				resultCnt =taxRateExceMgrService.saveTaxRateExceMgr(convertMap);
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

}
