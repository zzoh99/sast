package com.hr.tim.annual.annualPlanAppDet;
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
import com.hr.common.util.ParamUtils;

/**
 * 연차휴가계획신청신청 Controller
 *
 * @author bckim
 *
 */
@Controller
@RequestMapping({"/AnnualPlanApp.do","/AnnualPlanAppDet.do"})
public class AnnualPlanAppDetController {

	/**
	 * 연차휴가계획신청신청 서비스
	 */
	@Inject
	@Named("AnnualPlanAppDetService")
	private AnnualPlanAppDetService annualPlanAppDetService;

	/**
	 * 연차휴가계획신청신청 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewAnnualPlanAppDet", method = {RequestMethod.POST, RequestMethod.GET} )
	public ModelAndView viewAnnualPlanAppDet(HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		
		//휴가계획기준 조회
		mv.addObject("annualPlanStandardLast", annualPlanAppDetService.getAnnualPlanStandardLast(paramMap));
		
		//mv.addObject("annualPlanAppDetInfo", annualPlanAppDetService.getAnnualPlanAppDetInfo(paramMap));
		
		mv.setViewName("tim/annual/annualPlanAppDet/annualPlanAppDet");
		return mv;
	}

	@RequestMapping(params="cmd=getAnnualPlanAppDetMap", method = RequestMethod.POST )
	public ModelAndView getAnnualPlanAppDetMap(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		Map<?, ?> map = annualPlanAppDetService.getAnnualPlanAppDetMap(paramMap);


		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("map", map);
		Log.DebugEnd();
		return mv;
	}
	/**
	 * 연차휴가계획신청신청 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAnnualPlanAppDetList", method = RequestMethod.POST )
	public ModelAndView getAnnualPlanAppDetList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
 
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		
		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = annualPlanAppDetService.getAnnualPlanAppDetList(paramMap);

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
	 * 연차휴가계획신청팝업 중복 체크  조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAnnualPlanAppDetDupCheck", method = RequestMethod.POST )
	public ModelAndView getAnnualPlanAppDetDupCheck(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		
		Map datamap  = new HashMap();
		String Message = "";
		try{
			datamap = annualPlanAppDetService.getAnnualPlanAppDetDupCheck(paramMap);
			
		}catch(Exception e){
			Message=e.getMessage();
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", datamap);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 연차휴가계획신청팝업 중복 체크  조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAnnualPlanAppDetAbleCheck", method = RequestMethod.POST )
	public ModelAndView getAnnualPlanAppDetAbleCheck(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		
		Map datamap  = new HashMap();
		String Message = "";
		try{
			datamap = annualPlanAppDetService.getAnnualPlanAppDetAbleCheck(paramMap);
			
		}catch(Exception e){
			Message=e.getMessage();
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", datamap);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}
	
	
	/**
	 * 연차계획기준에 따른 연차일수 정보가져오기
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAnnualPlanInfo", method = RequestMethod.POST )
	public ModelAndView getAnnualPlanInfo(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		
		Map datamap  = new HashMap();
		String Message = "";
		try{
			datamap = annualPlanAppDetService.getAnnualPlanInfo(paramMap);
			
		}catch(Exception e){
			Message=e.getMessage();
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", datamap);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}
	
	
	/**
	 * 연차계획기준 중복 체크 
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAnnualPlanAppDetPreAppliedPlan", method = RequestMethod.POST )
	public ModelAndView getAnnualPlanAppDetPreAppliedPlan(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));

		Map<String, Object> datamap  = new HashMap<>();
		String Message = "";
		try {
			datamap = annualPlanAppDetService.getAnnualPlanAppDetPreAppliedPlan(paramMap);
		} catch(Exception e) {
			Message = "조회에 실패하였습니다.";
			Log.Error(Message + " => " + e.getLocalizedMessage());
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", datamap);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}
	
	/**
	 *  연차휴가계획신청신청  저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveAnnualPlanAppDet", method = RequestMethod.POST )
	public ModelAndView saveAnnualPlanAppDet(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		String getParamNames ="sNo,sDelete,sStatus,seq,sdate,edate,days,note,sabun,applSeq";
  
		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,getParamNames,"");
		convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

		String message = "";
		int resultCnt = -1;
		try{
			resultCnt = annualPlanAppDetService.saveAnnualPlanCnt(paramMap);
			resultCnt = annualPlanAppDetService.saveAnnualPlanAppDet(convertMap);
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
	
	
	
	
}
