package com.hr.tim.schedule.workScheduleAppDet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import com.hr.common.util.DateUtil;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;
import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;
import com.hr.tim.schedule.workScheduleApp.WorkScheduleAppService;
import com.hr.common.com.ComController;
import com.hr.common.language.LanguageUtil;
/**
 * 근무스케쥴신청 Controller
 *
 * @author JSG
 *
 */
@Controller
@RequestMapping({"/WorkScheduleAppDet.do", "/WorkScheduleApp.do"})
public class WorkScheduleAppDetController extends ComController {
	/**
	 * 근무스케쥴신청 서비스
	 */
	@Inject
	@Named("WorkScheduleAppDetService")
	private WorkScheduleAppDetService workScheduleAppDetService;

	
    @RequestMapping(params="cmd=viewWorkScheduleAppDet", method = {RequestMethod.POST, RequestMethod.GET} )
    public String viewWorkScheduleAppDet() throws Exception {
        return "tim/schedule/workScheduleAppDet/workScheduleAppDet";
    }
    
	/**
	 * 부서근무스케쥴 신청 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getWorkScheduleAppDet", method = RequestMethod.POST )
	public ModelAndView getWorkScheduleAppDet(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataMap(session, request, paramMap);
	}

	/**
	 * 근무조 조회 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getWorkScheduleAppDetWorkOrg", method = RequestMethod.POST )
	public ModelAndView getWorkScheduleAppDetWorkOrg(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataMap(session, request, paramMap);
	}

	/**
	 * 근무한도 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getWorkScheduleAppDetLimit", method = RequestMethod.POST )
	public ModelAndView getWorkScheduleAppDetLimit(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataMap(session, request, paramMap);
	}

	/**
	 * 기 신청 건 체크 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getWorkScheduleAppDetDupCnt", method = RequestMethod.POST )
	public ModelAndView getWorkScheduleAppDetDupCnt(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataMap(session, request, paramMap);
	}
	
	/**
	 * 부서근무스케쥴 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getWorkScheduleAppDetList", method = RequestMethod.POST )
	public ModelAndView getWorkScheduleAppWorkList(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();

		List<?> titleList = workScheduleAppDetService.getWorkScheduleAppDetHeaderList(paramMap);
		paramMap.put("titles", titleList);
		if (titleList.isEmpty()) {
			ModelAndView mv = new ModelAndView();
			mv.setViewName("jsonView");
			mv.addObject("DATA", new ArrayList<>());
			String searchSYmd = DateUtil.convertLocalDateToString(DateUtil.getLocalDate((String) paramMap.get("searchSYmd")), "yyyy.MM.dd");
			String searchEYmd = DateUtil.convertLocalDateToString(DateUtil.getLocalDate((String) paramMap.get("searchEYmd")), "yyyy.MM.dd");
			mv.addObject("Message", "대상자의 " + searchSYmd + " ~ " + searchEYmd + " 기간의 개인근무스케줄이 생성되지 않았습니다. 담당자에게 문의 바랍니다.");
			return mv;
		}
		
		return getDataList(session, request, paramMap);
	}
	
	/**
	 * 부서근무스케쥴 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getWorkScheduleAppDetHeaderList", method = RequestMethod.POST )
	public ModelAndView getWorkScheduleAppDetHeaderList(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}
	
	/**
	 * 근무스케쥴신청 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveWorkScheduleAppDet", method = RequestMethod.POST )
	public ModelAndView saveWorkScheduleAppDet(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

		String message = "";
		int resultCnt = -1;
		try{
			resultCnt = workScheduleAppDetService.saveWorkScheduleAppDet(convertMap);
			if(resultCnt > 0){ message="저장 되었습니다."; } else{ message="저장된 내용이 없습니다."; }
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

}
