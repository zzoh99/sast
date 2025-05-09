package com.hr.pap.config.appEvaluateeMgr;
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

import com.hr.common.code.CommonCodeService;
import com.hr.common.com.ComController;
import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;
/**
 * 피평가자관리 Controller
 *
 * @author JSG
 *
 */
@Controller
@RequestMapping(value="/AppEvaluateeMgr.do", method=RequestMethod.POST )
public class AppEvaluateeMgrController extends ComController {
	/**
	 * 사용할 서비스 선언
	 */
	@Inject
	@Named("AppEvaluateeMgrService")
	private AppEvaluateeMgrService appEvaluateeMgrService;

	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;

	/**
	 * 피평가자관리 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewAppEvaluateeMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewAppEvaluateeMgr() throws Exception {
		return "pap/config/appEvaluateeMgr/appEvaluateeMgr";
	}

	/**
	 * 평가대상자생성/관리 평가자 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewAppEvaluateeMgrAppSabunPop", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewAppEvaluateeMgrAppSabunPop() throws Exception {
		return "pap/config/AppEvaluateeMgr/AppEvaluateeMgrAppSabunPop";
	}

	/**
	 * 평가대상자생성 팝업
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewAppPeopleCreatePop", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewAppPeopleCreatePop() throws Exception {
		return "pap/config/appEvaluateeMgr/appPeopleCreatePop";
	}

	/**
	 * 조직이동상세 팝업
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewAppEvaluateeMgrChgOrgPop", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewAppEvaluateeMgrChgOrgPop() throws Exception {
		return "pap/config/appEvaluateeMgr/appEvaluateeMgrChgOrgPop";
	}
	
	/**
	 * 피평가자관리 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAppEvaluateeMgrList1", method = RequestMethod.POST )
	public ModelAndView getAppEvaluateeMgrList1(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}
	
	/**
	 * 피평가자관리 단건 조회(평가단계별 날짜조회)
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAppEvaluateeMgrMap1", method = RequestMethod.POST )
	public ModelAndView getAppEvaluateeMgrMap1(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		Map<?, ?> map = appEvaluateeMgrService.getAppEvaluateeMgrMap1(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("resultMap", map);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 피평가자관리 저장(상단 저장)
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveAppEvaluateeMgr1", method = RequestMethod.POST )
	public ModelAndView saveAppEvaluateeMgr1(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		convertMap.put("ssnSabun", session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));

		List<Map> insertList = (List<Map>)convertMap.get("insertRows");
		List<Map<String,Object>> dupList = new ArrayList<Map<String,Object>>();

		for(Map<String,Object> mp : insertList) {
			Map<String,Object> dupMap = new HashMap<String,Object>();
			dupMap.put("ENTER_CD",convertMap.get("ssnEnterCd"));
			dupMap.put("APPRAISAL_CD",mp.get("appraisalCd"));
			dupMap.put("SABUN",mp.get("sabun"));
			dupList.add(dupMap);
		}

		String message = "";
		int resultCnt = -1;

		try{
			int dupCnt = 0;

			if(insertList.size() > 0) {
				// 중복체크
				dupCnt = commonCodeService.getDupCnt("TPAP201","ENTER_CD,APPRAISAL_CD,SABUN","s,s,s",dupList);
			}

			if(dupCnt > 0) {
				resultCnt = -1; message="중복된 값이 존재합니다.";
			} else {
				resultCnt = appEvaluateeMgrService.saveAppEvaluateeMgr1(convertMap);
				if(resultCnt > 0){ message="저장되었습니다."; } else{ message="저장된 내용이 없습니다."; }
			}
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
	 * 피평가자관리 저장(전체삭제)
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=deleteAppEvaluateeMgrAll", method = RequestMethod.POST )
	public ModelAndView deleteAppEvaluateeMgrAll(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();

		String message = "";
		int resultCnt = -1;

		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));

		try{
			resultCnt = appEvaluateeMgrService.deleteAppEvaluateeMgrAll(paramMap);
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

	/**
	 * 피평가자관리 평가그룹팝업 Popup View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewAppEvaluateeMgrPop", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewAppEvaluateeMgrPop() throws Exception {
		return "pap/config/appEvaluateeMgr/appEvaluateeMgrPop";
	}

	/**
	 * 피평가자관리 평가그룹팝업 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAppEvaluateeMgrPopList", method = RequestMethod.POST )
	public ModelAndView getAppEvaluateeMgrPopList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}

	/**
	 * 조직이동상세리스트 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAppEvaluateeMgrChgOrgList", method = RequestMethod.POST )
	public ModelAndView getAppEvaluateeMgrChgOrgList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}

	/**
	 * 피평가자 생성  - 프로시저 호출
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=prcAppPeopleCreateMgr", method = RequestMethod.POST )
	public ModelAndView prcAppPeopleCreateMgr(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();  
		return execPrc(session, request, paramMap);
	}
	
	/**
	 * 평가대상자생성/관리 평가그룹팝업 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAppPeopleMgrPopList", method = RequestMethod.POST )
	public ModelAndView getAppPeopleMgrPopList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}
}
