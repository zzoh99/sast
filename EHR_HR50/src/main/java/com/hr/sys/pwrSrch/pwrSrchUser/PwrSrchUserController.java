package com.hr.sys.pwrSrch.pwrSrchUser;

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
import com.hr.common.util.ParamUtils;
import com.hr.common.logger.Log;

/**
 * 조건검색
 * 
 * @author ParkMoohun
 */
@Controller
@RequestMapping(value="/PwrSrchUser.do", method=RequestMethod.POST )
public class PwrSrchUserController {

	@Inject
	@Named("PwrSrchUserService")
	private PwrSrchUserService pwrSrchUserService;

	/**
	 * 조건검색 화면
	 * 
	 * @param paramMap
	 * @param request
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewPwrSrchUser", method = {RequestMethod.POST, RequestMethod.GET} )
	public ModelAndView viewPwrSrchUser(
			@RequestParam Map<String, Object> paramMap,
			HttpServletRequest request) throws Exception {
		Log.Debug("PwrSrchUserController.viewPwrSrchUser");
		ModelAndView mv = new ModelAndView();
		mv.setViewName("sys/pwrSrch/pwrSrchUser/pwrSrchUser");
		mv.addObject("srchSeq", 	request.getParameter("srchSeq"));
		mv.addObject("srchViewCd", 	request.getParameter("srchViewCd"));
		mv.addObject("srchNiewNm", 	request.getParameter("srchNiewNm"));
		return mv;
	}

	/**  
	 * 조건검색 상세 내용 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPwrSrchUserDetailDescMap", method = RequestMethod.POST )
	public ModelAndView getPwrSrchUserDetailDescMap(HttpSession session,
			HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		//한글이 들어 올경우 UTF-8로 Convertion해줘야 된다.
		paramMap = ParamUtils.converterParams(request);
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		
		Map result = pwrSrchUserService.getPwrSrchUserDetailDescMap(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("condDesc", result.get("conditionDesc"));
		Log.DebugEnd();
		return mv;
	}
	
	/**  
	 * 조건검색 시트1 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPwrSrchUserSht1List", method = RequestMethod.POST )
	public ModelAndView getPwrSrchUserSht1List(HttpSession session,
			HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		//한글이 들어 올경우 UTF-8로 Convertion해줘야 된다.
		paramMap = ParamUtils.converterParams(request);
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		
		List<?> result = pwrSrchUserService.getPwrSrchUserSht1List(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", result);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 조건검색 시트2 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPwrSrchUserSht2List", method = RequestMethod.POST )
	public ModelAndView getPwrSrchUserSht2List(HttpSession session,
			HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		//한글이 들어 올경우 UTF-8로 Convertion해줘야 된다.
		paramMap = ParamUtils.converterParams(request);
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		
		List<?> result = pwrSrchUserService.getPwrSrchUserSht2List(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", result);
		Log.DebugEnd();
		return mv;
	}
	
	/**
	 * 조건검색 저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=savePwrSrchUser", method = RequestMethod.POST )
	public ModelAndView savePwrSrchUser(HttpSession session,
			HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		convertMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		convertMap.put("ssnSabun", session.getAttribute("ssnSabun"));

		convertMap.put("searchSeq2", paramMap.get("searchSeq2") );
		convertMap.put("sqlSyntax2", paramMap.get("sqlSyntax2") );
		
		int result = pwrSrchUserService.savePwrSrchUser(convertMap);

		String message = "";
		if (result > 0) { 	message = "저장되었습니다."; } 
		else {				message = "저장 실퍠 하였습니다."; }

		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("Code", result);
		resultMap.put("Message", message);

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Result", resultMap);

		Log.Debug("Result Message : " + mv);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 조건검색 화면
	 * 
	 * @param paramMap
	 * @param request
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=pwrSrchUserPopup", method = RequestMethod.POST )
	public ModelAndView pwrSrchUserPopup(HttpSession session,
			@RequestParam Map<String, Object> paramMap,
			HttpServletRequest request) throws Exception {
		Log.Debug("PwrSrchUserController.pwrSrchUserPopup");
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		
		String editFlag     = request.getParameter("_editFlag") == null ? "FALSE" : request.getParameter("_editFlag");
	    String adminFlag     = request.getParameter("adminFlag") != null && request.getParameter("adminFlag").equals("no") ? "FALSE" : request.getParameter("adminFlag");
		
		ModelAndView mv = new ModelAndView();
		mv.addObject("editFlag", editFlag);
		mv.addObject("adminFlag", adminFlag);
		mv.setViewName("common/popup/pwrSrchInputValuePopup");
		return mv;
	}
}