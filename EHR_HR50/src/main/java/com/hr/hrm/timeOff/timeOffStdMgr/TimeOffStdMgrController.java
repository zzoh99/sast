package com.hr.hrm.timeOff.timeOffStdMgr;

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
import com.hr.common.other.OtherService;
import com.hr.common.util.ParamUtils;

/**
 * 휴복직기준 관리 관리
 *
 * @author ParkMoohun
 */
@Controller
@RequestMapping(value="/TimeOffStdMgr.do", method=RequestMethod.POST )
public class TimeOffStdMgrController {

	@Inject
	@Named("TimeOffStdMgrService")
	private TimeOffStdMgrService timeOffStdMgrService;

	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;

	@Inject
	@Named("OtherService")
	private OtherService otherService;

	/**
	 * 휴복직기준 관리 관리 화면
	 *
	 * @param paramMap
	 * @param request
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewTimeOffStdMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewTimeOffStdMgr() throws Exception {
		Log.Debug("ApprovalMgrController.viewTimeOffStdMgr");
		return "hrm/timeOff/timeOffStdMgr/timeOffStdMgr";
	}
	/**
	 * 휴복직기준 관리 관리 Master 조회
	 *
	 * @param session
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getTimeOffStdMgrList", method = RequestMethod.POST )
	public ModelAndView getTimeOffStdMgrList(HttpSession session,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
		List<?> result = timeOffStdMgrService.getTimeOffStdMgrList(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView"); mv.addObject("DATA", result);
		Log.DebugEnd();
		return mv;
	}
	/**
	 * 휴복직기준 관리 관리 Master 조회
	 *
	 * @param session
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getTimeOffStdMgrTypeCodeList", method = RequestMethod.POST )
	public ModelAndView getTimeOffStdMgrTypeCodeList(HttpSession session,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
		paramMap.put("orgType", (paramMap.get("ordType")+"").split(","));
		List<?> result = timeOffStdMgrService.getTimeOffStdMgrTypeCodeList(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView"); mv.addObject("DATA", result);
		Log.DebugEnd();
		return mv;
	}
	/**
	 * 휴복직기준 관리 관리 Master 조회
	 *
	 * @param session
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getTimeOffStdMgrApplCodeList", method = RequestMethod.POST )
	public ModelAndView getTimeOffStdMgrApplCodeList(HttpSession session,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
		List<?> result = timeOffStdMgrService.getTimeOffStdMgrApplCodeList(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView"); mv.addObject("DATA", result);
		Log.DebugEnd();
		return mv;
	}
	/**
	 * 휴복직기준 관리 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveTimeOffStdMgr", method = RequestMethod.POST )
	public ModelAndView saveTimeOffStdMgr(HttpSession session,
			HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		convertMap.put("ssnSabun", 		session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
		String message = "";
		Map<String, Object> resultMap = new HashMap<String, Object>();
		int cnt = 0;
		try{ cnt = timeOffStdMgrService.saveTimeOffStdMgr(convertMap);
			if (cnt > 0) { message="저장 되었습니다."; }  else { message="저장된 내용이 없습니다."; }
		}catch(Exception e){ cnt=-1; message="저장 실패하였습니다."; }
		resultMap.put("Code", 		cnt); resultMap.put("Message", 	message);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView"); mv.addObject("Result", resultMap);
		Log.Debug("Result Message : " + mv);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 휴복직기준 관리 신청기준 정보 단건조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getTimeOffTypeTermMap", method = RequestMethod.POST )
	public ModelAndView getTimeoffTypeTermMap(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
		Map<?, ?> map = timeOffStdMgrService.getTimeOffTypeTermMap(paramMap);


		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", map);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 휴복직기준 관리 신청기준 정보 단건조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getTimeOffLimitTermCkMap", method = RequestMethod.POST )
	public ModelAndView getTimeoffLimitTermCkMap(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
		Map<?, ?> map = timeOffStdMgrService.getTimeOffLimitTermCkMap(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Data", map);
		Log.DebugEnd();
		return mv;
	}


}