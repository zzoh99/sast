package com.hr.hrd.statistics.workSatisfactionOrgStatistics;

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
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping(value="/WorkSatisfactionOrgStatistics.do", method=RequestMethod.POST )
public class WorkSatisfactionOrgStatisticsController {
	@Inject
	@Named("Language")
	private Language language;


	@Inject
	@Named("WorkSatisfactionOrgStatisticsService")
	private WorkSatisfactionOrgStatisticsService workSatisfactionOrgStatisticsService;

	@RequestMapping(params="cmd=viewWorkSatisfactionOrgStatistics", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewWorkSatisfactionOrgStatistics(
		HttpSession session, HttpServletRequest request,
		@RequestParam Map<String, Object> paramMap) throws Exception {
		return "hrd/statistics/workSatisfactionOrgStatistics/workSatisfactionOrgStatistics";
	}

	@RequestMapping(params="cmd=getWorkSatisfactionOrgStatisticsSurveyItemList", method = RequestMethod.POST )
	public ModelAndView getWorkSatisfactionOrgStatisticsSurveyItemList(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		ParameterMapUtil.loadGlobalValues(session, paramMap);
		try{
			List<?> list = workSatisfactionOrgStatisticsService.getWorkSatisfactionOrgStatisticsSurveyItemList(paramMap);
			return ModelAndViewUtil.getJsonView(list);
		}catch(Exception e){

			return ModelAndViewUtil.getJsonView( ListUtil.getEmptyList(),
					LanguageUtil.getMessage("msg.alertSearchFail"));
		}
	}

	@RequestMapping(params="cmd=getWorkSatisfactionOrgStatisticsItem", method = RequestMethod.POST )
	public ModelAndView getWorkSatisfactionOrgStatisticsItem(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		ParameterMapUtil.loadGlobalValues(session, paramMap);
		try{
			List<?> list = workSatisfactionOrgStatisticsService.getWorkSatisfactionOrgStatisticsItem(paramMap);
			return ModelAndViewUtil.getJsonView(list);
		}catch(Exception e){

			return ModelAndViewUtil.getJsonView( ListUtil.getEmptyList(),
					LanguageUtil.getMessage("msg.alertSearchFail"));
		}
	}

	@RequestMapping(params="cmd=getWorkSatisfactionOrgStatisticsList", method = RequestMethod.POST )
	public ModelAndView getWorkSatisfactionOrgStatisticsList(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		ParameterMapUtil.loadGlobalValues(session, paramMap);
		Map<?, ?> conditionMap  = workSatisfactionOrgStatisticsService.getWorkSatisfactionOrgStatisticsSurveyItemStr(paramMap);

		String conditionStr = conditionMap != null && conditionMap.get("conditions") != null ? conditionMap.get("conditions").toString():"''";

		paramMap.put("conditions", conditionStr);
		//String Message = "";
		try{
			List<?> list = new ArrayList<>();
			if (conditionMap != null) {
				list = workSatisfactionOrgStatisticsService.getWorkSatisfactionOrgStatisticsList(paramMap);
			}
			return ModelAndViewUtil.getJsonView(list);
		}catch(Exception e){

			return ModelAndViewUtil.getJsonView( ListUtil.getEmptyList(),
					LanguageUtil.getMessage("msg.alertSearchFail"));
		}
	}

}
