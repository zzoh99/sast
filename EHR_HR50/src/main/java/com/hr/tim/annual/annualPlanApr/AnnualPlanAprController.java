package com.hr.tim.annual.annualPlanApr;
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
 * annualPlanApr Controller
 *
 * @author EW
 *
 */
@Controller
@RequestMapping(value="/AnnualPlanApr.do", method=RequestMethod.POST )
public class AnnualPlanAprController {
	/**
	 * annualPlanApr 서비스
	 */
	@Inject
	@Named("AnnualPlanAprService")
	private AnnualPlanAprService annualPlanAprService;

	@Inject
	@Named("AuthTableService")
	private AuthTableService authTableService;
	
	/**
	 * annualPlanApr View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewAnnualPlanApr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewAnnualPlanApr() throws Exception {
		return "tim/annual/annualPlanApr/annualPlanApr";
	}

	/**
	 * annualPlanApr(세부내역) 팝업 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewAnnualPlanAprPop", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewAnnualPlanAprPop() throws Exception {
		return "tim/annual/annualPlanApr/annualPlanAprPop";
	}

	/**
	 * annualPlanApr 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAnnualPlanAprList", method = RequestMethod.POST )
	public ModelAndView getAnnualPlanAprList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<>();
		String message = "";
		try{
			Map<?, ?> query = authTableService.getAuthQueryMap(paramMap);
			if(query != null) {
				Log.Debug("query.get=> "+ query.get("query"));
				paramMap.put("query",query.get("query"));
				list = annualPlanAprService.getAnnualPlanAprList(paramMap);
			} else {
				message="조회에 실패 하였습니다.";
			}
		}catch(Exception e){
			message="조회에 실패 하였습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", message);
		Log.DebugEnd();
		return mv;
	}


	/**
	 * annualPlanApr 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveAnnualPlanApr", method = RequestMethod.POST )
	public ModelAndView saveAnnualPlanApr(
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
			resultCnt =annualPlanAprService.saveAnnualPlanApr(convertMap);
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

	/**
	 * annualPlanApr 단건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAnnualPlanAprMap", method = RequestMethod.POST )
	public ModelAndView getAnnualPlanAprMap(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
	
		Map<?, ?> map = null;
		String Message = "";
	
		try{
			map = annualPlanAprService.getAnnualPlanAprMap(paramMap);
		}catch(Exception e){
			Message="조회에 실패하였습니다.";
		}
	
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", map);
		mv.addObject("Message", Message);
	
		Log.DebugEnd();
		return mv;
	}

}
