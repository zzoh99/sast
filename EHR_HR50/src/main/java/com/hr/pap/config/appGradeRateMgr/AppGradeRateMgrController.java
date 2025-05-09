package com.hr.pap.config.appGradeRateMgr;
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
 * 평가배분 Controller
 *
 * @author EW
 *
 */
@Controller
@RequestMapping(value="/AppGradeRateMgr.do", method=RequestMethod.POST )
public class AppGradeRateMgrController extends ComController {
	/**
	 * 평가배분 서비스
	 */
	@Inject
	@Named("AppGradeRateMgrService")
	private AppGradeRateMgrService appGradeRateMgrService;
	
	/**
	 * 평가배분 View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewAppGradeRateMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewAppGradeRateMgr() throws Exception {
		return "pap/config/appGradeRateMgr/appGradeRateMgr";
	}
	
	/**
	 * 평가배분 > 평가그룹인원 Popup View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewAppGradeOrgRateMgrPop", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewAppGradeOrgRateMgrPop() throws Exception {
		return "pap/config/appGradeRateMgr/appGradeRateMgrPop";
	}

	/**
	 * 평가배분 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAppGradeRateMgrList1", method = RequestMethod.POST )
	public ModelAndView getAppGradeRateMgrList1(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}

	/**
	 * 평가배분 저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveAppGradeRateMgr1", method = RequestMethod.POST )
	public ModelAndView saveAppGradeRateMgr1(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return saveData(session, request, paramMap);
	}

	/**
	 * 인원배분기준표 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAppGradeRateMgrList2", method = RequestMethod.POST )
	public ModelAndView getAppGradeRateMgrList2(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}

	/**
	 * 인원배분기준표 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveAppGradeRateMgr2", method = RequestMethod.POST )
	public ModelAndView saveAppGradeRateMgr(
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
			resultCnt =appGradeRateMgrService.saveAppGradeRateMgr2(convertMap);
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
	 * 평가그룹별 인원배분계획 생성 - 프로시저 호출
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=prcAppGradeRateMgr", method = RequestMethod.POST )
	public ModelAndView prcAppGradeRateMgr(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();  
		return execPrc(session, request, paramMap);
	}
}

