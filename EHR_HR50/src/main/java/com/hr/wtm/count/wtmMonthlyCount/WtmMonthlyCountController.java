package com.hr.wtm.count.wtmMonthlyCount;

import com.hr.common.logger.Log;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.Map;


/**
 * 월근무집계 Controller
 *
 * @author bckim
 *
 */
@Controller
@RequestMapping(value="/WtmMonthlyCount.do", method=RequestMethod.POST )
public class WtmMonthlyCountController {

	/**
	 * 월근태/근무집계 서비스
	 */
	@Inject
	@Named("WtmMonthlyCountService")
	private WtmMonthlyCountService wtmMonthlyCountService;

	/**
	 * 월근태/근무집계 View
	 *
	 * @return String
	 */
	@RequestMapping(params="cmd=viewWtmMonthlyCount", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewWtmMonthlyCount() {
		return "wtm/count/wtmMonthlyCount/wtmMonthlyCount";
	}

	/**
	 * timWorkCount 단건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getWtmMonthlyCountStatus", method = RequestMethod.POST )
	public ModelAndView getWtmMonthlyCountStatus(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		Map<?, ?> map = null;
		String Message = "";

		try {
			map = wtmMonthlyCountService.getWtmMonthlyCountStatus(paramMap);
		} catch(Exception e) {
			Message = "조회에 실패하였습니다.";
		}

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", map);
		mv.addObject("Message", Message);

		Log.DebugEnd();
		return mv;
	}

	/**
	 * 월근태/근무집계(작업) 프로시저
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=excWtmMonthlyCount", method = RequestMethod.POST )
	public ModelAndView excWtmMonthlyCount(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();
		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		Map<String, Object> map = wtmMonthlyCountService.excWtmMonthlyCount(paramMap);

		Log.Debug("obj : "+map);
		Log.Debug("sqlcode : "+map.get("sqlcode"));
		Log.Debug("sqlerrm : "+map.get("sqlerrm"));

		Map<String, Object> resultMap = new HashMap<>();
		if (map.get("sqlCode") != null) {
			resultMap.put("Code", map.get("sqlCode").toString());
		}
		if (map.get("sqlErrm") != null) {
			resultMap.put("Message", map.get("sqlErrm").toString());
		}

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Result", resultMap);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 월근태/근무집계(작업취소) 프로시저
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=excWtmMonthlyCountCancel", method = RequestMethod.POST )
	public ModelAndView excWtmMonthlyCountCancel(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();
		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		Map<String, Object> map = wtmMonthlyCountService.excWtmMonthlyCountCancel(paramMap);

		Log.Debug("obj : "+map);
		Log.Debug("sqlcode : "+map.get("sqlcode"));
		Log.Debug("sqlerrm : "+map.get("sqlerrm"));

		Map<String, Object> resultMap = new HashMap<>();
		if (map.get("sqlCode") != null) {
			resultMap.put("Code", map.get("sqlCode").toString());
		}
		if (map.get("sqlErrm") != null) {
			resultMap.put("Message", map.get("sqlErrm").toString());
		}

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Result", resultMap);
		Log.DebugEnd();
		return mv;
	}
	
	/**
	 * 월근태/근무집계(마감)
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=updateWtmMonthlyCountClose", method = RequestMethod.POST )
	public ModelAndView updateWtmMonthlyCountClose(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));

		String message;
		int resultCnt = -1;
		try {
			resultCnt = wtmMonthlyCountService.updateWtmMonthlyCountClose(paramMap);
			if (resultCnt > 0) {
				message = "마감되었습니다.";
			} else {
				message = "마감에 실패하였습니다.";
			}
		} catch(Exception e) {
			message = "마감에 실패하였습니다.";
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
	 * 월근태/근무집계(마감취소)
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=updateWtmMonthlyCountCloseCancel", method = RequestMethod.POST )
	public ModelAndView updateWtmMonthlyCountCloseCancel(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));

		String message;
		int resultCnt = -1;
		try {
			resultCnt = wtmMonthlyCountService.updateWtmMonthlyCountCloseCancel(paramMap);
			if (resultCnt > 0) {
				message = "마감취소되었습니다.";
			} else {
				message = "마감취소에 실패하였습니다.";
			}
		} catch(Exception e) {
			message = "마감취소에 실패하였습니다.";
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
