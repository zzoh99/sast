package com.hr.tim.code.payWayMgr.payWorkTimeRewardTab;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import com.hr.tim.schedule.flexibleWorkOrgMgr.FlexibleWorkOrgMgrService;
import com.hr.tim.schedule.flexibleWorkOrgMgrPop.FlexibleWorkOrgMgrPopService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.hr.common.code.CommonCodeService;
import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;

/**
 * 근무보상기준관리 Controller
 *
 * @author
 *
 */
@Controller
@RequestMapping(value="/PayWorkTimeRewardTab.do", method=RequestMethod.POST )
public class PayWorkTimeRewardTabController {

	/**
	 * 근무보상기준관리 서비스
	 */
	@Inject
	@Named("PayWorkTimeRewardTabService")
	private PayWorkTimeRewardTabService payWorkTimeRewardTabService;

	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;

	/**
	 * 근무제대상자관리 범위설정 팝업 서비스
	 * 조직범위설정 Layer를 위함
	 */
	@Inject
	@Named("FlexibleWorkOrgMgrPopService")
	private FlexibleWorkOrgMgrPopService flexibleWorkOrgMgrPopService;

	/**
	 * 근무제대상자관리 서비스
	 */
	@Inject
	@Named("FlexibleWorkOrgMgrService")
	private FlexibleWorkOrgMgrService flexibleWorkOrgMgrService;


	/**
	 *  근무보상기준관리 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewPayWorkTimeRewardTab", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewPayWorkTimeRewardTab() throws Exception {
		return "tim/code/payWayMgr/payWorkTimeRewardTab/payWorkTimeRewardTab";
	}

	/**
	 * 근무보상기준관리 - 조직범위설정 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewPayWorkTimeRewardTabOrgLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewPayWorkTimeRewardTabOrgLayer() throws Exception {
		return "tim/code/payWayMgr/payWorkTimeRewardTab/payWorkTimeRewardTabOrgLayer";
	}

	/**
	 * 근무보상기준관리 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPayWorkTimeRewardTabList", method = RequestMethod.POST )
	public ModelAndView getPayWorkTimeRewardTabList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		List<?> list  = new ArrayList<Object>();
		String Message = "";
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		try{
			list = payWorkTimeRewardTabService.getPayWorkTimeRewardTabList(paramMap);
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
	 * 근무보상기준관리 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=savePayWorkTimeRewardTab", method = RequestMethod.POST )
	public ModelAndView savePayWorkTimeRewardTab(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		convertMap.put("ssnSabun", session.getAttribute("ssnSabun"));

		List<Map> insertList = (List<Map>)convertMap.get("insertRows");
		List<Map<String,Object>> dupList = new ArrayList<Map<String,Object>>();

		for(Map<String,Object> mp : insertList) {
			Map<String,Object> dupMap = new HashMap<String,Object>();
			dupMap.put("ENTER_CD",convertMap.get("ssnEnterCd"));
			dupMap.put("REWARD_NM",mp.get("rewardNm"));
			dupMap.put("SDATE",mp.get("sdate"));
			dupList.add(dupMap);
		}
		String message = "";
		int resultCnt = -1;
		try{
			int dupCnt = 0;

			if(insertList.size() > 0) {
				// 중복검사
				dupCnt = commonCodeService.getDupCnt("TTIM012", "ENTER_CD,REWARD_NM,SDATE", "s,s,s",dupList);
			}
			if(dupCnt > 0) {
				resultCnt = -1; message="중복되어 저장할 수 없습니다.";
			} else {
				resultCnt = payWorkTimeRewardTabService.savePayWorkTimeRewardTab(convertMap);
				if(resultCnt > 0){ message="저장 되었습니다."; } else{ message="저장된 내용이 없습니다."; }
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
	 * 근무보상기준관리 - 조직범위 다건 조회 (근무제대상자관리 Service 참조)
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPayWorkTimeRewardTabScopeCd", method = RequestMethod.POST )
	public ModelAndView getPayWorkTimeRewardTabScopeCd(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		List<?> list  = new ArrayList<Object>();
		String Message = "";
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		try{
			list = flexibleWorkOrgMgrService.getFlexibleWorkOrgMgrScopeCd(paramMap);
		}catch(Exception e){
			Message="조회에 실패하였습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 근무보상기준관리 - 조직범위설정 다건 조회 (근무제대상자관리 팝업 Service 참조)
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPayWorkTimeRewardTabOrgLayerList", method = RequestMethod.POST )
	public ModelAndView getPayWorkTimeRewardTabOrgLayerList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		List<?> list  = new ArrayList<Object>();
		String Message = "";
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		try{

			list = flexibleWorkOrgMgrPopService.getFlexibleWorkOrgMgrPopList3(paramMap);
		}catch(Exception e){
			Message="조회에 실패하였습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 근무보상기준관리 - 조직범위설정 저장 (근무제대상자관리 팝업 Service 참조)
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(params="cmd=savePayWorkTimeRewardTabOrgLayer", method = RequestMethod.POST )
	public ModelAndView savePayWorkTimeRewardTabOrgLayer(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

		convertMap.put("searchUseGubun",paramMap.get("searchUseGubun"));
		convertMap.put("searchItemValue1",paramMap.get("searchItemValue1"));
		convertMap.put("searchItemValue2",paramMap.get("searchItemValue2"));
		convertMap.put("searchItemValue3",paramMap.get("searchItemValue3"));
		convertMap.put("searchAuthScopeCd",paramMap.get("searchAuthScopeCd"));

		List<Map<String, Object>> insertList = (List<Map<String, Object>>)convertMap.get("insertRows");
		List<Map<String,Object>> dupList = new ArrayList<Map<String,Object>>();

		for(Map<String,Object> mp : insertList) {
			Map<String,Object> dupMap = new HashMap<String,Object>();
			dupMap.put("ENTER_CD",session.getAttribute("ssnEnterCd"));
			dupMap.put("USE_GUBUN",paramMap.get("searchUseGubun"));
			dupMap.put("ITEM_VALUE2",paramMap.get("searchItemValue2"));
			dupMap.put("ITEM_VALUE3",paramMap.get("searchItemValue3"));
			dupMap.put("SCOPE_CD",paramMap.get("searchAuthScopeCd"));
			dupMap.put("SCOPE_VALUE",mp.get("scopeValue"));

			dupList.add(dupMap);
		}

		String message = "";
		int resultCnt = -1;

		try{
			int dupCnt = 0;

			if(insertList.size() > 0) {
				// 중복검사
				dupCnt = commonCodeService.getDupCnt("TTIM223", "ENTER_CD,USE_GUBUN,ITEM_VALUE2,ITEM_VALUE3,SCOPE_CD,SCOPE_VALUE", "s,s,s,s,s,s",dupList);
			}

			if(dupCnt > 0) {
				resultCnt = -1; message="선택하신 조직이 이미 다른 근무제에 등록되었습니다.";
			} else {
				resultCnt =flexibleWorkOrgMgrPopService.saveFlexibleWorkOrgMgrPop(convertMap);
				if(resultCnt > 0){ message="저장 되었습니다."; } else{ message="저장된 내용이 없습니다."; }
			}
		}catch(Exception e){
			resultCnt = -1; message="저장에 실패 하였습니다.";
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
