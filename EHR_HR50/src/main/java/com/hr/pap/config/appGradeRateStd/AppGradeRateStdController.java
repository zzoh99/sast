package com.hr.pap.config.appGradeRateStd;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.hr.common.com.ComController;
import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;

/**
 * 배분기준표 Controller
 *
 * @author EW
 *
 */
@Controller
@RequestMapping({"EvaMain.do","/AppGradeRateStd.do"})
public class AppGradeRateStdController extends ComController {
	/**
	 * 배분기준표 서비스
	 */
	@Inject
	@Named("AppGradeRateStdService")
	private AppGradeRateStdService appGradeRateStdService;

	/**
	 * 배분기준표 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewAppGradeRateStd", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewAppGradeRateStd() throws Exception {
		return "pap/config/appGradeRateStd/appGradeRateStd";
	}

	/**
	 * 배분기준표(세부내역) 팝업 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewAppGradeRateStdPop", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewAppGradeRateStdPop() throws Exception {
		return "pap/config/appGradeRateStd/appGradeRateStdPop";
	}

	/**
	 * 배분기준표 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAppGradeRateStdList", method = RequestMethod.POST )
	public ModelAndView getAppGradeRateStdList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = appGradeRateStdService.getAppGradeRateStdList(paramMap);
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
	 * 배분기준표 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveAppGradeRateStd", method = RequestMethod.POST )
	public ModelAndView saveAppGradeRateStd(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		
		// 저장 대상 평가등급 컬럼 정보 설정
		List<String> saveClassList = new ArrayList<String>();
		String appClassCdList = (String) convertMap.get("appClassCdList");
		if(!StringUtils.isBlank(appClassCdList)) {
			String delimeter = "@";
			
			if(!appClassCdList.contains(delimeter)) {
				saveClassList.add(appClassCdList);
			} else {
				String[] arr = appClassCdList.split(delimeter);
				for (String string : arr) {
					saveClassList.add(string);
				}
			}
		}
		convertMap.put("saveClassList", saveClassList);

		String message = "";
		int resultCnt = -1;
		try{
			resultCnt =appGradeRateStdService.saveAppGradeRateStd(convertMap);
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

	/**
	 * 평가등급배분항목관리 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAppGradeRateStdClassItemList", method = RequestMethod.POST )
	public ModelAndView getAppGradeRateStdClassItemList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}

	/**
	 * 평가등급배분항목관리 저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveAppGradeRateStdClassItem", method = RequestMethod.POST )
	public ModelAndView saveAppGradeRateStdClassItem(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return saveData(session, request, paramMap);
	}
}

