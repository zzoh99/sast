package com.hr.hrd.selfReport.SelfReportRegist;

import com.hr.common.language.Language;
import com.hr.common.language.LanguageUtil;
import com.hr.common.util.ListUtil;
import com.hr.common.util.ModelAndViewUtil;
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
@RequestMapping({"/SelfReportRegist.do", "/CareerPathPopup.do"})
public class CareerPathPopupController {
	@Inject
	@Named("Language")
	private Language language;


	@Inject
	@Named("CareerPathPopupService")
	private CareerPathPopupService careerPathPopupService;

	@RequestMapping(params="cmd=viewCareerPathPopup", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewCareerPathPopup(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		return "hrd/selfReport/selfReportRegist/careerPathPopup";
	}

	@RequestMapping(params="cmd=viewCareerPathLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewCareerPathLayer(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		return "hrd/selfReport/selfReportRegist/careerPathLayer";
	}

	@RequestMapping(params="cmd=getCareerPathPopupList", method = RequestMethod.POST )
	public ModelAndView getCareerPathPopupList(
		HttpSession session, HttpServletRequest request,
		@RequestParam Map<String, Object> paramMap) throws Exception {
		ParameterMapUtil.loadGlobalValues(session, paramMap);
		List<?> list  = new ArrayList<Object>();
		String Message = "";

		try{
			return ModelAndViewUtil.getJsonView(careerPathPopupService.getCareerPathPopupList(paramMap));
		}catch(Exception e){
			return ModelAndViewUtil.getJsonView( ListUtil.getEmptyList(),
			         LanguageUtil.getMessage("msg.alertSearchFail"));
		}

	}

	@RequestMapping(params="cmd=getCareerPathPopupDetailList", method = RequestMethod.POST )
	public ModelAndView getCareerPathPopupgetDetailList(
		HttpSession session, HttpServletRequest request,
		@RequestParam Map<String, Object> paramMap) throws Exception {
		ParameterMapUtil.loadGlobalValues(session, paramMap);
		List<?> list  = new ArrayList<Object>();
		String Message = "";

		try{
			list = careerPathPopupService.getCareerPathPopupDetailList(paramMap);
//			for(Object obj : list){
//				HashMap<String, Object> map = (HashMap<String, Object>) obj;
//
//			}
			return ModelAndViewUtil.getJsonView(list);
		}catch(Exception e){
			return ModelAndViewUtil.getJsonView( ListUtil.getEmptyList(),
			         LanguageUtil.getMessage("msg.alertSearchFail"));
		}

	}

}
