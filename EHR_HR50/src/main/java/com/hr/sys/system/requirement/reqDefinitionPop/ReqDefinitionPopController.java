package com.hr.sys.system.requirement.reqDefinitionPop;
import java.util.HashMap;
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
import com.hr.common.security.SecurityMgrService;

/**
 * 요구사항팝업 Controller
 *
 * @author EW
 *
 */
@Controller
@RequestMapping(value="/ReqDefinitionPop.do", method=RequestMethod.POST )
public class ReqDefinitionPopController { 
	/**
	 * 요구사항팝업 서비스
	 */
	@Inject
	@Named("ReqDefinitionPopService")
	private ReqDefinitionPopService reqDefinitionService;
	
	@Inject
	@Named("SecurityMgrService")
	private SecurityMgrService securityMgrService;

	/**
	 * 요구사항팝업 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewReqDefinitionPop", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewReqDefinitionPop() throws Exception {
		return "sys/system/requirement/reqDefinitionPop/reqDefinitionPop";
	}

	@RequestMapping(params="cmd=viewReqDefinitionLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewReqDefinitionLayer() throws Exception {
		return "sys/system/requirement/reqDefinitionPop/reqDefinitionLayer";
	}

	/**
	 * 요구사항팝업 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveReqDefinitionPop", method = RequestMethod.POST )
	public ModelAndView saveReqDefinitionPop(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();

		String url = (String) paramMap.get("surl");
		String key = (String) session.getAttribute("ssnEncodedKey");
		
		String message = "";
		int resultCnt = -1;
		try{
			
			@SuppressWarnings("unchecked")
			Map<String, Object> rtn = (Map<String, Object>) securityMgrService.getDecryptUrl(url,key) ;
			
			Log.Debug("rtn : " + rtn);
			
			rtn.put("ssnSabun", 	session.getAttribute("ssnSabun"));
			rtn.put("ssnEnterCd",	session.getAttribute("ssnEnterCd"));
			rtn.put("regName",		paramMap.get("regName"));
			rtn.put("regYmd",		paramMap.get("regYmd"));
			rtn.put("searchRegCd",	paramMap.get("searchRegCd"));
			rtn.put("regNote",		paramMap.get("regNote"));
			rtn.put("proName",		paramMap.get("proName"));
			rtn.put("fileSeq",		paramMap.get("fileSeq"));
			
			Log.Debug( "regName : "     + paramMap.get("regName"));
			Log.Debug( "regYmd : "      + paramMap.get("regYmd"));
			Log.Debug( "searchRegCd : " + paramMap.get("searchRegCd"));
			Log.Debug( "regNote : "     + paramMap.get("regNote"));
			
			resultCnt =reqDefinitionService.saveReqDefinitionPop(rtn);
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

