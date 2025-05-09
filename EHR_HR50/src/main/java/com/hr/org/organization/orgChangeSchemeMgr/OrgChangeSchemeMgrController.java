package com.hr.org.organization.orgChangeSchemeMgr;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
/**
 * 조직도관리 Controller
 *
 * @author CBS
 *
 */
@Controller
@RequestMapping(value="/OrgChangeSchemeMgr.do", method=RequestMethod.POST )
public class OrgChangeSchemeMgrController {
	/**
	 * 조직도관리 서비스
	 */
	@Inject
	@Named("OrgChangeSchemeMgrService")
	private OrgChangeSchemeMgrService orgChangeSchemeMgrService;

	
	/**
	 * 조직도시뮬레이션 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewOrgChangeSchemeMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewOrgChangeSchemeMgr() throws Exception {
		return "org/organization/orgChangeSchemeMgr/orgChangeSchemeMgr";
	}

	/**
	 * 조직도시뮬레이션 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getOrgChangeSchemeMgrList", method = RequestMethod.POST )
	public ModelAndView getOrgChangeSchemeMgrList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = orgChangeSchemeMgrService.getOrgChangeSchemeMgrList(paramMap);
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
	 * 조직도시뮬레이션 가발령적용 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getOrgChangeSchemeMgrList2", method = RequestMethod.POST )
	public ModelAndView getOrgChangeSchemeMgrList2(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = orgChangeSchemeMgrService.getOrgChangeSchemeMgrList2(paramMap);
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
	 * 조직도시뮬레이션 정보 단건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getSchemeSimulationInfo", method = RequestMethod.POST )
	public ModelAndView getSchemeSimulationInfo(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
	
		Map<?, ?> map = null;
		String Message = "";
	
		try{
			map = orgChangeSchemeMgrService.getSchemeSimulationInfo(paramMap);
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
	 * 신규조직 중복체크
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getSchemeSimulationOrgExistOrgCd", method = RequestMethod.POST )
	public ModelAndView getSchemeSimulationOrgExistOrgCd(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
	
		Map<?, ?> map = null;
		String Message = "";
	
		try{
			map = orgChangeSchemeMgrService.getSchemeSimulationOrgExistOrgCd(paramMap);
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
	 * 조직 목록 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getSchemeSimulationEmpOrgList", method = RequestMethod.POST )
	public ModelAndView getSchemeSimulationEmpOrgList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = orgChangeSchemeMgrService.getSchemeSimulationEmpOrgList(paramMap);
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
	 * 소속조직원 목록 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getSchemeSimulationEmpMemberList", method = RequestMethod.POST )
	public ModelAndView getSchemeSimulationEmpMemberList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = orgChangeSchemeMgrService.getSchemeSimulationEmpMemberList(paramMap);
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
	 * 조직이동대상자 목록 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getSchemeSimulationEmpIndependentMemberList", method = RequestMethod.POST )
	public ModelAndView getSchemeSimulationEmpIndependentMemberList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = orgChangeSchemeMgrService.getSchemeSimulationEmpIndependentMemberList(paramMap);
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
	 * 검색 목록 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getSchemeSimulationEmpMemberSearchList", method = RequestMethod.POST )
	public ModelAndView getSchemeSimulationEmpMemberSearchList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = orgChangeSchemeMgrService.getSchemeSimulationEmpMemberSearchList(paramMap);
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
	 * 조직버전 목록 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getOrgVerComboList", method = RequestMethod.POST )
	public ModelAndView getOrgVerComboList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = orgChangeSchemeMgrService.getOrgVerComboList(paramMap);
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
	 * 조직도 데이터를 불러오기 위한
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getOrgView", method = RequestMethod.POST )
	public ModelAndView getOrgView(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		List<?> list  = new ArrayList<Object>();
		String Message = "";

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

		try{
			list = orgChangeSchemeMgrService.getOrgView(paramMap);
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
	 * 최종확인 조직도 목록 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getSchemeSimulationOrgCurLastTreeList", method = RequestMethod.POST )
	public ModelAndView getSchemeSimulationOrgCurLastTreeList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = orgChangeSchemeMgrService.getSchemeSimulationOrgCurLastTreeList(paramMap);
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
	 * 확정존재여부 정보 단건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getChkConfYn", method = RequestMethod.POST )
	public ModelAndView getChkConfYn(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
	
		Map<?, ?> map = null;
		String Message = "";
	
		try{
			map = orgChangeSchemeMgrService.chkConfYn(paramMap);
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
	 * 가발령정보 사용 유무 정보 단건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getChkApplyYn", method = RequestMethod.POST )
	public ModelAndView chkApplyYn(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
	
		Map<?, ?> map = null;
		String Message = "";
	
		try{
			map = orgChangeSchemeMgrService.chkApplyYn(paramMap);
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
	 * 조직변경 목록 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getSchemeSimulationReOrgList1", method = RequestMethod.POST )
	public ModelAndView getSchemeSimulationReOrgList1(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = orgChangeSchemeMgrService.getSchemeSimulationReOrgList1(paramMap);
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
	 * 조직장변경 목록 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getSchemeSimulationReOrgList2", method = RequestMethod.POST )
	public ModelAndView getSchemeSimulationReOrgList2(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = orgChangeSchemeMgrService.getSchemeSimulationReOrgList2(paramMap);
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
	 * 인사이동 목록 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getSchemeSimulationReOrgList3", method = RequestMethod.POST )
	public ModelAndView getSchemeSimulationReOrgList3(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = orgChangeSchemeMgrService.getSchemeSimulationReOrgList3(paramMap);
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
	 * 조직콤보 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getOrgComboList", method = RequestMethod.POST )
	public ModelAndView getOrgComboList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = orgChangeSchemeMgrService.getOrgComboList(paramMap);
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
	 * 조직개편 버전관리 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getOrgChangeVerMgrList", method = RequestMethod.POST )
	public ModelAndView getOrgChangeVerMgrList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = orgChangeSchemeMgrService.getOrgChangeVerMgrList(paramMap);
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
	 * 조직개편관리 정보 저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveOrgChangeSchemeMgr", method = RequestMethod.POST )
	public ModelAndView saveOrgChangeSchemeMgr(
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
			
			resultCnt = orgChangeSchemeMgrService.saveOrgChangeSchemeMgr(convertMap);
			if(resultCnt > 0){
				message="저장되었습니다.";
			} else{
				message="저장된 내용이 없습니다.";
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
	 * 조직개편관리 가발령관리 정보 저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveOrgChangeSchemeMgr2", method = RequestMethod.POST )
	public ModelAndView saveOrgChangeSchemeMgr2(
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
			
			resultCnt = orgChangeSchemeMgrService.saveOrgChangeSchemeMgr2(convertMap);
			if(resultCnt > 0){
				message="저장되었습니다.";
			} else{
				message="저장된 내용이 없습니다.";
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
	 * 조직개편 버전 정보 저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveOrgChangeVerMgrList", method = RequestMethod.POST )
	public ModelAndView saveOrgChangeVerMgrList(
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
			
			resultCnt = orgChangeSchemeMgrService.saveOrgChangeVerMgrList(convertMap);
			if(resultCnt > 0){
				message="저장되었습니다.";
			} else{
				message="저장된 내용이 없습니다.";
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
	 * 조직도 복사 작업
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=callPrcCopyOrgView", method = RequestMethod.POST )
	public ModelAndView callPrcCopyOrgView(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("chkid", session.getAttribute("ssnSabun"));

		Map map = orgChangeSchemeMgrService.callPrcCopyOrgView(paramMap);

		Log.Debug("map[" + map + "] sqlcode[" + map.get("sqlcode") + "] sqlerrm[" + map.get("sqlerrm") + "]");

		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("Code", "0");

		if (map.get("sqlcode") == null || "OK".equals(map.get("sqlcode").toString())) {
			if (map.get("cnt") == null || "0".equals(map.get("cnt").toString())) {
				resultMap.put("Code", "");
				resultMap.put("Message", "복사할 내역이 없습니다.");
			}
		} else {
			resultMap.put("Code", map.get("sqlcode").toString());
			if (map.get("sqlerrm") != null) {
				resultMap.put("Message", map.get("sqlerrm").toString());
			} else {
				resultMap.put("Message", "조직도 복사 오류입니다.");
			}
		}

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Result", resultMap);

		Log.DebugEnd();
		return mv;
	}

	/**
	 * 조직 버전 복사 작업
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=callPrcCopyOrgVersion", method = RequestMethod.POST )
	public ModelAndView callPrcCopyOrgVersion(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("chkid", session.getAttribute("ssnSabun"));

		Map map = orgChangeSchemeMgrService.callPrcCopyOrgVersion(paramMap);

		Log.Debug("map[" + map + "] sqlcode[" + map.get("sqlcode") + "] sqlerrm[" + map.get("sqlerrm") + "]");

		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("Code", "0");

		if (map.get("sqlcode") == null || "OK".equals(map.get("sqlcode").toString())) {
			resultMap.put("Message", "조직도 복사가 완료 되었습니다.");
		} else {
			resultMap.put("Code", map.get("sqlcode").toString());
			if (map.get("sqlerrm") != null) {
				resultMap.put("Message", map.get("sqlerrm").toString());
			} else {
				resultMap.put("Message", "조직 버전 복사 오류입니다.");
			}
		}

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Result", resultMap);

		Log.DebugEnd();
		return mv;
	}

	/**
	 * 가발령적용 작업
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=callPrcOrgSimulAppmtApply", method = RequestMethod.POST )
	public ModelAndView callPrcOrgSimulAppmtApply(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));

		Map map = orgChangeSchemeMgrService.callPrcOrgSimulAppmtApply(paramMap);

		Log.Debug("map[" + map + "] sqlcode[" + map.get("sqlcode") + "] sqlerrm[" + map.get("sqlerrm") + "]");

		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("Code", "0");

		if (map.get("sqlcode") == null || "OK".equals(map.get("sqlcode").toString())) {
			resultMap.put("Message", "가발령처리가 완료 되었습니다.");
		} else {
			resultMap.put("Code", map.get("sqlcode").toString());
			if (map.get("sqlerrm") != null) {
				resultMap.put("Message", map.get("sqlerrm").toString());
			} else {
				resultMap.put("Message", "가발령 적용 오류입니다.");
			}
		}

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Result", resultMap);

		Log.DebugEnd();
		return mv;
	}
	

	/**
	 * 조직 최종확인 및 진행 호출
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=callPrcOrgApplyReorg", method = RequestMethod.POST )
	public ModelAndView callPrcOrgApplyReorg(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));

		Map map = orgChangeSchemeMgrService.callPrcOrgApplyReorg(paramMap);

		Log.Debug("map[" + map + "] sqlcode[" + map.get("sqlcode") + "] sqlerrm[" + map.get("sqlerrm") + "]");

		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("Code", "0");

		if (map.get("sqlcode") == null || "OK".equals(map.get("sqlcode").toString())) {
			resultMap.put("Message", "최종 적용 되었습니다.");
		} else {
			resultMap.put("Code", map.get("sqlcode").toString());
			if (map.get("sqlerrm") != null) {
				resultMap.put("Message", map.get("sqlerrm").toString());
			} else {
				resultMap.put("Message", "최종 적용 오류입니다.");
			}
		}

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Result", resultMap);

		Log.DebugEnd();
		return mv;
	}
	
	
	/**
	 * 조직이동 대상자 정보 저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveSchemeSimulationEmp", method = RequestMethod.POST )
	public ModelAndView saveSchemeSimulationEmp(
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
			
			resultCnt = orgChangeSchemeMgrService.saveSchemeSimulationEmp(convertMap);
			if(resultCnt > 0){
				message="저장되었습니다.";
			} else{
				message="저장된 내용이 없습니다.";
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
	 * 조직 버전 확정 작업
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=compOrg", method = RequestMethod.POST )
	public ModelAndView compOrg(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

		int result = 0;
		String Message = "";

		try {
			result = orgChangeSchemeMgrService.compOrg(paramMap);
		} catch (Exception e) {
			Message="조직도 확정을 실패하였습니다.";
		}

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("CNT", result);
		mv.addObject("Message", Message);

		Log.DebugEnd();
		return mv;
	}

	/**
	 * 조직 버전 확정 취소 작업
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=cancelCompOrg", method = RequestMethod.POST )
	public ModelAndView cancelCompOrg(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

		int result = 0;
		String Message = "";

		try {
			result = orgChangeSchemeMgrService.cancelCompOrg(paramMap);
		} catch (Exception e) {
			Message="조직도 확정취소를 실패하였습니다.";
		}

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("CNT", result);
		mv.addObject("Message", Message);

		Log.DebugEnd();
		return mv;
	}

	/**
	 * 조직 버전 마감 작업
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=callPrcChgConpVer", method = RequestMethod.POST )
	public ModelAndView callPrcChgConpVer(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("chkid", session.getAttribute("ssnSabun"));

		Map map = orgChangeSchemeMgrService.callPrcChgConpVer(paramMap);

		Log.Debug("map[" + map + "] sqlcode[" + map.get("sqlcode") + "] sqlerrm[" + map.get("sqlerrm") + "]");

		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("Code", "0");

		if (map.get("sqlcode") == null || "OK".equals(map.get("sqlcode").toString())) {
			if (map.get("cnt") == null || "0".equals(map.get("cnt").toString())) {
				resultMap.put("Code", "");
				resultMap.put("Message", "마감할 내역이 없습니다.");
			}
		} else {
			resultMap.put("Code", map.get("sqlcode").toString());
			if (map.get("sqlerrm") != null) {
				resultMap.put("Message", map.get("sqlerrm").toString());
			} else {
				resultMap.put("Message", "조직 버전 마감 오류입니다.");
			}
		}

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Result", resultMap);

		Log.DebugEnd();
		return mv;
	}

	/**
	 * 조직개편 시뮬레이션 POPUP
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewSchemeSimulationLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public ModelAndView viewSchemeSimulationLayer(HttpSession session, @RequestParam Map<String, Object> paramMap,
			HttpServletRequest request) throws Exception {
		Log.DebugStart();
		Log.Debug("data == [" + paramMap + "]");
		ObjectMapper obj = new ObjectMapper();
		Log.Debug("paramMap = " + obj.writeValueAsString(paramMap));

		ModelAndView mv = new ModelAndView();

		mv.addObject("paramData", paramMap);
		mv.setViewName("org/organization/orgChangeSchemeMgr/schemeSimulationLayer");
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 조직개편 시뮬레이션 POPUP > 개편안작성[조직]
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewSchemeSimulationOrg", method = {RequestMethod.POST, RequestMethod.GET} )
	public ModelAndView viewSchemeSimulationOrg(HttpSession session, @RequestParam Map<String, Object> paramMap,
			HttpServletRequest request) throws Exception {
		Log.DebugStart();
		Log.Debug("data == [" + paramMap + "]");
		ObjectMapper obj = new ObjectMapper();
		Log.Debug("paramMap = " + obj.writeValueAsString(paramMap));

		ModelAndView mv = new ModelAndView();

		mv.addObject("paramData", paramMap);
		mv.setViewName("org/organization/orgChangeSchemeMgr/schemeSimulationOrg");
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 조직개편 시뮬레이션 POPUP > 개편안작성[조직] > 초기화
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveOrgChangeView", method = RequestMethod.POST )
	public ModelAndView saveOrgChangeView(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		convertMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		String message = "";
		int resultCnt = -1;

		try{
			resultCnt = orgChangeSchemeMgrService.saveOrgChangeView(convertMap);
			if(resultCnt > 0){
				message="저장 처리 되었습니다.";
			} else {
				message="저장된 내용이 없습니다.";
			}
		} catch(Exception e) {
			resultCnt = -1;
			message="저장에 실패하였습니다.";
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
	 * 인사개편 시뮬레이션 POPUP > 개편안작성[인사]
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewSchemeSimulationEmp", method = {RequestMethod.POST, RequestMethod.GET} )
	public ModelAndView viewSchemeSimulationEmp(HttpSession session, @RequestParam Map<String, Object> paramMap,
			HttpServletRequest request) throws Exception {
		Log.DebugStart();
		Log.Debug("data == [" + paramMap + "]");
		ObjectMapper obj = new ObjectMapper();
		Log.Debug("paramMap = " + obj.writeValueAsString(paramMap));

		ModelAndView mv = new ModelAndView();

		mv.addObject("paramData", paramMap);
		mv.setViewName("org/organization/orgChangeSchemeMgr/schemeSimulationEmp");
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 인사개편 시뮬레이션 POPUP > 개편안작성[인사] > 초기화
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=deleteSchemeSimulationEmpAll", method = RequestMethod.POST )
	public ModelAndView deleteSchemeSimulationEmpAll(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		String message = "";
		int resultCnt = -1;

		try{
			resultCnt = orgChangeSchemeMgrService.deleteSchemeSimulationEmpAll(paramMap);
			if(resultCnt > 0){
				message="초기화 처리 되었습니다.";
			} else {
				message="초기화된 내용이 없습니다.";
			}
		} catch(Exception e) {
			resultCnt = -1;
			message="초기화에 실패하였습니다.";
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
	 * 인사개편 시뮬레이션 POPUP > 개편현황
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewSchemeSimulationReOrgSta", method = {RequestMethod.POST, RequestMethod.GET} )
	public ModelAndView viewSchemeSimulationReOrgSta(HttpSession session, @RequestParam Map<String, Object> paramMap,
			HttpServletRequest request) throws Exception {
		Log.DebugStart();
		Log.Debug("data == [" + paramMap + "]");
		ObjectMapper obj = new ObjectMapper();
		Log.Debug("paramMap = " + obj.writeValueAsString(paramMap));

		ModelAndView mv = new ModelAndView();

		mv.addObject("paramData", paramMap);
		mv.setViewName("org/organization/orgChangeSchemeMgr/schemeSimulationReOrgSta");
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 인사개편 시뮬레이션 POPUP > 최종 확인
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewSchemeSimulationFinalConfirm", method = {RequestMethod.POST, RequestMethod.GET} )
	public ModelAndView viewSchemeSimulationFinalConfirm(HttpSession session, @RequestParam Map<String, Object> paramMap,
			HttpServletRequest request) throws Exception {
		Log.DebugStart();
		Log.Debug("data == [" + paramMap + "]");
		ObjectMapper obj = new ObjectMapper();
		Log.Debug("paramMap = " + obj.writeValueAsString(paramMap));

		ModelAndView mv = new ModelAndView();

		mv.addObject("paramData", paramMap);
		mv.setViewName("org/organization/orgChangeSchemeMgr/schemeSimulationFinalConfirm");
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 인사개편 시뮬레이션 POPUP > 발령연계처리
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=schemeSimulationProcessingLinkage", method = RequestMethod.POST )
	public ModelAndView schemeSimulationProcessingLinkage(HttpSession session, @RequestParam Map<String, Object> paramMap,
			HttpServletRequest request) throws Exception {
		Log.DebugStart();
		Log.Debug("data == [" + paramMap + "]");
		ObjectMapper obj = new ObjectMapper();
		Log.Debug("paramMap = " + obj.writeValueAsString(paramMap));

		ModelAndView mv = new ModelAndView();

		mv.addObject("paramData", paramMap);
		mv.setViewName("org/organization/orgChangeSchemeMgr/schemeSimulationProcessingLinkage");
		Log.DebugEnd();
		return mv;
	}

}
