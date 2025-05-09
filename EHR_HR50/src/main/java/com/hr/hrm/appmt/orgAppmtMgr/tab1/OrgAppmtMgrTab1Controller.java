package com.hr.hrm.appmt.orgAppmtMgr.tab1;
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
 * 조직개편발령 Controller
 *
 * @author bckim
 *
 */
@Controller
@RequestMapping({"/OrgAppmtMgr.do", "/OrgAppmtMgrTab1.do"})
public class OrgAppmtMgrTab1Controller {

	/**
	 * 조직개편발령 서비스
	 */
	@Inject
	@Named("OrgAppmtMgrTab1Service")
	private OrgAppmtMgrTab1Service orgAppmtMgrTab1Service;

	/**
	 * 조직개편발령 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewOrgAppmtMgrTab1", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewOrgAppmtMgrTab1() throws Exception {
		return "hrm/appmt/orgAppmtMgr/tab1/orgAppmtMgrTab1";
	}

	/**
	 * 발령형태코드(콤보로 사용할때) 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getOrgAppmtMgrTab1CodeList", method = RequestMethod.POST )
	public ModelAndView getOrgAppmtMgrTab1CodeList(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		List<?> result = orgAppmtMgrTab1Service.getOrgAppmtMgrTab1CodeList(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("codeList", result);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 발령조직 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getOrgAppmtMgrTab1OrgList", method = RequestMethod.POST )
	public ModelAndView getOrgAppmtMgrTab1OrgList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = orgAppmtMgrTab1Service.getOrgAppmtMgrTab1OrgList(paramMap);

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
	 * 발령직원 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getOrgAppmtMgrTab1UserList", method = RequestMethod.POST )
	public ModelAndView getOrgAppmtMgrTab1UserList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = orgAppmtMgrTab1Service.getOrgAppmtMgrTab1UserList(paramMap);
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
	 * 발령직원 추가
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=insertOrgAppmtMgrTab1User", method = RequestMethod.POST )
	public ModelAndView insertOrgAppmtMgrTab1User(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();

		// 열로 된 데이터들을 Map 형태의 연관된 데이터 셋으로 만들기 위해
		// 같이 묶여질 param명을 ,구분자 포함하여 만든다.
		// 파싱할 항목을 , 로 구분하여 스트링형태로 생성
		String getParamNames ="sNo,sStatus,sabun,ordTypeCd,ordDetailCd,orgNm,workTypeNm,jikchakNm,jikgubNm"
							 +",sabun,name,workType,jikweeCd,jikgubCd,jikchakCd,jobCd,jobNm,ordYmd"
							 +",ordOrgCd,ordOrgNm,processNo,select";

		// Request에서 파싱하여 저장용도로 Param을 따로 구성
		// 파싱된 객체 목록
		// "mergeRows" 	merge문을 사용하여 update,insert를 한번에 처리하기 위한 저장 List
		// "insertRows" 생성 List
		// "updateRows" 수정 List
		// "deleteRows" 삭제 List
		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,getParamNames,"");
		convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		convertMap.put("chgOrdDetailCd",request.getParameter("chgOrdDetailCd") );
		convertMap.put("chgOrdYmd",request.getParameter("chgOrdYmd") );


		String message = "";
		int resultCnt = -1;
		try{
			resultCnt =orgAppmtMgrTab1Service.insertOrgAppmtMgrTab1User(convertMap);
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
