package com.hr.hrm.psnalInfo.psnalLicense;
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
 * 인사기본(자격) Controller
 *
 * @author 이름
 *
 */
@Controller
@RequestMapping(value="/PsnalLicense.do", method=RequestMethod.POST )
public class PsnalLicenseController {

	/**
	 * 인사기본(자격) 서비스
	 */
	@Inject
	@Named("PsnalLicenseService")
	private PsnalLicenseService psnalLicenseService;

	/**
	 * viewPsnalLicense View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewPsnalLicense", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewPsnalLicense() throws Exception {
		return "hrm/psnalInfo/psnalLicense/psnalLicense";
	}

	@RequestMapping(params="cmd=viewPsnalLicenseLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewPsnalLicenseLayer() throws Exception {
		return "hrm/psnalInfo/psnalLicense/psnalLicenseLayer";
	}
	
	/**
	 * getPsnalLicenseList 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPsnalLicenseList", method = RequestMethod.POST )
	public ModelAndView getPsnalLicenseList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = psnalLicenseService.getPsnalLicenseList(paramMap);
		}catch(Exception e){
			Message="조회에 실패 하였습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}
	
	/**
	 * 인사기본(자격) 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=savePsnalLicense", method = RequestMethod.POST )
	public ModelAndView savePsnalLicense(
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
			resultCnt = psnalLicenseService.savePsnalLicense(convertMap);
			if(resultCnt > 0){ message="저장되었습니다."; } else{ message="저장된 내용이 없습니다."; }
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