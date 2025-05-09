package com.hr.sys.system.requirement.reqDefinitionPopMgr;
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
import com.hr.sys.system.requirement.reqDefinitionMgr.ReqDefinitionMgrService;

/**
 * 테스트관리 Controller
 *
 * @author EW
 * 
 */
@Controller
@RequestMapping(value="/ReqDefinitionPopMgr.do", method=RequestMethod.POST )
public class ReqDefinitionPopMgrController {
	/**
	 * 테스트관리 서비스
	 */
	@Inject
	@Named("ReqDefinitionPopMgrService")
	private ReqDefinitionPopMgrService reqDefinitionPopMgrService;
	
	/**
	 * 테스트관리 서비스
	 */
	@Inject
	@Named("ReqDefinitionMgrService")
	private ReqDefinitionMgrService reqDefinitionMgrService;

	/**
	 * 테스트관리 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewReqDefinitionPopMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewReqDefinitionPopMgr() throws Exception {
		return "sys/system/requirement/reqDefinitionPopMgr/reqDefinitionPopMgr";
	}
	/*
	@RequestMapping(params="cmd=viewReqDefinitionPopMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public ModelAndView viewReqDefinitionPopMgr(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		
		ModelAndView mv = new ModelAndView();
		Map<String, Object> returnMap = new HashMap<String, Object>();
		Map<?, ?> map = new HashMap<String, Object>();
		
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnGrpCd", session.getAttribute("ssnGrpCd"));
		
		try{
			
			returnMap = paramMap;
			map = reqDefinitionMgrService.getReqDefinitionMgrPopErrorAccYnMap(paramMap);
			returnMap.put("grpYn", map.get("grpYn"));
			mv.setViewName("sys/system/requirement/reqDefinitionPopMgr/reqDefinitionPopMgr");
			mv.addAllObjects(returnMap);
			
			Log.Debug("returnMap : " + returnMap);
			
			
		}catch(Exception e){
			throw new Exception();
		}
		
		return mv;
	}
*/
	/**
	 * 테스트관리(세부내역) 팝업 View
	 *
	 * @return String
	 * @throws Exception
	 */
/*	@RequestMapping(params="cmd=viewReqDefinitionPopMgrPop", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewReqDefinitionPopMgrPop() throws Exception {
		return "sys/system/requirement/reqDefinitionPopMgr/reqDefinitionPopMgrPop";
	}*/

	/**
	 * 테스트관리 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getReqDefinitionPopMgrList", method = RequestMethod.POST )
	public ModelAndView getReqDefinitionPopMgrList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = reqDefinitionPopMgrService.getReqDefinitionPopMgrList(paramMap);
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
	 * 테스트관리 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveReqDefinitionPopMgr", method = RequestMethod.POST )
	public ModelAndView saveReqDefinitionPopMgr(
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
			resultCnt =reqDefinitionPopMgrService.saveReqDefinitionPopMgr(convertMap);
			if(resultCnt > 0){ message="저장 되었습니다."; } else{ message="저장된 내용이 없습니다."; }
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

