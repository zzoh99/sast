package com.hr.ben.benefitBasis.natiPenRatioMgr;
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
 * natiPenRatioMgr Controller
 *
 * @author EW
 *
 */
@Controller
@RequestMapping({"/NatiPenRatioMgr.do", "/SocInsRatesMgr.do"})
public class NatiPenRatioMgrController {
	/**
	 * natiPenRatioMgr 서비스
	 */
	@Inject
	@Named("NatiPenRatioMgrService")
	private NatiPenRatioMgrService natiPenRatioMgrService;

	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;

	/**
	 * natiPenRatioMgr View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewNatiPenRatioMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewNatiPenRatioMgr() throws Exception {
		return "ben/benefitBasis/natiPenRatioMgr/natiPenRatioMgr";
	}

	/**
	 * natiPenRatioMgr(세부내역) 팝업 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewNatiPenRatioMgrPop", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewNatiPenRatioMgrPop() throws Exception {
		return "ben/benefitBasis/natiPenRatioMgr/natiPenRatioMgrPop";
	}

	/**
	 * natiPenRatioMgr 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getNatiPenRatioMgrList", method = RequestMethod.POST )
	public ModelAndView getNatiPenRatioMgrList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = natiPenRatioMgrService.getNatiPenRatioMgrList(paramMap);
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
	 * natiPenRatioMgr 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveNatiPenRatioMgr", method = RequestMethod.POST )
	public ModelAndView saveNatiPenRatioMgr(
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
			resultCnt =natiPenRatioMgrService.saveNatiPenRatioMgr(convertMap);
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
	 * natiPenRatioMgr 단건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getNatiPenRatioMgrMap", method = RequestMethod.POST )
	public ModelAndView getNatiPenRatioMgrMap(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
	
		Map<?, ?> map = null;
		String Message = "";
	
		try{
			map = natiPenRatioMgrService.getNatiPenRatioMgrMap(paramMap);
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
