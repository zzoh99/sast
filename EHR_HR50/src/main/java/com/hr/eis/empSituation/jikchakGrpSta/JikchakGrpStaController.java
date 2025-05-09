package com.hr.eis.empSituation.jikchakGrpSta;
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
 * jikchakGrpSta Controller
 *
 * @author EW
 *
 */
@Controller
@RequestMapping(value="/JikchakGrpSta.do", method=RequestMethod.POST )
public class JikchakGrpStaController {
	/**
	 * jikchakGrpSta 서비스
	 */
	@Inject
	@Named("JikchakGrpStaService")
	private JikchakGrpStaService jikchakGrpStaService;

	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;

	/**
	 * jikchakGrpSta View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewJikchakGrpSta", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewJikchakGrpSta() throws Exception {
		return "eis/empSituation/jikchakGrpSta/jikchakGrpSta";
	}

	/**
	 * jikchakGrpSta(세부내역) 팝업 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewJikchakGrpStaPop", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewJikchakGrpStaPop() throws Exception {
		return "eis/empSituation/jikchakGrpSta/jikchakGrpStaPop";
	}

	/**
	 * jikchakGrpSta 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getJikchakGrpStaList", method = RequestMethod.POST )
	public ModelAndView getJikchakGrpStaList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = jikchakGrpStaService.getJikchakGrpStaList(paramMap);
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
	 * jikchakGrpStaList2 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getJikchakGrpStaList2", method = RequestMethod.POST )
	public ModelAndView getJikchakGrpStaList2(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = jikchakGrpStaService.getJikchakGrpStaList2(paramMap);
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
	 * jikchakGrpSta 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveJikchakGrpSta", method = RequestMethod.POST )
	public ModelAndView saveJikchakGrpSta(
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
			resultCnt =jikchakGrpStaService.saveJikchakGrpSta(convertMap);
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
	 * jikchakGrpSta 단건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getJikchakGrpStaMap", method = RequestMethod.POST )
	public ModelAndView getJikchakGrpStaMap(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
	
		Map<?, ?> map = null;
		String Message = "";
	
		try{
			map = jikchakGrpStaService.getJikchakGrpStaMap(paramMap);
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
