package com.hr.pap.config.appPeopleMgr;
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
 * 평가대상자생성/관리 Controller
 *
 * @author JSG
 *
 */
@Controller
@RequestMapping(value="/AppPeopleMgr.do", method=RequestMethod.POST )
public class AppPeopleMgrController extends ComController {
	/**
	 * 사용할 서비스 선언
	 */
	@Inject
	@Named("AppPeopleMgrService")
	private AppPeopleMgrService appPeopleMgrService;

	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;

	/**
	 * 평가대상자생성/관리 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewAppPeopleMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewAppPeopleMgr() throws Exception {
		return "pap/config/appPeopleMgr/appPeopleMgr";
	}

	/**
	 * 평가대상자생성/관리 평가자 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewAppPeopleMgrAppSabunPop", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewAppPeopleMgrAppSabunPop() throws Exception {
		return "pap/config/appPeopleMgr/appPeopleMgrAppSabunPop";
	}
	@RequestMapping(params="cmd=viewAppPeopleMgrAppSabunLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewAppPeopleMgrAppSabunLayer() throws Exception {
		return "pap/config/appPeopleMgr/appPeopleMgrAppSabunLayer";
	}

	/**
	 * 평가대상자생성 팝업
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewAppPeopleCreatePop", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewAppPeopleCreatePop() throws Exception {
		return "pap/config/appPeopleMgr/appPeopleCreatePop";
	}
	@RequestMapping(params="cmd=viewAppPeopleCreateLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewAppPeopleCreateLayer() throws Exception {
		return "pap/config/appPeopleMgr/appPeopleCreateLayer";
	}



	/**
	 * 조직이동상세 팝업
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewAppPeopleMgrChgOrgPop", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewAppPeopleMgrChgOrgPop() throws Exception {
		return "pap/config/appPeopleMgr/appPeopleMgrChgOrgPop";
	}
	@RequestMapping(params="cmd=viewAppPeopleMgrChgOrgLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewAppPeopleMgrChgOrgLayer() throws Exception {
		return "pap/config/appPeopleMgr/appPeopleMgrChgOrgLayer";
	}



	@RequestMapping(params="cmd=viewOrgBasicPapCreateLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewOrgBasicPapCreateLayer() throws Exception {
		return "pap/config/appPeopleMgr/orgBasicPapCreateLayer";
	}

	/**
	 * 평가대상자생성/관리 단건 조회(평가단계별 날짜조회)
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAppPeopleMgrMap1", method = RequestMethod.POST )
	public ModelAndView getAppPeopleMgrMap1(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		Map<?, ?> map = appPeopleMgrService.getAppPeopleMgrMap1(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("resultMap", map);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 평가대상자생성/관리 저장(상단 저장)
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveAppPeopleMgr1", method = RequestMethod.POST )
	public ModelAndView saveAppPeopleMgr1(
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
			dupMap.put("APP_STEP_CD",mp.get("appStepCd"));
			dupMap.put("SABUN",mp.get("sabun"));
			dupMap.put("APP_ORG_CD",mp.get("appOrgCd"));
			dupList.add(dupMap);
		}

		String message = "";
		int resultCnt = -1;

		try{
			int dupCnt = 0;

			if(insertList.size() > 0) {
				// 중복체크
				dupCnt = commonCodeService.getDupCnt("TPAP201","ENTER_CD,APPRAISAL_CD,APP_STEP_CD,SABUN,APP_ORG_CD","s,s,s,s,s",dupList);
			}

			if(dupCnt > 0) {
				resultCnt = -1; message="중복된 값이 존재합니다.";
			} else {
				resultCnt = appPeopleMgrService.saveAppPeopleMgr1(convertMap);
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
	 * 평가대상자생성/관리 저장(전체삭제)
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=deleteAppPeopleMgrAll", method = RequestMethod.POST )
	public ModelAndView deleteAppPeopleMgrAll(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();

		String message = "";
		int resultCnt = -1;

		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));

		try{
			resultCnt = appPeopleMgrService.deleteAppPeopleMgrAll(paramMap);
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
	 * 평가대상자생성 - 평가대상자생성 - 프로시저(평가대상자)
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=prcAppPeopleMgr1", method = RequestMethod.POST )
	public ModelAndView prcAppPeopleMgr1(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map map = appPeopleMgrService.prcAppPeopleMgr1(paramMap);

		if(map != null) {
			Log.Debug("obj : "+map);
			Log.Debug("sqlcode : "+map.get("sqlcode"));
			Log.Debug("sqlerrm : "+map.get("sqlerrm"));
			
			if (map.get("sqlcode") != null) {
				resultMap.put("Code", map.get("sqlcode").toString());
			}
			if (map.get("sqlerrm") != null) {
				resultMap.put("Message", map.get("sqlerrm").toString());
			}
		}

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Result", resultMap);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 평가대상자생성 - 평가대상자생성 - 프로시저(평가대상자)
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=prcAppPeopleMgr2", method = RequestMethod.POST )
	public ModelAndView prcAppPeopleMgr2(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map map = appPeopleMgrService.prcAppPeopleMgr2(paramMap);

		if(map != null) {
			Log.Debug("obj : "+map);
			Log.Debug("sqlcode : "+map.get("sqlcode"));
			Log.Debug("sqlerrm : "+map.get("sqlerrm"));
			
			if (map.get("sqlcode") != null) {
				resultMap.put("Code", map.get("sqlcode").toString());
			}
			if (map.get("sqlerrm") != null) {
				resultMap.put("Message", map.get("sqlerrm").toString());
			}
		}

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Result", resultMap);
		Log.DebugEnd();
		return mv;
	}


	/**
	 * 평가대상자생성 - 역량생성 대상자 체크
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveAppPeopleMgrTmp", method = RequestMethod.POST )
	public ModelAndView saveAppPeopleMgrTmp(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));

		int cnt = appPeopleMgrService.saveAppPeopleMgrTmp(paramMap, request.getParameterMap());


		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("Code", cnt);
		mv.addObject("Result", resultMap);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * KPI생성 - 프로시저 호출
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=prcAppPeopleMgr3", method = RequestMethod.POST )
	public ModelAndView prcAppPeopleMgr3(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();  
		return execPrc(session, request, paramMap);
	}
	
	/**
	 * 역량생성 - 프로시저 호출
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=prcAppPeopleMgr4", method = RequestMethod.POST )
	public ModelAndView prcAppPeopleMgr4(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();  
		return execPrc(session, request, paramMap);
	}

	/**
	 * 평가대상자 집계 단건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAppPeopleMgrMap2", method = RequestMethod.POST )
	public ModelAndView getAppPeopleMgrMap2(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataMap(session, request, paramMap);
	}

	/**
	 * 평가대상자 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAppPeopleMgrList1", method = RequestMethod.POST )
	public ModelAndView getAppPeopleMgrList1(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}

	/**
	 * 평가대상자생성/관리 평가그룹팝업 Popup View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewAppPeopleMgrLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewAppPeopleMgrLayer() throws Exception {
		return "pap/config/appPeopleMgr/appPeopleMgrLayer";
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

	/**
	 * 조직이동상세리스트 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAppPeopleMgrChgOrgList", method = RequestMethod.POST )
	public ModelAndView getAppPeopleMgrChgOrgList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}

	/**
	 * 평가대상자 생성  - 프로시저 호출
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=prcAppPeopleCreateMgr1", method = RequestMethod.POST )
	public ModelAndView prcAppPeopleCreateMgr1(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();  
		return execPrc(session, request, paramMap);
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
	@RequestMapping(params="cmd=prcAppPeopleCreateMgr2", method = RequestMethod.POST )
	public ModelAndView prcAppPeopleCreateMgr2(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();  
		return execPrc(session, request, paramMap);
	}

	/**
	 * 평가그룹 생성  - 프로시저 호출
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=prcAppPeopleCreateMgr3", method = RequestMethod.POST )
	public ModelAndView prcAppPeopleCreateMgr3(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();  
		return execPrc(session, request, paramMap);
	}

	/**
	 * 평가그룹 맵핑  - 프로시저 호출
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=prcAppPeopleCreateMgr4", method = RequestMethod.POST )
	public ModelAndView prcAppPeopleCreateMgr4(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();  
		return execPrc(session, request, paramMap);
	}

	/**
	 * 평가자 설정 팝업 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAppPeopleMgrList2", method = RequestMethod.POST )
	public ModelAndView getAppPeopleMgrList2(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}

	/**
	 * 평가자 설정 팝업  저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveAppPeopleMgr2", method = RequestMethod.POST )
	public ModelAndView saveAppPeopleMgr2(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return saveData(session, request, paramMap);
	}
}
