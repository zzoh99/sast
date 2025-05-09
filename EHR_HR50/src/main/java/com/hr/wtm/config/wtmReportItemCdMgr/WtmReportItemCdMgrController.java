package com.hr.wtm.config.wtmReportItemCdMgr;

import com.hr.common.com.ComController;
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
 * 리포트항목관리 Controller
 */
@Controller
@RequestMapping(value="/WtmReportItemCdMgr.do", method=RequestMethod.POST )
public class WtmReportItemCdMgrController extends ComController {

	/**
	 * 리포트항목관리 서비스
	 */
	@Inject
	@Named("WtmReportItemCdMgrService")
	private WtmReportItemCdMgrService wtmReportItemCdMgrService;

	/**
	 * 리포트항목관리 View
	 *
	 * @return String
	 */
	@RequestMapping(params="cmd=viewWtmReportItemCdMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewWtmReportItemCdMgr() {
		return "wtm/config/wtmReportItemCdMgr/wtmReportItemCdMgr";
	}

	/**
	 * 리포트항목관리 리스트 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getWtmReportItemCdMgrList", method = RequestMethod.POST )
	public ModelAndView getWtmReportItemCdMgrList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));

		List<Map<String, Object>> result  = new ArrayList<>();
		String Message = "";
		try {
			result = wtmReportItemCdMgrService.getWtmReportItemCdMgrList(paramMap);
		} catch(Exception e) {
			Log.Error(" ** 리포트 항목 리스트 조회 시 오류가 발생하였습니다. >> " + e.getMessage());
			Message = "조회에 실패 하였습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", result);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 리포트항목코드 단건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getWtmReportItemCdMgrOne", method = RequestMethod.POST )
	public ModelAndView getWtmReportItemCdMgrOne(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));

		Map<String, Object> result  = new HashMap<>();
		String Message = "";
		try {
			result = wtmReportItemCdMgrService.getWtmReportItemCdMgrOne(paramMap);
		} catch(Exception e) {
			Log.Error(" ** 리포트 항목 조회 시 오류가 발생하였습니다. >> " + e.getMessage());
			Message = "조회에 실패 하였습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", result);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 리포트항목관리 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveWtmReportItemCdMgr", method = RequestMethod.POST )
	public ModelAndView saveWtmReportItemCdMgr(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		Map<String, Object> convertMap = new HashMap<>();
		convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

		convertMap.putAll(paramMap);
		String message = "";
		int resultCnt = -1;
		try {
			resultCnt = wtmReportItemCdMgrService.saveWtmReportItemCdMgr(convertMap);

			if (resultCnt > 0) {
				message = "저장 되었습니다.";
			} else {
				message = "저장에 실패 하였습니다.";
			}
		} catch(Exception e) {
			Log.Error(" ** 리포트항목 저장 시 오류가 발생하였습니다. >> " + e.getMessage());
			message = "저장에 실패 하였습니다.";
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
	 * 리포트항목관리 삭제
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=deleteWtmReportItemCdMgr", method = RequestMethod.POST )
	public ModelAndView deleteWtmReportItemCdMgr(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

		String message = "";
		int resultCnt = -1;
		try{
			resultCnt = wtmReportItemCdMgrService.deleteWtmReportItemCdMgr(convertMap);
			if(resultCnt > 0){ message="삭제 되었습니다."; } else{ message="삭제된 내용이 없습니다."; }
		}catch(Exception e){
			resultCnt = -1; message="삭제에 실패 하였습니다.";
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
	 * 리포트항목관리 계산방법 코드리스트 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getWtmReportItemCdMgrMethodCdList", method = RequestMethod.POST )
	public ModelAndView getWtmReportItemCdMgrMethodCdList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));

		List<Map<String, Object>> result  = new ArrayList<>();
		String Message = "";
		try {
			result = wtmReportItemCdMgrService.getWtmReportItemCdMgrMethodCdList(paramMap);
		} catch(Exception e) {
			Log.Error(" ** 계산방법 코드 리스트 조회 시 오류가 발생하였습니다. >> " + e.getMessage());
			Message = "조회에 실패 하였습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("codeList", result);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}
}
