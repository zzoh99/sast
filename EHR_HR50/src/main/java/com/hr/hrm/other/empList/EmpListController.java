package com.hr.hrm.other.empList;

import com.hr.common.atuhTable.AuthTableService;
import com.hr.common.code.CommonCodeService;
import com.hr.common.com.ComController;
import com.hr.common.logger.Log;
import com.hr.common.other.OtherService;
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
import java.util.*;

/**
 * 인원명부항목정의 Controller
 *
 * @author 이름
 *
 */
@Controller
@RequestMapping(value="/EmpList.do", method=RequestMethod.POST )
public class EmpListController extends ComController {

	/**
	 * 인원명부항목정의 서비스
	 */
	@Inject
	@Named("EmpListService")
	private EmpListService empListService;

	@Inject
	@Named("OtherService")
	private OtherService otherService;

	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;

	@Inject
	@Named("AuthTableService")
	private AuthTableService authTableService;

	/**
	 * viewEmpList View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewEmpList", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewEmpList() throws Exception {
		return "hrm/other/empList/empList";
	}

	/**
	 * viewEmpListColMgr View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewEmpListColMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewEmpListColMgr() throws Exception {
		return "hrm/other/empList/empListColMgr";
	}

	/**
	 * viewEmpListColAttrMgr View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewEmpListColAttrMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewEmpListColAttrMgr() throws Exception {
		return "hrm/other/empList/empListColAttrMgr";
	}

	/**
	 * saveEmpListColMgr 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(params="cmd=saveEmpListColMgr", method = RequestMethod.POST )
	public ModelAndView saveEmpListColMgr(
				HttpSession session
			, 	HttpServletRequest request
			,	@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		Map<String, Object> convertMap = ParamUtils.unPivotParams(request, paramMap.get("s_SAVENAME").toString(), "grpCd", "GRP_CD", "USE_YN");
		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		convertMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		List<Map<String, Object>> insertList = (List<Map<String, Object>>)convertMap.get("insertRows");
		List<Map<String,Object>> dupList = new ArrayList<Map<String,Object>>();

		for(Map<String,Object> mp : insertList) {
			Map<String,Object> dupMap = new HashMap<String,Object>();
			dupMap.put("ENTER_CD",convertMap.get("ssnEnterCd"));
			dupMap.put("GRP_CD",mp.get("GRP_CD"));
			dupMap.put("COLUMN_NAME",mp.get("colName"));
			dupList.add(dupMap);
		}

		String message = "";
		int resultCnt = -1;

		try{
			int dupCnt = 0;

			if(insertList.size() > 0) {
				// 중복체크
				dupCnt = commonCodeService.getDupCnt("THRM503", "ENTER_CD,GRP_CD,COLUMN_NAME", "s,s,s",dupList);
			}

			if(dupCnt > 0) {
				resultCnt = -1; message="중복된 값이 존재합니다.";
			} else {
				resultCnt = empListService.saveEmpListColMgr(convertMap);
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
	 * getEmpListColMgrTitleList 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getEmpListColMgrTitleList", method = RequestMethod.POST )
	public ModelAndView getEmpListColMgrTitleList(
				HttpSession session
			,  	HttpServletRequest request
			,	@RequestParam Map<String, Object> paramMap ) throws Exception {
		
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",   session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = empListService.getEmpListColMgrTitleList(paramMap);
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
	 * getEmpListColMgrList 조회
	 * 사용안함 20240719 jyp
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
//	@RequestMapping(params="cmd=getEmpListColMgrList", method = RequestMethod.POST )
//	public ModelAndView getEmpListColMgrList(
//				HttpSession session
//			,  	HttpServletRequest request
//			,	@RequestParam Map<String, Object> paramMap ) throws Exception {
//
//		Log.DebugStart();
//
//		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
//		paramMap.put("ssnSabun",   session.getAttribute("ssnSabun"));
//
//		List<?> list  = new ArrayList<Object>();
//		String Message = "";
//		try {
//			list = empListService.getEmpListColMgrList(paramMap);
//		} catch(Exception e) {
//			Message="조회에 실패하였습니다.";
//		}
//
//		ModelAndView mv = new ModelAndView();
//		mv.setViewName("jsonView");
//		mv.addObject("DATA", list);
//		mv.addObject("Message", Message);
//
//		Log.DebugEnd();
//
//		return mv;
//	}

	/**
	 * 인원명부항목정의 권한 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getEmpListTitleList", method = RequestMethod.POST )
	public ModelAndView getEmpListTitleList(
				HttpSession session
			,  	HttpServletRequest request
			,	@RequestParam Map<String, Object> paramMap ) throws Exception {
		
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		//권한 부여
		paramMap.put("ssnSearchType",	session.getAttribute("ssnSearchType"));
		paramMap.put("ssnGrpCd",		session.getAttribute("ssnGrpCd"));
		paramMap.put("ssnBaseDate", 	session.getAttribute("ssnBaseDate"));

		/* 사용안함
		Map<?, ?> query = authTableService.getAuthQueryMap(paramMap);
		paramMap.put("query",query.get("query"));
		*/

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try {
			list = empListService.getEmpListTitleList(paramMap);
		} catch(Exception e) {
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
	 * 인원명부 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getEmpListList", method = RequestMethod.POST )
	public ModelAndView getEmpListList(
				HttpSession session
			,  	HttpServletRequest request
			,	@RequestParam Map<String, Object> paramMap ) throws Exception {
		
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		//권한 부여
		paramMap.put("ssnSearchType",	session.getAttribute("ssnSearchType"));
		paramMap.put("ssnGrpCd",		session.getAttribute("ssnGrpCd"));
		paramMap.put("ssnBaseDate", 	session.getAttribute("ssnBaseDate"));

		String ssnLocaleCd = (String)session.getAttribute("ssnLocaleCd");
		paramMap.put("ssnLocaleCd", ssnLocaleCd);
		paramMap.put("viewSearchDate", paramMap.get("searchDate"));

		Map<?, ?> query = authTableService.getAuthQueryMap(paramMap);
		if(query != null) {
			paramMap.put("query", query.get("query"));
		}
		paramMap.put("searchViewNm", "인사_인사기본_기준일");
		String viewQuery = otherService.getViewQuery(paramMap);
		paramMap.put("selectViewQuery", viewQuery);

		// column 정보 조회, List 형태로 param에 담기
		List<Map> columnInfo = (List<Map>) empListService.getEmpListTitleList(paramMap);
		List<String> colHeader = Arrays.asList(columnInfo.get(0).get("colHeader").toString().split("\\|"));
		List<String> colName = Arrays.asList(columnInfo.get(0).get("colName").toString().split("\\|"));

		paramMap.put("colHeader", colHeader);
		paramMap.put("colName", colName);

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try {
			list = empListService.getEmpListList(paramMap);
		} catch(Exception e) {
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
	 * getEmpListColAttrMgrList 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getEmpListColAttrMgrList", method = RequestMethod.POST )
	public ModelAndView getEmpListColAttrMgrList(
				HttpSession session
			,  	HttpServletRequest request
			,	@RequestParam Map<String, Object> paramMap ) throws Exception {
		
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try {
			list = empListService.getEmpListColAttrMgrList(paramMap);
		} catch(Exception e) {
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
	 * saveEmpListColAttrMgr 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveEmpListColAttrMgr", method = RequestMethod.POST )
	public ModelAndView saveEmpListColAttrMgr(
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
			resultCnt =empListService.saveEmpListColAttrMgr(convertMap);
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

	/**
	 * viewEmpListItemMgr View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewEmpListItemMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewEmpListItemMgr() throws Exception {
		return "hrm/other/empList/empListItemMgr";
	}

	/**
	 *  다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getGrpCdMgrGrpCdList", method = RequestMethod.POST )
	public ModelAndView getGrpCdMgrGrpCdList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}

	/**
	 *  다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getEmpListNotUseColumnListByGrpCd", method = RequestMethod.POST )
	public ModelAndView getEmpListNotUseColumnListByGrpCd(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}

	/**
	 * 인원명부항목관리 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getEmpListItemMgrList", method = RequestMethod.POST )
	public ModelAndView getEmpListItemMgrList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}

	/**
	 * 컬럼추가 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveEmpListItem", method = RequestMethod.POST )
	public ModelAndView saveEmpListItem(
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
			resultCnt = empListService.addEmpListItem(convertMap);
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

	/**
	 * 인원명부항목관리 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveEmpListItemMgr", method = RequestMethod.POST )
	public ModelAndView saveEmpListItemMgr(
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
			resultCnt =empListService.saveEmpListItemMgr(convertMap);
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

	/**
	 * 인원명부 미리보기 View Layer
	 *
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewEmpListPreviewLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewEmpListPreviewLayer() throws Exception {
		return "hrm/other/empList/empListPreviewLayer";
	}
}
