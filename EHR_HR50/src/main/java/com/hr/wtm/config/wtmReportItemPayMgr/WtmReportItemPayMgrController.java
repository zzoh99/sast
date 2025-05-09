package com.hr.wtm.config.wtmReportItemPayMgr;

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
 * 리포트항목지급관리 Controller
 */
@Controller
@RequestMapping(value="/WtmReportItemPayMgr.do", method=RequestMethod.POST )
public class WtmReportItemPayMgrController extends ComController {

	/**
	 * 리포트항목지급관리 서비스
	 */
	@Inject
	@Named("WtmReportItemPayMgrService")
	private WtmReportItemPayMgrService wtmReportItemPayMgrService;

	/**
	 * 리포트항목지급관리 View
	 *
	 * @return String
	 */
	@RequestMapping(params="cmd=viewWtmReportItemPayMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewWtmReportItemPayMgr() {
		return "wtm/config/wtmReportItemPayMgr/wtmReportItemPayMgr";
	}

	/**
	 * 리포트항목지급관리 리스트 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getWtmReportItemPayMgrList", method = RequestMethod.POST )
	public ModelAndView getWtmReportItemPayMgrList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));

		List<Map<String, Object>> result  = new ArrayList<>();
		String Message = "";
		try {
			result = wtmReportItemPayMgrService.getWtmReportItemPayMgrList(paramMap);
		} catch(Exception e) {
			Log.Error(" ** 리포트 항목 지급방법 리스트 조회 시 오류가 발생하였습니다. >> " + e.getMessage());
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
	 * 리포트항목지급관리 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveWtmReportItemPayMgr", method = RequestMethod.POST )
	public ModelAndView saveWtmReportItemPayMgr(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		convertMap.put("ssnSabun", session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));

		convertMap.putAll(paramMap);
		String message = "";
		int resultCnt = -1;
		try {
			resultCnt = wtmReportItemPayMgrService.saveWtmReportItemPayMgr(convertMap);

			if (resultCnt > 0) {
				message = "저장 되었습니다.";
			} else {
				message = "저장에 실패 하였습니다.";
			}
		} catch(Exception e) {
			Log.Error(" ** 리포트항목 지급방법 저장 시 오류가 발생하였습니다. >> " + e.getMessage());
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
	 * 리포트항목지급관리 리포트항목 리스트 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getWtmReportItemPayMgrItemCdList", method = RequestMethod.POST )
	public ModelAndView getWtmReportItemPayMgrItemCdList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));

		List<Map<String, Object>> result  = new ArrayList<>();
		String Message = "";
		try {
			result = wtmReportItemPayMgrService.getWtmReportItemPayMgrItemCdList(paramMap);
		} catch(Exception e) {
			Log.Error(" ** 리포트 항목ID 리스트 조회 시 오류가 발생하였습니다. >> " + e.getMessage());
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
