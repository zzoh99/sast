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
@RequestMapping({"/WorkSklKnlgMgr.do", "/WorkAssignPopup.do", "/SelfReportRegist.do"})
public class WorkAssignPopupController {
	@Inject
	@Named("Language")
	private Language language;


	@Inject
	@Named("WorkAssignPopupService")
	private WorkAssignPopupService workAssignPopupService;

	@RequestMapping(params="cmd=viewWorkAssignPopup", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewWorkAssignPopup(
		HttpSession session, HttpServletRequest request,
		@RequestParam Map<String, Object> paramMap) throws Exception {
		return "hrd/selfReport/selfReportRegist/workAssignPopup";
	}

	@RequestMapping(params="cmd=viewWorkAssignLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewWorkAssignLayer(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		return "hrd/selfReport/selfReportRegist/workAssignLayer";
	}

	@RequestMapping(params="cmd=getWorkAssignPopupList", method = RequestMethod.POST )
	public ModelAndView getWorkAssignPopupList(
		HttpSession session, HttpServletRequest request,
		@RequestParam Map<String, Object> paramMap) throws Exception {
		ParameterMapUtil.loadGlobalValues(session, paramMap);
		List<?> list  = new ArrayList<Object>();
		String Message = "";

		try{
			list = workAssignPopupService.getWorkAssignPopupList(paramMap);
			return ModelAndViewUtil.getJsonView(list);
		}catch(Exception e){
			return ModelAndViewUtil.getJsonView( ListUtil.getEmptyList(),
			         LanguageUtil.getMessage("msg.alertSearchFail"));
		}

	}

}
