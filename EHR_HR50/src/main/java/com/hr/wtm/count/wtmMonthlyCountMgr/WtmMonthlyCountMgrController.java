package com.hr.wtm.count.wtmMonthlyCountMgr;

import com.hr.common.com.ComController;
import com.hr.common.language.LanguageUtil;
import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;
import com.hr.tim.month.dailyWorkMgr.DailyWorkMgrService;
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
 * 월근태/근무관리 Controller
 *
 * @author JSG
 *
 */
@Controller
@RequestMapping(value="/WtmMonthlyCountMgr.do", method=RequestMethod.POST )
public class WtmMonthlyCountMgrController extends ComController {

	/**
	 * 월근태/근무관리 서비스
	 */
	@Inject
	@Named("WtmMonthlyCountMgrService")
	private WtmMonthlyCountMgrService wtmMonthlyCountMgrService;

	@Inject
	@Named("DailyWorkMgrService")
	private DailyWorkMgrService dailyWorkMgrService;

	/**
	 * 월근태/근무관리 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewWtmMonthlyCountMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewWtmMonthlyCountMgr() {
		return "wtm/count/wtmMonthlyCountMgr/wtmMonthlyCountMgr";
	}

	/**
	 * 월근태일수 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getWtmMonthlyCountMgrGntDays", method = RequestMethod.POST )
	public ModelAndView getWtmMonthlyCountMgrGntDays(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));

		List<?> list  = new ArrayList<>();
		String Message = "";
		try {
			list = wtmMonthlyCountMgrService.getWtmMonthlyCountMgrGntDays(paramMap);
		} catch(Exception e) {
			Log.Error(" ** 월근태일수 조회 시 오류가 발생하였습니다. >> " + e.getMessage());
			Message = LanguageUtil.getMessage("msg.alertSearchFail2", null, "조회에 실패하였습니다.");
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 월근태일수 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveWtmMonthlyCountMgrGntDays", method = RequestMethod.POST )
	public ModelAndView saveWtmMonthlyCountMgrGntDays(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		String message = "";
		int resultCnt = -1;
		try {
			resultCnt = wtmMonthlyCountMgrService.saveWtmMonthlyCountMgrGntDays(convertMap);
			if (resultCnt > 0) {
				message = "저장 되었습니다.";
			} else {
				message = "저장된 내용이 없습니다.";
			}
		} catch(Exception e) {
			Log.Error(" ** 월근태일수 저장 시 오류가 발생하였습니다. >> " + e.getMessage());
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
	 * 월근무시간 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getWtmMonthlyCountMgrWorkTime", method = RequestMethod.POST )
	public ModelAndView getWtmMonthlyCountMgrWorkTime(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));

		List<?> list  = new ArrayList<>();
		String Message = "";
		try {
			list = wtmMonthlyCountMgrService.getWtmMonthlyCountMgrWorkTime(paramMap);
		} catch(Exception e) {
			Log.Error(" ** 월근무시간 조회 시 오류가 발생하였습니다. >> " + e.getMessage());
			Message = LanguageUtil.getMessage("msg.alertSearchFail2", null, "조회에 실패하였습니다.");
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 월근무시간 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveWtmMonthlyCountMgrWorkTime", method = RequestMethod.POST )
	public ModelAndView saveWtmMonthlyCountMgrWorkTime(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		String message = "";
		int resultCnt = -1;
		try {
			resultCnt = wtmMonthlyCountMgrService.saveWtmMonthlyCountMgrWorkTime(convertMap);
			if (resultCnt > 0) {
				message = "저장 되었습니다.";
			} else {
				message = "저장된 내용이 없습니다.";
			}
		} catch(Exception e) {
			Log.Error(" ** 월근무시간 저장 시 오류가 발생하였습니다. >> " + e.getMessage());
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
	 * 월근무시간(근무코드별) 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getWtmMonthlyCountMgrWorkTimeByCodes", method = RequestMethod.POST )
	public ModelAndView getWtmMonthlyCountMgrWorkTimeByCodes(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));

		List<?> list  = new ArrayList<>();
		String Message = "";
		try {
			list = wtmMonthlyCountMgrService.getWtmMonthlyCountMgrWorkTimeByCodes(paramMap);
		} catch(Exception e) {
			Log.Error(" ** 월근무시간(근무코드별) 조회 시 오류가 발생하였습니다. >> " + e.getMessage());
			Message = LanguageUtil.getMessage("msg.alertSearchFail2", null, "조회에 실패하였습니다.");
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 월근무시간(근무코드별) 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveWtmMonthlyCountMgrWorkTimeByCodes", method = RequestMethod.POST )
	public ModelAndView saveWtmMonthlyCountMgrWorkTimeByCodes(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		String message = "";
		int resultCnt = -1;
		try {
			resultCnt = wtmMonthlyCountMgrService.saveWtmMonthlyCountMgrWorkTimeByCodes(convertMap);
			if (resultCnt > 0) {
				message = "저장 되었습니다.";
			} else {
				message = "저장된 내용이 없습니다.";
			}
		} catch(Exception e) {
			Log.Error(" ** 월근무시간(근무코드별) 저장 시 오류가 발생하였습니다. >> " + e.getMessage());
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
	 * 월근무일수 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getWtmMonthlyCountMgrWorkDays", method = RequestMethod.POST )
	public ModelAndView getWtmMonthlyCountMgrWorkDays(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));

		List<?> list  = new ArrayList<>();
		String Message = "";
		try {
			list = wtmMonthlyCountMgrService.getWtmMonthlyCountMgrWorkDays(paramMap);
		} catch(Exception e) {
			Log.Error(" ** 월근무일수 조회 시 오류가 발생하였습니다. >> " + e.getMessage());
			Message = LanguageUtil.getMessage("msg.alertSearchFail2", null, "조회에 실패하였습니다.");
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 월근무일수 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveWtmMonthlyCountMgrWorkDays", method = RequestMethod.POST )
	public ModelAndView saveWtmMonthlyCountMgrWorkDays(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		String message = "";
		int resultCnt = -1;
		try {
			resultCnt = wtmMonthlyCountMgrService.saveWtmMonthlyCountMgrWorkDays(convertMap);
			if (resultCnt > 0) {
				message = "저장 되었습니다.";
			} else {
				message = "저장된 내용이 없습니다.";
			}
		} catch(Exception e) {
			Log.Error(" ** 월근무일수 저장 시 오류가 발생하였습니다. >> " + e.getMessage());
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
	 * 일근무시간(근무코드별) 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getWtmMonthlyCountMgrDailyWorkTimeByCodes", method = RequestMethod.POST )
	public ModelAndView getWtmMonthlyCountMgrDailyWorkTimeByCodes(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));

		List<?> list  = new ArrayList<>();
		String Message = "";
		try {
			list = wtmMonthlyCountMgrService.getWtmMonthlyCountMgrDailyWorkTimeByCodes(paramMap);
		} catch(Exception e) {
			Log.Error(" ** 일근무시간(근무코드별) 조회 시 오류가 발생하였습니다. >> " + e.getMessage());
			Message = LanguageUtil.getMessage("msg.alertSearchFail2", null, "조회에 실패하였습니다.");
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 일근무시간(근무코드별) 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveWtmMonthlyCountMgrDailyWorkTimeByCodes", method = RequestMethod.POST )
	public ModelAndView saveWtmMonthlyCountMgrDailyWorkTimeByCodes(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		String message = "";
		int resultCnt = -1;
		try {
			resultCnt = wtmMonthlyCountMgrService.saveWtmMonthlyCountMgrDailyWorkTimeByCodes(convertMap);
			if (resultCnt > 0) {
				message = "저장 되었습니다.";
			} else {
				message = "저장된 내용이 없습니다.";
			}
		} catch(Exception e) {
			Log.Error(" ** 일근무시간(근무코드별) 저장 시 오류가 발생하였습니다. >> " + e.getMessage());
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
	 * 근무코드 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getWtmMonthlyCountMgrHeaders", method = RequestMethod.POST )
	public ModelAndView getWtmMonthlyCountMgrHeaders(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));

		List<?> list  = new ArrayList<>();
		String Message = "";
		try {
			list = wtmMonthlyCountMgrService.getWtmMonthlyCountMgrHeaders(paramMap);
		} catch(Exception e) {
			Log.Error(" ** 근무코드 조회 시 오류가 발생하였습니다. >> " + e.getMessage());
			Message = LanguageUtil.getMessage("msg.alertSearchFail2", null, "조회에 실패하였습니다.");
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}
}