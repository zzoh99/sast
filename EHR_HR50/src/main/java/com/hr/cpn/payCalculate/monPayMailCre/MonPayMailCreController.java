package com.hr.cpn.payCalculate.monPayMailCre;
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
 * 월급여메일발송 Controller
 *
 * @author JSG
 *
 */
@Controller
@RequestMapping(value="/MonPayMailCre.do", method=RequestMethod.POST )
public class MonPayMailCreController {

	/**
	 * 월급여메일발송 서비스
	 */
	@Inject
	@Named("MonPayMailCreService")
	private MonPayMailCreService monPayMailCreService;

	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;

	/**
	 * 월급여메일발송 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewMonPayMailCre", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewMonPayMailCre() throws Exception {
		return "cpn/payCalculate/monPayMailCre/monPayMailCre";
	}



	/**
	 * 1 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getMonPayMailCreList", method = RequestMethod.POST )
	public ModelAndView getMonPayMailCreList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = monPayMailCreService.getMonPayMailCreList(paramMap);
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
	 * 1 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveMonPayMailCre", method = RequestMethod.POST )
	public ModelAndView saveMonPayMailCre(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

		List<Map> insertList = (List<Map>)convertMap.get("insertRows");
		List<Map<String,Object>> dupList = new ArrayList<Map<String,Object>>();

		for(Map<String,Object> mp : insertList) {
			Map<String,Object> dupMap = new HashMap<String,Object>();
			dupMap.put("ENTER_CD",convertMap.get("ssnEnterCd"));
			dupMap.put("WORK_ORG_CD",mp.get("workOrgCd"));
			dupMap.put("SDATE",mp.get("sdate"));
			dupList.add(dupMap);
		}

		String message = "";
		int resultCnt = -1;
		try{
			int dupCnt = 0;

			if(insertList.size() > 0) {
				// 중복검사
				dupCnt = commonCodeService.getDupCnt("TTIM118", "ENTER_CD,WORK_ORG_CD,SDATE", "s,s,s",dupList);
			}

			if(dupCnt > 0) {
				resultCnt = -1; message="중복되어 저장할 수 없습니다.";
			} else {
				resultCnt =monPayMailCreService.saveMonPayMailCre(convertMap);
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
	 * 메일생성 데이터 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getMonPayMailCreHTML1", method = RequestMethod.POST )
	public ModelAndView getMonPayMailCreHTML1(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		
		Log.DebugStart();
		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = monPayMailCreService.getMonPayMailCreHTML1(paramMap);
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
	 * 메일생성 데이터 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getMonPayMailCreHTML2", method = RequestMethod.POST )
	public ModelAndView getMonPayMailCreHTML2(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		
		Log.DebugStart();
		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = monPayMailCreService.getMonPayMailCreHTML2(paramMap);
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
	 * 메일생성 데이터 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getMonPayMailCreHTML3", method = RequestMethod.POST )
	public ModelAndView getMonPayMailCreHTML3(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		
		Log.DebugStart();
		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = monPayMailCreService.getMonPayMailCreHTML3(paramMap);
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
	 * 메일생성 iframe
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=callMonPayMailCreIfrm", method = RequestMethod.POST )
	public String callMonPayMailCreIfrm() throws Exception {
		return "cpn/payCalculate/monPayMailCre/monPayMailCreIfrm";
	}
	
}
