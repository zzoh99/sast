package com.hr.pap.config.appGradeSeqCd2;
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
 * 배분결과(2차) Controller
 *
 * @author EW
 *
 */
@Controller
@RequestMapping({"EvaMain.do","/AppGradeSeqCd2.do"})
public class AppGradeSeqCd2Controller {
	/**
	 * 배분결과(2차) 서비스
	 */
	@Inject
	@Named("AppGradeSeqCd2Service")
	private AppGradeSeqCd2Service appGradeSeqCd2Service;

	/**
	 * 배분결과(2차) View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewAppGradeSeqCd2", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewAppGradeSeqCd2() throws Exception {
		return "pap/config/appGradeSeqCd2/appGradeSeqCd2";
	}

	/**
	 * 배분결과(2차)(세부내역) 팝업 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewAppGradeSeqCd2Pop", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewAppGradeSeqCd2Pop() throws Exception {
		return "pap/config/appGradeSeqCd2/appGradeSeqCd2Pop";
	}


	@RequestMapping(params="cmd=viewAppGradeOrgRateMgrLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewAppGradeOrgRateMgrLayer() throws Exception {
		return "pap/config/appGradeSeqCd2/appGradeOrgRateMgrLayer";
	}

	/**
	 * 배분결과(2차) 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAppGradeSeqCd2List", method = RequestMethod.POST )
	public ModelAndView getAppGradeSeqCd2List(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = appGradeSeqCd2Service.getAppGradeSeqCd2List(paramMap);
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
	 * 배분결과(2차) 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveAppGradeSeqCd2", method = RequestMethod.POST )
	public ModelAndView saveAppGradeSeqCd2(
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
			resultCnt =appGradeSeqCd2Service.saveAppGradeSeqCd2(convertMap);
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

