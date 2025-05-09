package com.hr.eis.empSituation.mngYearGrpSta;
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
import com.hr.common.language.LanguageUtil;
import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;
import com.hr.common.util.StringUtil;

/**
 * mngYearGrpSta Controller
 *
 * @author EW
 *
 */
@Controller
@RequestMapping(value="/MngYearGrpSta.do", method=RequestMethod.POST )
public class MngYearGrpStaController {
	/**
	 * mngYearGrpSta 서비스
	 */
	@Inject
	@Named("MngYearGrpStaService")
	private MngYearGrpStaService mngYearGrpStaService;

	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;

	/**
	 * mngYearGrpSta View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewMngYearGrpSta", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewMngYearGrpSta() throws Exception {
		return "eis/empSituation/mngYearGrpSta/mngYearGrpSta";
	}

	/**
	 * mngYearGrpSta(세부내역) 팝업 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewMngYearGrpStaPop", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewMngYearGrpStaPop() throws Exception {
		return "eis/empSituation/mngYearGrpSta/mngYearGrpStaPop";
	}

	/**
	 * mngYearGrpSta1 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getMngYearGrpStaList1", method = RequestMethod.POST )
	public ModelAndView getMngYearGrpStaList1(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = mngYearGrpStaService.getMngYearGrpStaList1(paramMap);
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
	 * mngYearGrpSta2 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getMngYearGrpStaList2", method = RequestMethod.POST )
	public ModelAndView getMngYearGrpStaList2(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		
		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = mngYearGrpStaService.getMngYearGrpStaList2(paramMap);
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
	 * mngYearGrpStaAvgAttYear 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getMngYearGrpStaAvgAttYear", method = RequestMethod.POST )
	public ModelAndView getMngYearGrpStaAvgAttYear(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		
		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = mngYearGrpStaService.getMngYearGrpStaAvgAttYear(paramMap);
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
	 * mngYearGrpSta 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveMngYearGrpSta", method = RequestMethod.POST )
	public ModelAndView saveMngYearGrpSta(
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
			resultCnt =mngYearGrpStaService.saveMngYearGrpSta(convertMap);
			if(resultCnt > 0){ message = LanguageUtil.getMessage("msg.alertSaveOkV1", null, "저장 되었습니다."); } else{ message = LanguageUtil.getMessage("msg.alertSaveNoData", null, "저장된 내용이 없습니다."); }
		}catch(Exception e){
			resultCnt = -1; message = LanguageUtil.getMessage("msg.alertSaveFail2", null, "저장에 실패하였습니다.");
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
	 * mngYearGrpSta 단건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getMngYearGrpStaMap", method = RequestMethod.POST )
	public ModelAndView getMngYearGrpStaMap(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
	
		Map<?, ?> map = null;
		String Message = "";
	
		try{
			map = mngYearGrpStaService.getMngYearGrpStaMap(paramMap);
		}catch(Exception e){
			Message="조회에 실패하였습니다.";
		}
	
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", map);
		mv.addObject("Message", Message);
	
		Log.DebugEnd();
		return mv;
	}
}
