package com.hr.tim.schedule.flexibleWorkOrgMgrPop;

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
import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;
/**
 * 근무제대상자관리 - 범위설정 Controller
 *
 * @author jcy
 *
 */
@Controller
@RequestMapping(value="/FlexibleWorkOrgMgrPop.do", method=RequestMethod.POST )
public class FlexibleWorkOrgMgrPopController {

	/**
	 * 근무제대상자관리 - 범위설정 서비스
	 */
	@Inject
	@Named("FlexibleWorkOrgMgrPopService")
	private FlexibleWorkOrgMgrPopService flexibleWorkOrgMgrPopService;

	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;

	/**
	 * 근무제대상자관리 - 범위설정 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewFlexibleWorkOrgMgrPop", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewFlexibleWorkOrgMgrPop() throws Exception {
		return "tim/schedule/flexibleWorkOrgMgrPop/flexibleWorkOrgMgrPop";
	}

	/**
	 * 근무제대상자관리 - 범위설정 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewFlexibleWorkOrgMgrOrgPop", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewFlexibleWorkOrgMgrOrgPop() throws Exception {
		return "tim/schedule/flexibleWorkOrgMgrPop/flexibleWorkOrgMgrOrgPop";
	}

	/**
	 * 근무제대상자관리 - 범위설정 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewFlexibleWorkOrgMgrPersonPop", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewflexibleWorkOrgMgrPersonPop() throws Exception {
		return "tim/schedule/flexibleWorkOrgMgrPop/flexibleWorkOrgMgrPersonPop";
	}

	/**
	 * 근무제대상자관리 - 범위설정 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getFlexibleWorkOrgMgrPopList1", method = RequestMethod.POST )
	public ModelAndView getFlexibleWorkOrgMgrPopList1(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		List<?> list  = new ArrayList<Object>();
		String Message = "";
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		try{
			list = flexibleWorkOrgMgrPopService.getFlexibleWorkOrgMgrPopList1(paramMap);
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
	 * 근무제대상자관리 - 범위설정 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getFlexibleWorkOrgMgrPopList2", method = RequestMethod.POST )
	public ModelAndView getFlexibleWorkOrgMgrPopList2(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		List<?> list  = new ArrayList<Object>();
		String Message = "";
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		try{
			Map<?, ?> query = flexibleWorkOrgMgrPopService.getFlexibleWorkOrgMgrPopTempQueryMap(paramMap);
			if(query != null) {
				paramMap.put("query",query.get("query"));
				list = flexibleWorkOrgMgrPopService.getFlexibleWorkOrgMgrPopList2(paramMap);
			} else {
				Message="조회에 실패하였습니다.";
			}
		} catch(Exception e) {
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
	 * 근무제대상자관리 - 범위설정 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getFlexibleWorkOrgMgrPopList3", method = RequestMethod.POST )
	public ModelAndView getFlexibleWorkOrgMgrPopList3(
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
	 * 근무제대상자관리 - 범위설정 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getFlexibleWorkOrgMgrPopList4", method = RequestMethod.POST )
	public ModelAndView getFlexibleWorkOrgMgrPopList4(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		List<?> list  = new ArrayList<Object>();
		String Message = "";
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		try{

			list = flexibleWorkOrgMgrPopService.getFlexibleWorkOrgMgrPopList4(paramMap);
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
	 * 근무제대상자관리 - 범위설정 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getFlexibleWorkOrgMgrPopList5", method = RequestMethod.POST )
	public ModelAndView getFlexibleWorkOrgMgrPopList5(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		List<?> list  = new ArrayList<Object>();
		String Message = "";
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		try{

			list = flexibleWorkOrgMgrPopService.getFlexibleWorkOrgMgrPopList5(paramMap);
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
	 * 근무제대상자관리 - 범위설정 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getFlexibleWorkOrgMgrPopList6", method = RequestMethod.POST )
	public ModelAndView getFlexibleWorkOrgMgrPopList6(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		List<?> list  = new ArrayList<Object>();
		String Message = "";
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		try{

			list = flexibleWorkOrgMgrPopService.getFlexibleWorkOrgMgrPopList6(paramMap);
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
	 * 근무제대상자관리 - 범위설정 단건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getFlexibleWorkOrgMgrPopMap", method = RequestMethod.POST )
	public ModelAndView getFlexibleWorkOrgMgrPopMap(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		Map<?, ?> map = flexibleWorkOrgMgrPopService.getFlexibleWorkOrgMgrPopMap(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("map", map);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 근무제대상자관리 - 범위설정 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(params="cmd=saveFlexibleWorkOrgMgrPop", method = RequestMethod.POST )
	public ModelAndView saveFlexibleWorkOrgMgrPop(
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