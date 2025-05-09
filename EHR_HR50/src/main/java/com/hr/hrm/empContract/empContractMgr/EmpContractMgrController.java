package com.hr.hrm.empContract.empContractMgr;
import java.util.*;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import com.hr.common.util.StringUtil;
import com.nhncorp.lucy.security.xss.LucyXssFilter;
import com.nhncorp.lucy.security.xss.XssPreventer;
import com.nhncorp.lucy.security.xss.XssSaxFilter;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.hr.common.com.ComController;
import com.hr.common.logger.Log;
/**
 * 근로계약서관리 Controller
 *
 * @author sjk
 *
 */
@Controller
@RequestMapping(value="/EmpContractMgr.do", method=RequestMethod.POST )
public class EmpContractMgrController extends ComController {
	/**
	 * 근로계약서관리 서비스
	 */
	@Inject
	@Named("EmpContractMgrService")
	private EmpContractMgrService empContractMgrService;

	/**
	 * viewEmpContractMgr View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewEmpContractMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewEmpContractMgr() throws Exception {
		return "hrm/empContract/empContractMgr/empContractMgr";
	}
	
	/**
	 * viewEmpContractMgr View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewEmpContractMgrPop", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewEmpContractMgrPop() throws Exception {
		return "hrm/empContract/empContractMgr/empContractMgrPop";
	}

	@RequestMapping(params="cmd=viewEmpContractMgrLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public ModelAndView viewEmpContractMgrLayer(@RequestParam Map<String, Object> paramMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		mv.addAllObjects(paramMap);
		mv.setViewName("hrm/empContract/empContractMgr/empContractMgrLayer");
		return mv;
	}
	
	/**
	 * getEmpContractMgrList 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getEmpContractMgrList", method = RequestMethod.POST )
	public ModelAndView getEmpContractMgrList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}
	
	/**
	 * 근로계약서관리 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveEmpContractMgr", method = RequestMethod.POST )
	public ModelAndView saveEmpContractMgr(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();
		return saveData(session, request, paramMap);
	}
	
	/**
	 * 근로계약서관리 Contents 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveEmpContractMgrContents", method = RequestMethod.POST )
	public ModelAndView saveEmpContractMgrContents(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		String message = "";
		int resultCnt = -1;
		
		try{
			resultCnt = empContractMgrService.saveEmpContractMgrContentsEmpty(paramMap);
			if(resultCnt < 1){ message="데이터 초기화에 실패하였습니다."; }
			else{
				resultCnt = empContractMgrService.saveEmpContractMgrContents(paramMap);
				if(resultCnt > 0){ message="수정되었습니다."; }
				else{ message="수정된 내용이 없습니다."; }
			}
		}catch(Exception e){
			resultCnt = -1;
			message="수정에 실패하였습니다.";
		}
		
/*		try{
			resultCnt = empContractMgrService.saveEmpContractMgrContents(paramMap);
			if(resultCnt > 0){ message="저장되었습니다."; } else{ message="저장된 내용이 없습니다."; }
		}catch(Exception e){
			resultCnt = -1; message="저장에 실패하였습니다.";
		}*/

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
