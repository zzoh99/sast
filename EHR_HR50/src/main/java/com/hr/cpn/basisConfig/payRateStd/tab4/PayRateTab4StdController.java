package com.hr.cpn.basisConfig.payRateStd.tab4;
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
 * 급여지급율관리 Controller 
 * 
 * @author 이름
 *
 */
@Controller
@RequestMapping(value="/PayRateTab4Std.do", method=RequestMethod.POST )
public class PayRateTab4StdController {

	/**
	 * 급여지급율관리 서비스
	 */
	@Inject
	@Named("PayRateTab4StdService")
	private PayRateTab4StdService payRateTab4StdService;	
	
	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;
	
	/**
	 * 급여지급율관리 View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewPayRateTab4Std", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewpayRateTab4Std() throws Exception {
		return "cpn/basisConfig/payRateStd/tab4/payRateTab4Std";
	}
	
	/**
	 * 급여지급율관리 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPayRateTab4StdList", method = RequestMethod.POST )
	public ModelAndView getpayRateTab4StdList(
				HttpSession session
			,  	HttpServletRequest request
			, 	@RequestParam Map<String, Object> paramMap ) throws Exception {
		
		paramMap.put("ssnSabun",	session.getAttribute("ssnSabun"));
		paramMap.put("ssnEnterCd",	session.getAttribute("ssnEnterCd"));
		
		Log.DebugStart();
		
		List<?> list  = new ArrayList<Object>();
		String Message = "";
		
		try {
			list = payRateTab4StdService.getPayRateTab4StdList(paramMap);
		} catch(Exception e) {
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
	 * 급여지급율관리 단건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getpayRateTab4StdMap", method = RequestMethod.POST )
	public ModelAndView getpayRateTab4StdMap(
				HttpSession session
			,	HttpServletRequest request
			, 	@RequestParam Map<String, Object> paramMap ) throws Exception {
		
		Log.DebugStart();
		
		Map<?, ?>   map = payRateTab4StdService.getPayRateTab4StdMap(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("map", map);
		
		Log.DebugEnd();
		
		return mv;
	}
	
	/**
	 * 급여지급율관리 저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=savePayRateTab4Std", method = RequestMethod.POST )
	public ModelAndView savepayRateTab4Std(
				HttpSession session
			,	HttpServletRequest request
			, 	@RequestParam Map<String, Object> paramMap ) throws Exception {

		// comment 시작
		Log.DebugStart();

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request, paramMap.get("s_SAVENAME").toString(), "");
		convertMap.put("ssnSabun", 	 session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		
		List<Map> insertList = (List<Map>)convertMap.get("insertRows");
		List<Map<String,Object>> dupList = new ArrayList<Map<String,Object>>();
		
		for(Map<String,Object> mp : insertList) {
			Map<String,Object> dupMap = new HashMap<String,Object>();
			dupMap.put("ssnEnterCd", convertMap.get("ssnEnterCd"));
			dupMap.put("payCd",   mp.get("payCd"));
			dupMap.put("year",   mp.get("year"));
			dupMap.put("PEAK_CD",  mp.get("peakCd"));
			//	dupMap.put("SDATE",    mp.get("sdate"));
			dupList.add(dupMap);
		}
		
		Log.Debug("@@@@@@"+dupList);

		String message = "";
		int  resultCnt = -1;

		try {
			int dupCnt = 0;

			if(insertList.size() > 0) {
				// 중복체크
				Log.Debug("@@@@@@중복체크시작");
				dupCnt = commonCodeService.getDupCnt("TCPN006", "ENTER_CD, PAY_CD, YEAR", "s,s,i", dupList);
				Log.Debug("@@@@@@중복체크종료");
			}

			if(dupCnt > 0) {
				resultCnt = -1; 
				message="중복된 값이 존재합니다.";
			} else {
				resultCnt = payRateTab4StdService.savePayRateTab4Std(convertMap);
				if(resultCnt > 0){ message="저장 되었습니다."; } else{ message="저장된 내용이 없습니다."; }
			}

		} catch(Exception e) {
			resultCnt = -1; message="저장에 실패하였습니다.";
		}
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("Code"   , resultCnt);
		resultMap.put("Message", message);
		
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Result", resultMap);
		
		Log.DebugEnd();
		
		return mv;
	}
}
