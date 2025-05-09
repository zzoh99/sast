package com.hr.hrm.other.empInfoChangeTableMgr;

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
 * 사원정보변경기준관리
 * @author 한화손해보험
 *
 */
@Controller
@RequestMapping({"/EmpInfoChangeTableMgr.do","/PsnalBasicInf.do"})
public class EmpInfoChangeTableMgrController {
	
	@Inject
	@Named("EmpInfoChangeTableMgrService")
	private EmpInfoChangeTableMgrService empInfoChangeTableMgrService;
	
	@RequestMapping(params="cmd=viewEmpInfoChangeTableMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewEmpInfoChangeTableMgr(
			@RequestParam Map<String, Object> paramMap,
			HttpServletRequest request) throws Exception {
		return "hrm/other/empInfoChangeTableMgr/empInfoChangeTableMgr";
	}
	
	
	@RequestMapping(params="cmd=getEmpInfoChangeTableMgrList", method = RequestMethod.POST )
	public ModelAndView getEmpInfoChangeTableMgrList(HttpSession session,
			HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		List<?> result = empInfoChangeTableMgrService.getEmpInfoChangeTableMgrList(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", result);
		Log.DebugEnd();
		return mv;
		
	}
	
	/**
	 * 사원정보변경기준관리 저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveEmpInfoChangeTableMgr", method = RequestMethod.POST )
	public ModelAndView saveContactMgr(
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
			resultCnt =empInfoChangeTableMgrService.saveEmpInfoChangeTableMgr(convertMap);
			if(resultCnt > 0){ message="저장 되었습니다."; } else{ message="저장된 내용이 없습니다."; }
		}catch(Exception e){
			resultCnt = -1; message="저장에 실패하 였습니다.";
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
