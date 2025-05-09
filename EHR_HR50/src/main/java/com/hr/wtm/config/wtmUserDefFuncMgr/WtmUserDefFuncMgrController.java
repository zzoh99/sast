package com.hr.wtm.config.wtmUserDefFuncMgr;

import com.hr.common.code.CommonCodeService;
import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
/**
 * 사용자정의함수 Controller
 * 
 * @author 이름
 *
 */
@Controller
@RequestMapping(value="/WtmUserDefFuncMgr.do", method=RequestMethod.POST )
public class WtmUserDefFuncMgrController {
	/**
	 * 사용자정의함수 서비스
	 */
	@Inject
	@Named("WtmUserDefFuncMgrService")
	private WtmUserDefFuncMgrService wtmUserDefFuncMgrService;
	
	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;
	
	/**
	 * 사용자정의함수 View
	 * 
	 * @return String
	 */
	@RequestMapping(params="cmd=viewWtmUserDefFuncMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewWtmUserDefFuncMgr() {
		return "wtm/config/wtmUserDefFuncMgr/wtmUserDefFuncMgr";
	}

	/**
	 * 사용자정의함수 Master 다건 조회
	 * 
	 * @param session
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getWtmUserDefFuncMgrFirstList", method = RequestMethod.POST )
	public ModelAndView getWtmUserDefFuncMgrFirstList(
			HttpSession session,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<>();
		String Message = "";
		try {
			list = wtmUserDefFuncMgrService.getWtmUserDefFuncMgrFirstList(paramMap);
		} catch(Exception e) {
			Log.Error(" ** 사용자정의함수 Master 정보 조회 시 오류가 발생하였습니다. >> " + e.getLocalizedMessage());
			Message = "조회에 실패하였습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 사용자정의함수 Detail 다건 조회
	 * 
	 * @param session
	 * @param paramMap
	 * @return ModelAndView
	 */
	@RequestMapping(params="cmd=getWtmUserDefFuncMgrSecondList", method = RequestMethod.POST )
	public ModelAndView getWtmUserDefFuncMgrSecondList(
			HttpSession session,
			@RequestParam Map<String, Object> paramMap ) {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<>();
		String Message = "";
		try {
			list = wtmUserDefFuncMgrService.getWtmUserDefFuncMgrSecondList(paramMap);
		} catch(Exception e) {
			Log.Error(" ** 사용자정의함수 Detail 정보 조회 시 오류가 발생하였습니다. >> " + e.getLocalizedMessage());
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
	 * 사용자정의함수 Master 저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 */
	@RequestMapping(params="cmd=saveWtmUserDefFuncMgrFirst", method = RequestMethod.POST )
	public ModelAndView saveWtmUserDefFuncMgrFirst(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) {
		// comment 시작
		Log.DebugStart();

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

		List<Map<String, Object>> insertList = (List<Map<String, Object>>)convertMap.get("insertRows");
		List<Map<String, Object>> dupList = new ArrayList<>();
		
		for(Map<String, Object> mp : insertList) {
			Map<String, Object> dupMap = new HashMap<>();
			dupMap.put("ENTER_CD", convertMap.get("ssnEnterCd"));
			dupMap.put("UDF_CD", mp.get("udfCd"));
			dupList.add(dupMap);
		}
		
		String message = "";
		int resultCnt = -1;
		
		try {
			int dupCnt = 0;

			if (!insertList.isEmpty()) {
				// 중복체크
				dupCnt = commonCodeService.getDupCnt("TSYS801","ENTER_CD,UDF_CD","s,s",dupList);
			}

			if (dupCnt > 0) {
				message = "중복된 값이 존재합니다.";
			} else {
				resultCnt = wtmUserDefFuncMgrService.saveWtmUserDefFuncMgrFirst(convertMap);
				if (resultCnt > 0) {
					message="저장 되었습니다.";
				} else {
					message="저장된 내용이 없습니다.";
				}
			}
		} catch(Exception e) {
			Log.Error(" ** 사용자정의함수 Master 저장 시 오류가 발생하였습니다. >> " + e.getLocalizedMessage());
			message = "저장에 실패하였습니다.";
		}
		
		Map<String, Object> resultMap = new HashMap<>();
		resultMap.put("Code", resultCnt);
		resultMap.put("Message", message);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Result", resultMap);
		Log.DebugEnd();
		return mv;
	}
	
	/**
	 * 항목링크(계산식) 저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 */
	@RequestMapping(params="cmd=saveWtmUserDefFuncMgrSecond", method = RequestMethod.POST )
	public ModelAndView saveWtmUserDefFuncMgrSecond(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) {
		// comment 시작
		Log.DebugStart();

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

		List<Map<String, Object>> insertList = (List<Map<String, Object>>)convertMap.get("insertRows");
		List<Map<String, Object>> dupList = new ArrayList<>();
		
		for(Map<String, Object> mp : insertList) {
			Map<String, Object> dupMap = new HashMap<>();
			dupMap.put("ENTER_CD",convertMap.get("ssnEnterCd"));
			dupMap.put("UDF_CD",mp.get("udfCd"));
			dupMap.put("SEQ",mp.get("seq"));
			dupList.add(dupMap);
		}
		
		String message = "";
		int resultCnt = -1;
		
		try {
			int dupCnt = 0;

			if (!insertList.isEmpty()) {
				// 중복체크
				dupCnt = commonCodeService.getDupCnt("TSYS803","ENTER_CD,UDF_CD,SEQ","s,s,s",dupList);
			}

			if (dupCnt > 0) {
				message = "중복된 값이 존재합니다.";
			} else {
				resultCnt = wtmUserDefFuncMgrService.saveWtmUserDefFuncMgrSecond(convertMap);
				if (resultCnt > 0) {
					message="저장 되었습니다.";
				} else {
					message="저장된 내용이 없습니다.";
				}
			}
		} catch(Exception e) {
			Log.Error(" ** 사용자정의함수 Detail 저장 시 오류가 발생하였습니다. >> " + e.getLocalizedMessage());
			message = "저장에 실패하였습니다.";
		}
		
		Map<String, Object> resultMap = new HashMap<>();
		resultMap.put("Code", resultCnt);
		resultMap.put("Message", message);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Result", resultMap);
		Log.DebugEnd();
		return mv;
	}
}