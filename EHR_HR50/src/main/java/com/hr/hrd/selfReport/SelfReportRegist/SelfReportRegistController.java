package com.hr.hrd.selfReport.SelfReportRegist;

import com.hr.common.language.Language;
import com.hr.common.language.LanguageUtil;
import com.hr.common.logger.Log;
import com.hr.common.util.ListUtil;
import com.hr.common.util.ModelAndViewUtil;
import com.hr.common.util.ParamUtils;
import com.hr.common.util.ParameterMapUtil;
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


@Controller
@RequestMapping(value="/SelfReportRegist.do", method=RequestMethod.POST )
public class SelfReportRegistController {
	@Inject
	@Named("Language")
	private Language language;


	@Inject
	@Named("SelfReportRegistService")
	private SelfReportRegistService selfReportRegistService;

	@RequestMapping(params="cmd=viewSelfReportRegistPopup", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewCareerPathPopup(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		return "hrd/selfReport/selfReportRegist/selfReportRegistPopup";
	}

	@RequestMapping(params="cmd=viewSelfReportRegistLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewSelfReportRegistLayer(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		return "hrd/selfReport/selfReportRegist/selfReportRegistLayer";
	}

	@RequestMapping(params="cmd=viewSelfReportRegist", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewSelfReportRegist(
		HttpSession session, HttpServletRequest request,
		@RequestParam Map<String, Object> paramMap) throws Exception {
		return "hrd/selfReport/selfReportRegist/selfReportRegist";
	}

	@RequestMapping(params="cmd=getSelfReportRegistPopupList", method = RequestMethod.POST )
	public ModelAndView getSelfReportRegistPopupList(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		ParameterMapUtil.loadGlobalValues(session, paramMap);
		List<?> list  = new ArrayList<Object>();

		try{
			return ModelAndViewUtil.getJsonView(selfReportRegistService.getSelfReportRegistPopupList(paramMap));
		}catch(Exception e){
			return ModelAndViewUtil.getJsonView( ListUtil.getEmptyList(),
					LanguageUtil.getMessage("msg.alertSearchFail", null, "조회 중 오류가 발생하였습니다."));
		}

	}

	@RequestMapping(params="cmd=getSelfReportRegistList", method = RequestMethod.POST )
	public ModelAndView getSelfReportRegistList(
		HttpSession session, HttpServletRequest request,
		@RequestParam Map<String, Object> paramMap) throws Exception {
		ParameterMapUtil.loadGlobalValues(session, paramMap);
		List<?> list  = new ArrayList<Object>();

		try{
			return ModelAndViewUtil.getJsonView(selfReportRegistService.getSelfReportRegistList(paramMap));
		}catch(Exception e){
			return ModelAndViewUtil.getJsonView( ListUtil.getEmptyList(),
					LanguageUtil.getMessage("msg.alertSearchFail", null, "조회 중 오류가 발생하였습니다."));
		}

	}

	@RequestMapping(params="cmd=saveSelfReportRegist", method = RequestMethod.POST )
	public ModelAndView saveSelfReportRegist(
		HttpSession session, HttpServletRequest request,
		@RequestParam Map<String, Object> paramMap) throws Exception {
		ParameterMapUtil.loadGlobalValues(session, paramMap);

		String message = "";
		int resultCnt = -1;
		try{
			resultCnt = selfReportRegistService.saveSelfReportRegist(paramMap);

			if(resultCnt > 0){
//				message=com.hr.common.language.LanguageUtil.getMessage("msg.alertSaveOkV1");
				message = LanguageUtil.getMessage("msg.alertSaveOkV1", null, "저장 되었습니다.");
			}
			else{
//				message=com.hr.common.language.LanguageUtil.getMessage("msg.alertSaveNoData");
				message = LanguageUtil.getMessage("msg.alertSaveNoData", null, "저장된 내용이 없습니다.");
			}
		}catch(Exception e){
//			resultCnt = -1; message=com.hr.common.language.LanguageUtil.getMessage("msg.alertSaveFail2");
			resultCnt = -1; message = LanguageUtil.getMessage("msg.alertSaveFail2", null, "저장에 실패하였습니다.");
		}

		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("Code", resultCnt);
		resultMap.put("Message", message);

		return ModelAndViewUtil.getJsonResultView(resultMap);
	}

	@RequestMapping(params="cmd=getSurveyPointList", method = RequestMethod.POST )
	public ModelAndView getSurveyPointList(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		ParameterMapUtil.loadGlobalValues(session, paramMap);
		List<?> list  = new ArrayList<Object>();

		try{
			return ModelAndViewUtil.getJsonView(selfReportRegistService.getSurveyPointList(paramMap));
		}catch(Exception e){
			return ModelAndViewUtil.getJsonView( ListUtil.getEmptyList(),
					LanguageUtil.getMessage("msg.alertSearchFail", null, "조회 중 오류가 발생하였습니다."));
		}

	}

	@RequestMapping(params="cmd=saveSurveyPoint", method = RequestMethod.POST )
	public ModelAndView saveSurveyPoint(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		ParameterMapUtil.loadGlobalValues(session, paramMap);

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(), "");

		String message = "";
		int resultCnt = -1;
		try{
			resultCnt = selfReportRegistService.saveSurveyPoint(convertMap);

			if(resultCnt > 0){
//				message=com.hr.common.language.LanguageUtil.getMessage("msg.alertSaveOkV1");
				message = LanguageUtil.getMessage("msg.alertSaveOkV1", null, "저장 되었습니다.");
			}
			else{
//				message=com.hr.common.language.LanguageUtil.getMessage("msg.alertSaveNoData");
				message = LanguageUtil.getMessage("msg.alertSaveNoData", null, "저장된 내용이 없습니다.");
				
			}
		}catch(Exception e){
//			resultCnt = -1; message=com.hr.common.language.LanguageUtil.getMessage("msg.alertSaveFail2");
			resultCnt = -1; message = LanguageUtil.getMessage("msg.alertSaveFail2", null, "저장에 실패하였습니다.");
			
		}

		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("Code", resultCnt);
		resultMap.put("Message", message);

		return ModelAndViewUtil.getJsonResultView(resultMap);
	}
}
