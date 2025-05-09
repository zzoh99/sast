package com.hr.tim.annual.annualPlanAgrApp;
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
 * 연차촉진신청 Controller
 *
 * @author EW
 *
 */
@Controller
@RequestMapping(value="/AnnualPlanAgrApp.do", method=RequestMethod.POST )
public class AnnualPlanAgrAppController extends ComController {
	/**
	 * 연차촉진신청 서비스
	 */
	@Inject
	@Named("AnnualPlanAgrAppService")
	private AnnualPlanAgrAppService annualPlanAgrAppService;

	/**
	 * 연차촉진신청 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewAnnualPlanAgrApp", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewAnnualPlanAgrApp() throws Exception {
		return "tim/annual/annualPlanAgrApp/annualPlanAgrApp";
	}

	/**
	 * 연차촉진신청 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAnnualPlanAgrAppList", method = RequestMethod.POST )
	public ModelAndView getAnnualPlanAgrAppList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}
	
	
	/**
	 * 연차촉진신청 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=deleteAnnualPlanAgrApp", method = RequestMethod.POST )
	public ModelAndView deleteAnnualPlanAgrApp(
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
			resultCnt =annualPlanAgrAppService.deleteAnnualPlanAgrApp(convertMap);
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
