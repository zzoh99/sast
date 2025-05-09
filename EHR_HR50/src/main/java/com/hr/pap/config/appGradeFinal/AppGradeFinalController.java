package com.hr.pap.config.appGradeFinal;
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
 * 배분결과(최종) Controller
 *
 * @author EW
 *
 */
@Controller
@RequestMapping(value="/AppGradeFinal.do", method=RequestMethod.POST )
public class AppGradeFinalController {
	/**
	 * 배분결과(최종) 서비스
	 */
	@Inject
	@Named("AppGradeFinalService")
	private AppGradeFinalService appGradeFinalService;

	/**
	 * 배분결과(최종) View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewAppGradeFinal", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewAppGradeFinal() throws Exception {
		return "pap/config/appGradeFinal/appGradeFinal";
	}

	/**
	 * 배분결과(최종)(세부내역) 팝업 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewAppGradeFinalPop", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewAppGradeFinalPop() throws Exception {
		return "pap/config/appGradeFinal/appGradeFinalPop";
	}

	@RequestMapping(params="cmd=viewAppGradeOrgRateMgrLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewAppGradeOrgRateMgrLayer() throws Exception {
		return "pap/config/appGradeSeqCd2/appGradeOrgRateMgrLayer";
	}

	/**
	 * 배분결과(최종) 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAppGradeFinalList", method = RequestMethod.POST )
	public ModelAndView getAppGradeFinalList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = appGradeFinalService.getAppGradeFinalList(paramMap);
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
	 * 배분결과(최종) 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveAppGradeFinal", method = RequestMethod.POST )
	public ModelAndView saveAppGradeFinal(
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
			resultCnt =appGradeFinalService.saveAppGradeFinal(convertMap);
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

