package com.hr.tim.workApp.otWorkOrgUpdApp;
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

import com.hr.common.com.ComController;
import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;
/**
 * 연장근무변경신청 Controller 
 * 
 * @author 이름
 *
 */
@Controller
@RequestMapping(value="/OtWorkOrgUpdApp.do", method=RequestMethod.POST )
public class OtWorkOrgUpdAppController extends ComController {
	/**
	 * 연장근무변경신청 서비스
	 */
	@Inject
	@Named("OtWorkOrgUpdAppService")
	private OtWorkOrgUpdAppService otWorkOrgUpdAppService;
	/**
	 * 연장근무변경신청 View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewOtWorkOrgUpdApp", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewOtWorkOrgUpdApp() throws Exception {
		return "tim/workApp/otWorkOrgUpdApp/otWorkOrgUpdApp";
	}
	
	/**
	 * 연장근무변경신청 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getOtWorkOrgUpdAppList", method = RequestMethod.POST )
	public ModelAndView getOtWorkOrgUpdAppList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}
	
	/**
	 * 연장근무변경신청 저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=deleteOtWorkOrgUpdApp", method = RequestMethod.POST )
	public ModelAndView deleteOtWorkOrgUpdApp(
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
			resultCnt =otWorkOrgUpdAppService.deleteOtWorkOrgUpdApp(convertMap);
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
