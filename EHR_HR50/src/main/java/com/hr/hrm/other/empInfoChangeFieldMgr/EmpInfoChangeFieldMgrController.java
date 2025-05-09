package com.hr.hrm.other.empInfoChangeFieldMgr;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import com.hr.common.security.SecurityMgrService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;

/**
 * 사원정보변경기준항목관리
 * @author 한화손해보험
 *
 */
@Controller
@RequestMapping({"/EmpInfoChangeFieldMgr.do","/PsnalBasicInf.do"})
public class EmpInfoChangeFieldMgrController {
	
	@Inject
	@Named("EmpInfoChangeFieldMgrService")
	private EmpInfoChangeFieldMgrService empInfoChangeFieldMgrService;

	@Autowired
	private SecurityMgrService securityMgrService;

	@RequestMapping(params="cmd=viewEmpInfoChangeFieldMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewEmpInfoChangeFieldMgr(
			@RequestParam Map<String, Object> paramMap,
			HttpServletRequest request) throws Exception {
		return "hrm/other/empInfoChangeFieldMgr/empInfoChangeFieldMgr";
	}
	
	@RequestMapping(params="cmd=getEmpInfoChangeFieldMgrList", method = RequestMethod.POST )
	public ModelAndView getEmpInfoChangeFieldMgrList(HttpSession session,
			HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		List<?> result = empInfoChangeFieldMgrService.getEmpInfoChangeFieldMgrList(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", result);
		Log.DebugEnd();
		return mv;
		
	}
	
	/**
	 * 사원정보변경기준항목관리 저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveEmpInfoChangeFieldMgr", method = RequestMethod.POST )
	public ModelAndView saveEmpInfoChangeFieldMgr(
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
			List<Map> insertList = (List<Map>)convertMap.get("insertRows");
			List<Map> mergeList = (List<Map>)convertMap.get("mergeRows");

			for(Map<String, Object> mp : insertList) {
				for (Map.Entry<String, Object> e : mp.entrySet()) {
					String k = e.getKey();
					Object v = e.getValue();

					mp.put(k, securityMgrService.filterInput(v));
				}
			}

			for(Map<String, Object> mp : mergeList) {
				for (Map.Entry<String, Object> e : mp.entrySet()) {
					String k = e.getKey();
					Object v = e.getValue();

					mp.put(k, securityMgrService.filterInput(v));
				}
			}

			convertMap.put("insertRows", insertList);
			convertMap.put("mergeRows", mergeList);

			resultCnt = empInfoChangeFieldMgrService.saveEmpInfoChangeFieldMgr(convertMap);
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
