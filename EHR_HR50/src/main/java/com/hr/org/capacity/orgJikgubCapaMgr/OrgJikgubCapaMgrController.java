package com.hr.org.capacity.orgJikgubCapaMgr;
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

/**
 * orgJikgubCapaMgr Controller
 *
 * @author EW
 *
 */
@Controller
@RequestMapping(value="/OrgJikgubCapaMgr.do", method=RequestMethod.POST )
public class OrgJikgubCapaMgrController {
	/**
	 * orgJikgubCapaMgr 서비스
	 */
	@Inject
	@Named("OrgJikgubCapaMgrService")
	private OrgJikgubCapaMgrService orgJikgubCapaMgrService;

	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;

	/**
	 * orgJikgubCapaMgr View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewOrgJikgubCapaMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewOrgJikgubCapaMgr() throws Exception {
		return "org/capacity/orgJikgubCapaMgr/orgJikgubCapaMgr";
	}

	/**
	 * orgJikgubCapaMgr(세부내역) 팝업 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewOrgJikgubCapaMgrPop", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewOrgJikgubCapaMgrPop() throws Exception {
		return "org/capacity/orgJikgubCapaMgr/orgJikgubCapaMgrPop";
	}

	/**
	 * orgJikgubCapaMgr 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getOrgJikgubCapaMgrList", method = RequestMethod.POST )
	public ModelAndView getOrgJikgubCapaMgrList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = orgJikgubCapaMgrService.getOrgJikgubCapaMgrList(paramMap);
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
	 * orgJikgubCapaMgrSheet1List 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getOrgJikgubCapaMgrSheet1List", method = RequestMethod.POST )
	public ModelAndView getOrgJikgubCapaMgrSheet1List(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = orgJikgubCapaMgrService.getOrgJikgubCapaMgrSheet1List(paramMap);
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
	 * orgJikgubCapaMgrSheet2List 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getOrgJikgubCapaMgrSheet2List", method = RequestMethod.POST )
	public ModelAndView getOrgJikgubCapaMgrSheet2List(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = orgJikgubCapaMgrService.getOrgJikgubCapaMgrSheet2List(paramMap);
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
	 * orgJikgubCapaMgr 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveOrgJikgubCapaMgr", method = RequestMethod.POST )
	public ModelAndView saveOrgJikgubCapaMgr(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		convertMap.put("searchYear",paramMap.get("searchYear"));

		String message = "";
		int resultCnt = -1;
		try{
			resultCnt =orgJikgubCapaMgrService.saveOrgJikgubCapaMgr(convertMap);
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
	 * orgJikgubCapaMgr 단건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getOrgJikgubCapaMgrMap", method = RequestMethod.POST )
	public ModelAndView getOrgJikgubCapaMgrMap(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
	
		Map<?, ?> map = null;
		String Message = "";
	
		try{
			map = orgJikgubCapaMgrService.getOrgJikgubCapaMgrMap(paramMap);
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
	
	/**
	 * 조직별 직급별 현인원 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getNowCnt", method = RequestMethod.POST )
	public ModelAndView getNowCnt(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		Map<?, ?> map = orgJikgubCapaMgrService.getNowCnt(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", map);
		Log.DebugEnd();
		return mv;
	}		
}
