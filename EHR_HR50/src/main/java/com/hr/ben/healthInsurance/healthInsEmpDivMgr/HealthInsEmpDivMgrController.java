package com.hr.ben.healthInsurance.healthInsEmpDivMgr;

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

import com.hr.common.language.LanguageUtil;
import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;

/**
 * HealthInsEmpDivMgr Controller
 *
 * @author EW
 *
 */
@Controller
@RequestMapping(value="/HealthInsEmpDivMgr.do", method=RequestMethod.POST )
public class HealthInsEmpDivMgrController {
	/**
	 * HealthInsEmpDivMgr 서비스
	 */
	@Inject
	@Named("HealthInsEmpDivMgrService")
	private HealthInsEmpDivMgrService healthInsEmpDivMgrService;

	/**
	 * HealthInsEmpDivMgr View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewHealthInsEmpDivMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewHealthInsEmpDivMgr() throws Exception {
		return "ben/healthInsurance/healthInsEmpDivMgr/healthInsEmpDivMgr";
	}

	@RequestMapping(params="cmd=viewHealthInsEmpDivMgrTab1", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewHealthInsEmpDivMgrTab1() throws Exception {
		return "ben/healthInsurance/healthInsEmpDivMgr/healthInsEmpDivMgrTab1";
	}
	
	@RequestMapping(params="cmd=viewHealthInsEmpDivMgrTab2", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewHealthInsEmpDivMgrTab2() throws Exception {
		return "ben/healthInsurance/healthInsEmpDivMgr/healthInsEmpDivMgrTab2";
	}
	
	@RequestMapping(params="cmd=viewHealthInsEmpDivMgrTab3", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewHealthInsEmpDivMgrTab3() throws Exception {
		return "ben/healthInsurance/healthInsEmpDivMgr/healthInsEmpDivMgrTab3";
	}
	
	/**
	 * HealthInsEmpDivMgr 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getHealthInsEmpDivMgrList", method = RequestMethod.POST )
	public ModelAndView getHealthInsEmpDivMgrList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		List<?> list  = new ArrayList<>();
		String Message = "";
		try{
			list = healthInsEmpDivMgrService.getHealthInsEmpDivMgrList(paramMap);
		}catch(Exception e){
			Message = LanguageUtil.getMessage("msg.alertSearchFail2", null, "조회에 실패하였습니다.");
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * HealthInsEmpDivMgr 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveHealthInsEmpDivMgr", method = RequestMethod.POST )
	public ModelAndView saveHealthInsEmpDivMgr(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");

		convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		convertMap.put("searchBaseYmd", paramMap.get("searchBaseYmd").toString());
		
		String message = "";
		int resultCnt = -1;
		try{
			resultCnt = healthInsEmpDivMgrService.saveHealthInsEmpDivMgr(convertMap);
			if(resultCnt > 0){ message = LanguageUtil.getMessage("msg.alertSaveOkV1", null, "저장 되었습니다."); } else{ message = LanguageUtil.getMessage("msg.alertSaveNoData", null, "저장된 내용이 없습니다."); }
		}catch(Exception e){
			resultCnt = -1; message = LanguageUtil.getMessage("msg.alertSaveFail2", null, "저장에 실패하였습니다.");
		}

		Map<String, Object> resultMap = new HashMap<>();
		resultMap.put("Code", resultCnt);
		resultMap.put("Message", message);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Result", resultMap);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * HealthInsEmpDivMgr 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getHealthInsEmpDivMgrList2", method = RequestMethod.POST )
	public ModelAndView getHealthInsEmpDivMgrList2(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		List<?> list  = new ArrayList<>();
		String Message = "";
		try{
			list = healthInsEmpDivMgrService.getHealthInsEmpDivMgrList2(paramMap);
		}catch(Exception e){
			Message = LanguageUtil.getMessage("msg.alertSearchFail2", null, "조회에 실패하였습니다.");
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * HealthInsEmpDivMgr 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveHealthInsEmpDivMgr2", method = RequestMethod.POST )
	public ModelAndView saveHealthInsEmpDivMgr2(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");

		String message = "";
		int resultCnt = -1;
		try{
			resultCnt =healthInsEmpDivMgrService.saveHealthInsEmpDivMgr2(convertMap);
			if(resultCnt > 0){ message = LanguageUtil.getMessage("msg.alertSaveOkV1", null, "저장 되었습니다."); } else{ message = LanguageUtil.getMessage("msg.alertSaveNoData", null, "저장된 내용이 없습니다."); }
		}catch(Exception e){
			resultCnt = -1; message = LanguageUtil.getMessage("msg.alertSaveFail2", null, "저장에 실패하였습니다.");
		}

		Map<String, Object> resultMap = new HashMap<>();
		resultMap.put("Code", resultCnt);
		resultMap.put("Message", message);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Result", resultMap);
		Log.DebugEnd();
		return mv;
	}
	
	/**
	 * HealthInsEmpDivMgr 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getHealthInsEmpDivMgrList3", method = RequestMethod.POST )
	public ModelAndView getHealthInsEmpDivMgrList3(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		List<?> list  = new ArrayList<>();
		String Message = "";
		try{
			list = healthInsEmpDivMgrService.getHealthInsEmpDivMgrList3(paramMap);
		}catch(Exception e){
			Message = LanguageUtil.getMessage("msg.alertSearchFail2", null, "조회에 실패하였습니다.");
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 건강보험 정산자료 분할납부 데이터 생성
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=prcCreateHealthInsEmpDiv", method = RequestMethod.POST )
	public ModelAndView prcCreateHealthInsEmpDiv(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));
		paramMap.put("ssnSearchType",session.getAttribute("ssnSearchType"));
		paramMap.put("ssnGrpCd",session.getAttribute("ssnGrpCd"));

		Map<String, Object> resultMap = new HashMap<>();
		try {
			Map<String, Object> map = healthInsEmpDivMgrService.prcCreateHealthInsEmpDiv(paramMap);

			if (map.get("sqlCode") != null) {
				resultMap.put("Code", map.get("sqlCode").toString());
			}

			if (map.get("sqlErrm") != null) {
				resultMap.put("Message", map.get("sqlErrm").toString());
			} else {
				resultMap.put("Message", "분납생성 되었습니다.");
			}
		} catch(Exception e) {
			resultMap.put("Code", "-1");
			resultMap.put("Message", "분납생성에 실패하였습니다. 담당자에게 문의 바랍니다.");
			Log.Error("분납생성에 실패하였습니다. >> " + e.getLocalizedMessage());
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Result", resultMap);

		Log.DebugEnd();
		return mv;
	}

	/**
	 * 건강보험 연말정산 분할납부 횟수 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getHealthInsEmpDivMgrTab1DivCnt", method = RequestMethod.POST )
	public ModelAndView getHealthInsEmpDivMgrTab1DivCnt(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");

		try {
			mv.addObject("DATA", healthInsEmpDivMgrService.getHealthInsEmpDivMgrTab1DivCnt(paramMap));
			mv.addObject("Message", "");
		} catch(Exception e) {
			mv.addObject("DATA", new HashMap<>());
			mv.addObject("Message", LanguageUtil.getMessage("msg.alertSearchFail2", null, "조회에 실패하였습니다."));
		}

		Log.DebugEnd();
		return mv;
	}
}