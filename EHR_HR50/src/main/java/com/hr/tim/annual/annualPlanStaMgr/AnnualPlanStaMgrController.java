package com.hr.tim.annual.annualPlanStaMgr;
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
 * 연차휴가계획관리 Controller
 *
 * @author bckim
 *
 */
@Controller
@RequestMapping(value="/AnnualPlanStaMgr.do", method=RequestMethod.POST )
public class AnnualPlanStaMgrController {

	/**
	 * 연차휴가계획관리 서비스
	 */
	@Inject
	@Named("AnnualPlanStaMgrService")
	private AnnualPlanStaMgrService annualPlanStaMgrService;

	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;

	/**
	 * annualPlanStaMgr View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewAnnualPlanStaMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewAnnualPlanStaMgr() throws Exception {
		return "tim/annual/annualPlanStaMgr/annualPlanStaMgr";
	}
	
	/**
	 * 
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveAnnualPlanStaMgr", method = RequestMethod.POST )
	public ModelAndView saveAnnualPlanStaMgr(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

		List<Map> insertList = (List<Map>)convertMap.get("insertRows");
		List<Map<String,Object>> dupList = new ArrayList<Map<String,Object>>();

		for(Map<String,Object> mp : insertList) {
			Map<String,Object> dupMap = new HashMap<String,Object>();
			dupMap.put("ENTER_CD",convertMap.get("ssnEnterCd"));
			dupMap.put("SABUN",mp.get("sabun"));
			dupMap.put("SEQ",mp.get("seq"));
			dupMap.put("SDATE",mp.get("sdate"));
			dupList.add(dupMap);
		}

		String message = "";
		int resultCnt = -1;
		try{
			int dupCnt = 0;

			if(insertList.size() > 0) {
				// 중복검사
				dupCnt = commonCodeService.getDupCnt("TTIM542", "ENTER_CD,SABUN,SEQ,SDATE", "s,s,s,s",dupList);
			}

			if(dupCnt > 0) {
				resultCnt = -1; message="중복되어 저장할 수 없습니다.";
			} else {
				resultCnt = annualPlanStaMgrService.saveAnnualPlanStaMgr(convertMap);
				if(resultCnt > 0){ message="저장되었습니다."; } else{ message="저장된 내용이 없습니다."; }
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
	 * 확정처리
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveAnnualPlanStaMgrConfirm", method = RequestMethod.POST )
	public ModelAndView saveAnnualPlanStaMgrConfirm(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		
		String getParamNames ="sNo,sStatus,vSeq,sabun";
		
		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,getParamNames,"");
		convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		convertMap.put("vSeq", request.getParameter("vSeq"));
		//Log.Debug("***************************  "+ request.getParameter("vSeq"));
		//Log.Debug("***************************  "+convertMap.get("vSeq").toString());
		//Log.Debug("***************************  "+convertMap.get("sabun").toString());
		
		String message = "";
		Map map = null;
		Map<String, Object> resultMap = new HashMap<String, Object>();
		try{
			map = annualPlanStaMgrService.saveAnnualPlanStaMgrConfirm(convertMap);
			if(map == null){ 
				resultMap.put("Code", -1);
				message="확정 처리된 내용이 없습니다."; 
			} 
			else{ 
				message="확정 처리되었습니다.";
				resultMap.put("Code", 0);
			}
		}catch(Exception e){
			resultMap.put("Code", -1);
			message = "확정 처리도중 에러가 발생하였습니다.";
		} 
		
		if (map!=null && map.get("sqlCode") != null) {
			resultMap.put("sqlCode", map.get("sqlCode").toString());
		}
		if (map!=null && map.get("sqlErrm") != null) {
			resultMap.put("sqlErrm", map.get("sqlErrm").toString());
		}
		resultMap.put("Message", message);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Result", resultMap);
		Log.DebugEnd();
		return mv;
	}
	
	/**
	 * annualPlanStaMgr 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAnnualPlanStaMgrList", method = RequestMethod.POST )
	public ModelAndView getAnnualPlanStaMgrList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = annualPlanStaMgrService.getAnnualPlanStaMgrList(paramMap);
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
	 * annualPlanStaMgr 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAnnualPlanStaMgrList2", method = RequestMethod.POST )
	public ModelAndView getAnnualPlanStaMgrList2(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = annualPlanStaMgrService.getAnnualPlanStaMgrList2(paramMap);
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
