package com.hr.sys.system.requirement.reqDefinitionMgr;
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
 * 요구사항관리 Controller 
 *
 * @author EW
 *
 */
@Controller
@RequestMapping(value="/ReqDefinitionMgr.do", method=RequestMethod.POST )
public class ReqDefinitionMgrController { 
	/**
	 * 요구사항관리 서비스
	 */
	@Inject
	@Named("ReqDefinitionMgrService")
	private ReqDefinitionMgrService reqDefinitionMgrService;
	
	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;

	/**
	 * 요구사항관리 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewReqDefinitionMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewReqDefinitionMgr() throws Exception {
		return "sys/system/requirement/reqDefinitionMgr/reqDefinitionMgr";
	}

	/**
	 * 요구사항관리 팝업 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewReqDefinitionMgrPop", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewReqDefinitionMgrPop() throws Exception {
		return "sys/system/requirement/reqDefinitionMgr/reqDefinitionMgrPop";
	}
	
	@RequestMapping(params="cmd=viewReqDefinitionMgrLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewReqDefinitionMgrLayer() throws Exception {
		return "sys/system/requirement/reqDefinitionMgr/reqDefinitionMgrLayer";
	}
	
	
	/**
	 * 요구사항관리 팝업 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewReqDefinitionMgrPop2", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewReqDefinitionMgrPop2() throws Exception {
		return "sys/system/requirement/reqDefinitionMgr/reqDefinitionMgrPop2";
	}
	/*@RequestMapping(params="cmd=viewReqDefinitionMgrPop", method = {RequestMethod.POST, RequestMethod.GET} )
	public ModelAndView viewReqDefinitionMgrPop(
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
			mv.setViewName("sys/system/requirement/reqDefinitionMgr/reqDefinitionMgrPop");
			mv.addAllObjects(returnMap);
			
			Log.Debug("returnMap : " + returnMap);
			
			
		}catch(Exception e){
			throw new Exception();
		}
		
		return mv;
	}*/

	/**
	 * 요구사항관리 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getReqDefinitionMgrList", method = RequestMethod.POST )
	public ModelAndView getReqDefinitionMgrList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		if(!paramMap.get("multiDevStatusCd").toString().isEmpty())
			paramMap.put( "multiDevStatusCd", ((String) paramMap.get("multiDevStatusCd")).split(","));

		if(!paramMap.get("multiDesignStatusCd").toString().isEmpty())
			paramMap.put( "multiDesignStatusCd", ((String) paramMap.get("multiDesignStatusCd")).split(","));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = reqDefinitionMgrService.getReqDefinitionMgrList(paramMap);
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
	 * 요구사항관리 팝업 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getReqDefinitionMgrPopList", method = RequestMethod.POST )
	public ModelAndView getReqDefinitionMgrPopList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		
		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = reqDefinitionMgrService.getReqDefinitionMgrPopList(paramMap);
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
	 * 요구사항관리 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveReqDefinitionMgr", method = RequestMethod.POST )
	public ModelAndView saveReqDefinitionMgr(
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
			dupMap.put("MODULE_CD",mp.get("moduleCd"));
			dupMap.put("MAIN_MENU_CD",mp.get("mainMenuCd"));
			dupMap.put("MENU_CD",mp.get("menuCd"));
			dupMap.put("MENU_SEQ",mp.get("menuSeq"));
			dupMap.put("GRP_CD",mp.get("grpCd"));
			dupList.add(dupMap);
		}
		
		String message = "";
		int resultCnt = -1;

		try{
			int dupCnt = 0;

			if(insertList.size() > 0) {
				// 중복체크
				dupCnt = commonCodeService.getDupCnt("TSYS800","ENTER_CD,MODULE_CD,MAIN_MENU_CD,MENU_CD,MENU_SEQ,GRP_CD","s,s,s,s,s,s",dupList);
			}

			if(dupCnt > 0) {
				resultCnt = -1; message="중복된 값이 존재합니다.";
			} else {
				resultCnt = reqDefinitionMgrService.saveReqDefinitionMgr(convertMap);
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
	 * 요구사항관리 생성 프로시저
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=procP_SYS_REQ_CRE", method = RequestMethod.POST )
	public ModelAndView procP_SYS_REQ_CRE(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",   session.getAttribute("ssnSabun"));

		Map map  ;
		Map<String, Object> resultMap = new HashMap<String, Object>();

		try{
			map = reqDefinitionMgrService.procP_SYS_REQ_CRE(paramMap);

			if (map.get("sqlCode") != null) {
				resultMap.put("Code", map.get("sqlCode").toString());
			}else{
				resultMap.put("Code", "");
			}
			if (map.get("sqlErrm") != null) {
				resultMap.put("Message", map.get("sqlErrm").toString());
			}else{
				resultMap.put("Message", "생성되었습니다.");
			}
		} catch(Exception e){
			resultMap.put("Code", "ERROR");
			resultMap.put("Message", "처리 중 오류 발생");
		}

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Result", resultMap);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * PL, 개발자 리스트 가져오기
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getReqManagerList", method = RequestMethod.POST )
	public ModelAndView getReqManagerList(HttpSession session, HttpServletRequest request
	            , @RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		List<?> list = new ArrayList<>();
		String message = null;

		try {
		    list = reqDefinitionMgrService.getReqManagerList(paramMap);
		}catch (Exception e) {
		    message = "조회에 실패했습니다.";
		}

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", message);
		Log.DebugEnd();
	    return mv;
	}
}

