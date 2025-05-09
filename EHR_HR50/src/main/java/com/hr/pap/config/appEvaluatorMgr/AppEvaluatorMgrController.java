package com.hr.pap.config.appEvaluatorMgr;
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
 * 평가자관리 Controller
 *
 * @author JSG
 *
 */
@Controller
@RequestMapping(value="/AppEvaluatorMgr.do", method=RequestMethod.POST )
public class AppEvaluatorMgrController extends ComController {
	/**
	 * 사용할 서비스 선언
	 */
	@Inject
	@Named("AppEvaluatorMgrService")
	private AppEvaluatorMgrService AppEvaluatorMgrService;

	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;

	/**
	 * 평가자관리 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewAppEvaluatorMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewAppEvaluatorMgr() throws Exception {
		return "pap/config/appEvaluatorMgr/appEvaluatorMgr";
	}

	/**
	 * 평가대상자생성/관리 평가자 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewAppEvaluatorMgrAppSabunPop", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewAppEvaluatorMgrAppSabunPop() throws Exception {
		return "pap/config/appEvaluatorMgr/appEvaluatorMgrAppSabunPop";
	}

	/**
	 * 평가자관리 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAppEvaluatorMgrList1", method = RequestMethod.POST )
	public ModelAndView getAppEvaluatorMgrList1(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}
	
	/**
	 * 평가자관리 단건 조회(평가단계별 날짜조회)
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAppEvaluatorMgrMap1", method = RequestMethod.POST )
	public ModelAndView getAppEvaluatorMgrMap1(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		Map<?, ?> map = AppEvaluatorMgrService.getAppEvaluatorMgrMap1(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("resultMap", map);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 평가자관리 저장(상단 저장)
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveAppEvaluatorMgr1", method = RequestMethod.POST )
	public ModelAndView saveAppEvaluatorMgr1(
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
			dupMap.put("APP_TYPE_CD",mp.get("appTypeCd"));
			dupMap.put("APP_SEQ",mp.get("appSeq"));
			dupMap.put("APP_SABUN",mp.get("appSabun"));
			dupList.add(dupMap);
		}

		String message = "";
		int resultCnt = -1;

		try{
			int dupCnt = 0;

			if(insertList.size() > 0) {
				// 중복체크
				dupCnt = commonCodeService.getDupCnt("TPAP202","ENTER_CD,APPRAISAL_CD,SABUN,APP_TYPE_CD,APP_SEQ,APP_SABUN","s,s,s,s,s,s",dupList);
			}

			if(dupCnt > 0) {
				resultCnt = -1; message="중복된 값이 존재합니다.";
			} else {
				resultCnt = AppEvaluatorMgrService.saveAppEvaluatorMgr1(convertMap);
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
	 * 평가자관리 평가그룹팝업 Popup View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewAppEvaluatorMgrPop", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewAppEvaluatorMgrPop() throws Exception {
		return "pap/config/AppEvaluatorMgr/AppEvaluatorMgrPop";
	}

	/**
	 * 평가자관리 평가그룹팝업 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAppEvaluatorMgrPopList", method = RequestMethod.POST )
	public ModelAndView getAppEvaluatorMgrPopList(
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
	@RequestMapping(params="cmd=getAppEvaluatorMgrChgOrgList", method = RequestMethod.POST )
	public ModelAndView getAppEvaluatorMgrChgOrgList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}

	/**
	 * 평가자 생성  - 프로시저 호출
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
	 * 평가자 - 입력 피평가자 팝업 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAppEvaluatorMgrListPop", method = RequestMethod.POST )
	public ModelAndView getAppPeopleMgrList2(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}
}
