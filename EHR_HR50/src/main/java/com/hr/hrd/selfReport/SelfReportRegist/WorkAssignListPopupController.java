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
@RequestMapping({"/SelfReportRegist.do", "/WorkAssignListPopup.do"})
public class WorkAssignListPopupController {
	@Inject
	@Named("Language")
	private Language language;


	@Inject
	@Named("WorkAssignListPopupService")
	private WorkAssignListPopupService workAssignListPopupService;

	@RequestMapping(params="cmd=viewWorkAssignListPopup", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewWorkAssignListPopup(
		HttpSession session, HttpServletRequest request,
		@RequestParam Map<String, Object> paramMap) throws Exception {
		return "hrd/selfReport/selfReportRegist/workAssignListPopup";
	}

	@RequestMapping(params="cmd=viewWorkAssignListLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewWorkAssignListLayer(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		return "hrd/selfReport/selfReportRegist/workAssignListLayer";
	}

	@RequestMapping(params="cmd=getWorkAssignListPopupList", method = RequestMethod.POST )
	public ModelAndView getWorkAssignListPopupList(
		HttpSession session, HttpServletRequest request,
		@RequestParam Map<String, Object> paramMap) throws Exception {
		ParameterMapUtil.loadGlobalValues(session, paramMap);
		List<?> list  = new ArrayList<Object>();
		String Message = "";

		try{
			return ModelAndViewUtil.getJsonView(workAssignListPopupService.getWorkAssignListPopupList(paramMap));
		}catch(Exception e){
			return ModelAndViewUtil.getJsonView( ListUtil.getEmptyList(),
			         LanguageUtil.getMessage("msg.alertSearchFail"));
		}

	}

}
