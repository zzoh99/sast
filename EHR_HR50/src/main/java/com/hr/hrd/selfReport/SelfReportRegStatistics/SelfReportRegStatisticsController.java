package com.hr.hrd.selfReport.SelfReportRegStatistics;

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
@RequestMapping(value="/SelfReportRegStatistics.do", method=RequestMethod.POST )
public class SelfReportRegStatisticsController {
	@Inject
	@Named("Language")
	private Language language;


	@Inject
	@Named("SelfReportRegStatisticsService")
	private SelfReportRegStatisticsService selfReportRegStatisticsService;

	@RequestMapping(params="cmd=viewSelfReportRegStatistics", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewSelfReportRegStatistics(
		HttpSession session, HttpServletRequest request,
		@RequestParam Map<String, Object> paramMap) throws Exception {
		return "hrd/selfReport/SelfReportRegStatistics/selfReportRegStatistics";
	}

	@RequestMapping(params="cmd=getSelfReportRegStatisticsList", method = RequestMethod.POST )
	public ModelAndView getSelfReportRegStatisticsList(
		HttpSession session, HttpServletRequest request,
		@RequestParam Map<String, Object> paramMap) throws Exception {
		ParameterMapUtil.loadGlobalValues(session, paramMap);
		List<?> list  = new ArrayList<Object>();
		String Message = "";

		try{
			list = selfReportRegStatisticsService.getSelfReportRegStatisticsList(paramMap);
			return ModelAndViewUtil.getJsonView(list);
		}catch(Exception e){
			return ModelAndViewUtil.getJsonView( ListUtil.getEmptyList(),
					LanguageUtil.getMessage("msg.alertSearchFail", null, "조회 중 오류가 발생하였습니다."));
		}

	}

}
