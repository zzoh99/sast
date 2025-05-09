package com.hr.cpn.personalPay.payPeakTargetMgr;
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
 * 임금피크대상자 Controller 
 * 
 * @author 이름 
 *
 */
@Controller
@RequestMapping(value="/PayPeakTargetMgr.do", method=RequestMethod.POST )
public class PayPeakTargetMgrController {
	
	/**
	 * 임금피크대상자 서비스
	 */
	@Inject
	@Named("PayPeakTargetMgrService")
	private PayPeakTargetMgrService payPeakTargetMgrService;	
	
	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;
	
	@Inject
	@Named("AuthTableService")
	private AuthTableService authTableService;
	
	/**
	 * 임금피크대상자 View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewPayPeakTargetMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewPerElePayAllMgr() throws Exception {
		return "cpn/personalPay/payPeakTargetMgr/payPeakTargetMgr";
	}

	/**
	 * 임금피크대상자 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPayPeakTargetMgrList", method = RequestMethod.POST )
	public ModelAndView getPayPeakTargetMgrList(
				HttpSession session
			,	HttpServletRequest request
			, 	@RequestParam Map<String, Object> paramMap ) throws Exception {
		
		Log.DebugStart();

		paramMap.put("ssnSabun", 		session.getAttribute("ssnSabun"));
		paramMap.put("ssnEnterCd",		session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSearchType", 	session.getAttribute("ssnSearchType"));
		
		List<?> list  	= new ArrayList<Object>();
		String	Message = "";
		
		try {
			Map<?, ?> query = authTableService.getAuthQueryMap(paramMap);
			if(query != null) {
				Log.Debug("query.get=> "+ query.get("query"));
				paramMap.put("query",query.get("query"));
				list = payPeakTargetMgrService.getPayPeakTargetMgrList(paramMap);
			} else {
				Message="조회에 실패하였습니다.";
			}
		} catch(Exception e) {
			Message="조회에 실패하였습니다.";
		}
		
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", 	list);
		mv.addObject("Message", Message);
		
		Log.DebugEnd();
		
		return mv;
	}
	
	/**
	 * 임금피크대상자 단건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPayPeakTargetMgrMap", method = RequestMethod.POST )
	public ModelAndView getPayPeakTargetMgrMap(
				HttpSession session
			,  	HttpServletRequest request
			,	@RequestParam Map<String, Object> paramMap ) throws Exception {
		
		Log.DebugStart();
		
		Map<?, ?> map   = payPeakTargetMgrService.getPayPeakTargetMgrMap(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("map", map);
		
		Log.DebugEnd();
		
		return mv;
	}
	
	/**
	 * 임금피크대상자 저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(params="cmd=savePayPeakTargetMgr", method = RequestMethod.POST )
	public ModelAndView savePayPeakTargetMgr(
				HttpSession session
			,  	HttpServletRequest request
			, 	@RequestParam Map<String, Object> paramMap ) throws Exception {

		// comment 시작
		Log.DebugStart();

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request, paramMap.get("s_SAVENAME").toString(), "");
		convertMap.put("ssnSabun", 	 session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		
		List<Map<String, Object>> insertList = (List<Map<String, Object>>)convertMap.get("insertRows");
		List<Map<String,Object>> dupList = new ArrayList<Map<String,Object>>();
		
		for(Map<String,Object> mp : insertList) {
			Map<String,Object> dupMap = new HashMap<String,Object>();
			dupMap.put("ENTER_CD",	 convertMap.get("ssnEnterCd"));
			dupMap.put("SABUN",		 mp.get("sabun"));
			dupMap.put("PEAK_CD", 	 mp.get("peakCd"));
			dupMap.put("SDATE",		 mp.get("sdate"));
			dupList.add(dupMap);
		}

		String message = "";
		int resultCnt  = -1;
		
		try {
			int dupCnt = 0;

			if(insertList.size() > 0) {
				// 중복체크
				dupCnt = commonCodeService.getDupCnt("TCPN129","ENTER_CD,SABUN,PEAK_CD,SDATE","s,s,s,s", dupList);
			}

			if(dupCnt > 0) {
				resultCnt = -1; 
				message="중복된 값이 존재합니다.";
			} else {
				resultCnt = payPeakTargetMgrService.savePayPeakTargetMgr(convertMap);
				if(resultCnt > 0){ message="저장 되었습니다."; } else{ message="저장된 내용이 없습니다."; }
			}

		} catch(Exception e) {
			resultCnt = -1; message="저장에 실패하였습니다.";
		}
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("Code", 	 resultCnt);
		resultMap.put("Message", message);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Result", 	 resultMap);
		
		Log.DebugEnd();
		
		return mv;
	}
	
	/**
	 * 임금피크대상자생성
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=createPayPeakTarget", method = RequestMethod.POST )
	public ModelAndView createPayPeakTarget(
				HttpSession session
			,  	HttpServletRequest request
			,	@RequestParam Map<String, Object> paramMap ) throws Exception {
		
		Log.DebugStart();
		
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",   session.getAttribute("ssnSabun"));
		
		Map<?, ?> map  = payPeakTargetMgrService.prcCreatePayPeakTarget(paramMap);

		Map<String, Object> resultMap = new HashMap<String, Object>();
		if (map != null) {
			Log.Debug("obj : "+map);
			Log.Debug("sqlcode : "+map.get("sqlcode"));
			Log.Debug("sqlerrm : "+map.get("sqlerrm"));

			if (map.get("sqlcode") != null) {
				resultMap.put("Code", map.get("sqlcode").toString());
			}
			
			if (map.get("sqlerrm") != null) {
				resultMap.put("Message", map.get("sqlerrm").toString());
			}
		}

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Result", resultMap);
		
		Log.DebugEnd();
		
		return mv;
	}
}
