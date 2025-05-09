package com.hr.tim.request.vacationApr;
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
import com.hr.common.code.CommonCodeService;
import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;

/**
 * 근태승인관리 Controller
 *
 * @author JSG
 *
 */
@Controller
@RequestMapping(value="/VacationApr.do", method=RequestMethod.POST )
public class VacationAprController {

	/**
	 * 근태승인관리 서비스
	 */
	@Inject
	@Named("VacationAprService")
	private VacationAprService vacationAprService;
	
	@Inject
	@Named("AuthTableService")
	private AuthTableService authTableService;

	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;

	/**
	 * vacationApr View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewVacationApr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewVacationApr() throws Exception {
		return "tim/request/vacationApr/vacationApr";
	}
	
	/**
	 * 근태승인관리 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getVacationAprList", method = RequestMethod.POST )
	public ModelAndView getVacationAprList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		Map<?, ?> query = authTableService.getAuthQueryMap(paramMap);
		Log.Debug("query.get=> "+ query.get("query"));
		paramMap.put("query",query.get("query"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = vacationAprService.getVacationAprList(paramMap);

		}catch(Exception e){
			Message=com.hr.common.language.LanguageUtil.getMessage("msg.alertMsg13", null, "조회에 실패 하였습니다.");
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 근태승인관리 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveVacationApr", method = RequestMethod.POST )
	public ModelAndView saveVacationApr(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		//String getParamNames ="sNo,sDelete,sStatus,sabun,gntCd,sYmd,applSeq";

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

		String message = "";
		int resultCnt = -1;
		try{
			resultCnt = vacationAprService.saveVacationApr(convertMap);
			if(resultCnt > 0){ message="저장 되었습니다."; } else{ message="저장된 내용이 없습니다."; }
		}catch(Exception e){
			resultCnt = -1; message="저장에 실패 하였습니다.";
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
