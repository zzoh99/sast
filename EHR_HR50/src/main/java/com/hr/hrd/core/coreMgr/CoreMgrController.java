package com.hr.hrd.core.coreMgr;

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
 * 
 * 
 * @author ParkMoohun
 */
@Controller
@RequestMapping(value="/CoreMgr.do", method=RequestMethod.POST )
public class CoreMgrController {

	@Inject
	@Named("CoreMgrService")
	private CoreMgrService coreMgrService;
	
	/**
	 * 핵심인재관리 화면
	 * 
	 * @param paramMap
	 * @param request
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewCoreMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewCoreMgr() throws Exception {
		Log.Debug("CoreMgrController.viewCoreMgr");
		return "hrd/core/coreMgr/coreMgr";
	}
	
	/**
	 * 핵심인재관리 List
	 * 
	 * @param session
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getCoreMgrList", method = RequestMethod.POST )
	public ModelAndView getCoreMgrList(HttpSession session,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
		List<?> result = coreMgrService.getCoreMgrList(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView"); mv.addObject("DATA", result);
		Log.DebugEnd();
		return mv;
	}	

	/**
	 * 핵심인재관리 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveCoreMgr", method = RequestMethod.POST )
	public ModelAndView saveCoreMgr(
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
			resultCnt = coreMgrService.saveCoreMgr(convertMap);
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