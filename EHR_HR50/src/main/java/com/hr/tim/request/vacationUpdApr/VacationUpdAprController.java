package com.hr.tim.request.vacationUpdApr;
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

import com.hr.common.atuhTable.AuthTableService;
import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;

/**
 * 근태취소승인관리 Controller
 *
 * @author bckim
 *
 */
@Controller
@RequestMapping(value="/VacationUpdApr.do", method=RequestMethod.POST )
public class VacationUpdAprController {

	/**
	 * 근태취소승인관리 서비스
	 */
	@Inject
	@Named("VacationUpdAprService")
	private VacationUpdAprService vacationUpdAprService;
	
	@Inject
	@Named("AuthTableService")
	private AuthTableService authTableService;

	/**
	 * vacationUpdApr View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewVacationUpdApr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewVacationUpdApr() throws Exception {
		return "tim/request/vacationUpdApr/vacationUpdApr";
	}
	
	/**
	 * vacationUpdApr 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getVacationUpdAprList", method = RequestMethod.POST )
	public ModelAndView getVacationUpdAprList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = vacationUpdAprService.getVacationUpdAprList(paramMap);
		}catch(Exception e){
			Message="조회에 실패 하였습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}
	
	/**
	 * 근태취소승인관리 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveVacationUpdApr", method = RequestMethod.POST )
	public ModelAndView saveVacationUpdApr(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		String getParamNames ="sNo,sDelete,sStatus,sabun,gntCd,sYmd,applSeq,updateGb";

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,getParamNames,"");
		convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

		String message = "";
		int resultCnt = -1;
		try{
			resultCnt = vacationUpdAprService.saveVacationUpdApr(convertMap);
			if(resultCnt > 0){ message=com.hr.common.language.LanguageUtil.getMessage("msg.alertSaveOkV1", null, "저장 되었습니다."); } else{ message=com.hr.common.language.LanguageUtil.getMessage("msg.alertSaveNoData", null, "저장된 내용이 없습니다."); }
		}catch(Exception e){
			resultCnt = -1; message=com.hr.common.language.LanguageUtil.getMessage("msg.alertSaveFail2", null, "저장에 실패하였습니다.");
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
