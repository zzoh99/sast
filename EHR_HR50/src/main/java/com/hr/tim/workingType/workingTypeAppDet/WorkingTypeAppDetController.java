package com.hr.tim.workingType.workingTypeAppDet;

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
 * 신청서 세부내역 Controller
 *
 * @author bckim
 *
 */
@Controller
@RequestMapping({"/WorkingTypeAppDet.do", "/WorkingTypeApp.do"})
public class WorkingTypeAppDetController {

	/**
	 * 근무시간단축 신청 세부내역 서비스
	 */
	@Inject
	@Named("WorkingTypeAppDetService")
	private WorkingTypeAppDetService workingTypeAppDetService;

	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;

	/**
	 * 근무시간단축 신청 세부내역 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewWorkingTypeAppDet", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewWorkingTypeAppDet() throws Exception {
		return "tim/workingType/workingTypeAppDet/workingTypeAppDet";
	}

	/**
	 * 근무시간단축 신청 세부내역 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getWorkingTypeAppDetList", method = RequestMethod.POST )
	public ModelAndView getWorkingTypeAppDetList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = workingTypeAppDetService.getWorkingTypeAppDetList(paramMap);

		}catch(Exception e){
			Message="조회에 실패하였습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("size", "15");
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}


	/**
	 * 신청 세부내역 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveWorkingTypeAppDet", method = RequestMethod.POST )
	public ModelAndView saveWorkingTypeAppDet(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		String getParamNames ="sNo,sStatus,sabun,applSeq,applCd,applYmd,joinYmd,"
				+ "pregnancyYmd,workingType,swtApplyStrYmd,swtApplyEndYmd,swtCaStrYmd,"
				+ "swtCaEndYmd,gestatioYmd,swtStrH,swtEndH,shortenHour,appWorkHour,approvalYn,childrenCd,childrenNm,"
				+ "birthYmd,dueDate,childrenYear,familyNm,familyRelations,swtCaReason,lookAfterReason,"
				+ "reason,causeOfReturn,replaceAction";
		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,getParamNames,"");
		
		/*Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");*/
		
		convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

		String message = "";
		int resultCnt = -1;
		try{
			resultCnt = workingTypeAppDetService.saveWorkingTypeAppDet(convertMap);
			if(resultCnt > 0){ message="저장되었습니다."; } else{ message="저장된 내용이 없습니다."; }
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
	 * 생년월일 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getBirthYmd", method = RequestMethod.POST )
	public ModelAndView getBirthYmd(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();

		List<?> result = workingTypeAppDetService.getBirthYmd(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("birthYmd", result);
		Log.DebugEnd();
		return mv;
	}
	/**
	 * 생년월일 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getFlexChk", method = RequestMethod.POST )
	public ModelAndView getFlexChk(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		
		List<?> result = workingTypeAppDetService.getFlexChk(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("flexChk", result);
		Log.DebugEnd();
		return mv;
	}

	
}
