package com.hr.cpn.payRetroact.retroExceAllowDedMgr;
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
 * 소급예외수당관리 Controller
 *
 * @author JM
 *
 */
@Controller
@RequestMapping(value="/RetroExceAllowDedMgr.do", method=RequestMethod.POST )
public class RetroExceAllowDedMgrController {

	/**
	 * 소급예외수당관리 서비스
	 */
	@Inject
	@Named("RetroExceAllowDedMgrService")
	private RetroExceAllowDedMgrService retroExceAllowDedMgrService;

	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;

	/**
	 * 소급예외수당관리 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewRetroExceAllowDedMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewRetroExceAllowDedMgr() throws Exception {
		return "cpn/payRetroact/retroExceAllowDedMgr/retroExceAllowDedMgr";
	}

	/**
	 * 소급예외수당관리 대상일자 팝업 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewRtrPayActionPopup", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewPeopleSetPopup() throws Exception {
		return "cpn/payRetroact/retroExceAllowDedMgr/retroExceAllowDedMgrRtrPayActionPopup";
	}
	@RequestMapping(params="cmd=viewRtrPayActionLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewRtrPayActionLayer() throws Exception {
		return "cpn/payRetroact/retroExceAllowDedMgr/retroExceAllowDedMgrRtrPayActionLayer";
	}

	/**
	 * 소급예외수당관리 대상일자 팝업 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewElementPopup", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewElementPopup() throws Exception {
		return "cpn/payRetroact/retroExceAllowDedMgr/retroExceAllowDedMgrElementPopup";
	}
	@RequestMapping(params="cmd=viewElementLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewElementLayer() throws Exception {
		return "cpn/payRetroact/retroExceAllowDedMgr/retroExceAllowDedMgrElementLayer";
	}

	/**
	 * 소급예외수당관리 Master 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getRetroExceAllowDedMgrList", method = RequestMethod.POST )
	public ModelAndView getRetroExceAllowDedMgrList(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

		List<?> list = new ArrayList<Object>();
		String Message = "";

		try{
			list = retroExceAllowDedMgrService.getRetroExceAllowDedMgrList(paramMap);
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
	 * 소급예외수당관리 Detail 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getRetroExceAllowDedMgrDtlList", method = RequestMethod.POST )
	public ModelAndView getRetroExceAllowDedMgrDtlList(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

		List<?> list = new ArrayList<Object>();
		String Message = "";

		try{
			list = retroExceAllowDedMgrService.getRetroExceAllowDedMgrDtlList(paramMap);
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
	 * 소급예외수당관리 대상일자 팝입 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getRetroExceAllowDedMgrRtrPayActionList", method = RequestMethod.POST )
	public ModelAndView getRetroExceAllowDedMgrRtrPayActionList(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		List<?> list = new ArrayList<Object>();
		String Message = "";

		try{
			list = retroExceAllowDedMgrService.getRetroExceAllowDedMgrRtrPayActionList(paramMap);
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
	 * 소급예외수당관리 항목명 팝입 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getRetroExceAllowDedMgrElementList", method = RequestMethod.POST )
	public ModelAndView getRetroExceAllowDedMgrElementList(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		List<?> list = new ArrayList<Object>();
		String Message = "";

		try{
			list = retroExceAllowDedMgrService.getRetroExceAllowDedMgrElementList(paramMap);
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
	 * 소급예외수당관리 Master 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveRetroExceAllowDedMgr", method = RequestMethod.POST )
	public ModelAndView saveRetroExceAllowDedMgr(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");

		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		convertMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		List<Map> insertList = (List<Map>)convertMap.get("insertRows");
		List<Map<String,Object>> dupList = new ArrayList<Map<String,Object>>();

		for(Map<String,Object> mp : insertList) {
			Map<String,Object> dupMap = new HashMap<String,Object>();
			dupMap.put("ENTER_CD",convertMap.get("ssnEnterCd"));
			dupMap.put("PAY_ACTION_CD",mp.get("payActionCd"));
			dupMap.put("RTR_PAY_ACTION_CD",mp.get("rtrPayActionCd"));
			dupMap.put("ELEMENT_CD",mp.get("elementCd"));
			dupList.add(dupMap);
		}

		String message = "";
		int resultCnt = -1;

		try{
			int dupCnt = 0;

			if(insertList.size() > 0) {
				// 중복체크
				dupCnt = commonCodeService.getDupCnt("TCPN519","ENTER_CD,PAY_ACTION_CD,RTR_PAY_ACTION_CD,ELEMENT_CD","s,s,s,s",dupList);
			}

			if(dupCnt > 0) {
				resultCnt = -1; message="중복된 값이 존재합니다.";
			} else {
				resultCnt = retroExceAllowDedMgrService.saveRetroExceAllowDedMgr(convertMap);
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
	 * 소급예외수당관리 Detail 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveRetroExceAllowDedMgrDtl", method = RequestMethod.POST )
	public ModelAndView saveRetroExceAllowDedMgrDtl(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");

		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		convertMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		List<Map> insertList = (List<Map>)convertMap.get("insertRows");
		List<Map<String,Object>> dupList = new ArrayList<Map<String,Object>>();

		for(Map<String,Object> mp : insertList) {
			Map<String,Object> dupMap = new HashMap<String,Object>();
			dupMap.put("ENTER_CD",convertMap.get("ssnEnterCd"));
			dupMap.put("SABUN",mp.get("sabun"));
			dupMap.put("PAY_ACTION_CD",mp.get("payActionCd"));
			dupMap.put("RTR_PAY_ACTION_CD",mp.get("rtrPayActionCd"));
			dupMap.put("ELEMENT_CD",mp.get("elementCd"));
			dupList.add(dupMap);
		}

		String message = "";
		int resultCnt = -1;

		try{
			int dupCnt = 0;

			if(insertList.size() > 0) {
				// 중복체크
				dupCnt = commonCodeService.getDupCnt("TCPN520","ENTER_CD,SABUN,PAY_ACTION_CD,RTR_PAY_ACTION_CD,ELEMENT_CD","s,s,s,s,s",dupList);
			}

			if(dupCnt > 0) {
				resultCnt = -1; message="중복된 값이 존재합니다.";
			} else {
				resultCnt = retroExceAllowDedMgrService.saveRetroExceAllowDedMgrDtl(convertMap);
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
	 * 소급예외수당관리 소급대상데이터 생성
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=prcP_CPN_PAY_RETROACT_MAKE_ITEM", method = RequestMethod.POST )
	public ModelAndView prcP_CPN_PAY_RETROACT_MAKE_ITEM(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		Map map = retroExceAllowDedMgrService.prcP_CPN_PAY_RETROACT_MAKE_ITEM(paramMap);

		Log.Debug("map[" + map + "] sqlcode[" + map.get("sqlcode") + "] sqlerrm[" + map.get("sqlerrm") + "]");

		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("Code", "0");

		if (map.get("sqlcode") != null && !"OK".equals(map.get("sqlcode").toString())) {
			resultMap.put("Code", map.get("sqlcode").toString());
			if (map.get("sqlerrm") != null) {
				resultMap.put("Message", map.get("sqlerrm").toString());
			} else {
				resultMap.put("Message", "항목생성 오류입니다.");
			}
		}

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Result", resultMap);

		Log.DebugEnd();
		return mv;
	}
}