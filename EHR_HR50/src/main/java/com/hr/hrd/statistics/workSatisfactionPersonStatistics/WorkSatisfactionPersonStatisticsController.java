package com.hr.hrd.statistics.workSatisfactionPersonStatistics;

import java.util.ArrayList;
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

import com.hr.common.language.Language;
import com.hr.common.language.LanguageUtil;
import com.hr.common.util.ListUtil;
import com.hr.common.util.ModelAndViewUtil;
import com.hr.common.util.ParameterMapUtil;

@Controller
@RequestMapping(value="/WorkSatisfactionPersonStatistics.do", method=RequestMethod.POST )
public class WorkSatisfactionPersonStatisticsController {
	@Inject
	@Named("Language")
	private Language language;


	@Inject
	@Named("WorkSatisfactionPersonStatisticsService")
	private WorkSatisfactionPersonStatisticsService workSatisfactionPersonStatisticsService;

	@RequestMapping(params="cmd=viewWorkSatisfactionPersonStatistics", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewWorkSatisfactionPersonStatistics(
		HttpSession session, HttpServletRequest request,
		@RequestParam Map<String, Object> paramMap) throws Exception {
		return "hrd/statistics/workSatisfactionPersonStatistics/workSatisfactionPersonStatistics";
	}

	@RequestMapping(params="cmd=getWorkSatisfactionPersonStatisticsSurveyItemList", method = RequestMethod.POST )
	public ModelAndView getWorkSatisfactionPersonStatisticsSurveyItemList(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		ParameterMapUtil.loadGlobalValues(session, paramMap);
		try{
			List<?> list = workSatisfactionPersonStatisticsService.getWorkSatisfactionPersonStatisticsSurveyItemList(paramMap);
			return ModelAndViewUtil.getJsonView(list);
		}catch(Exception e){

			return ModelAndViewUtil.getJsonView( ListUtil.getEmptyList(),
					LanguageUtil.getMessage("msg.alertSearchFail"));
		}
	}

	@RequestMapping(params="cmd=getWorkSatisfactionPersonStatisticsItem", method = RequestMethod.POST )
	public ModelAndView getWorkSatisfactionPersonStatisticsItem(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		ParameterMapUtil.loadGlobalValues(session, paramMap);
		try{
			List<?> list = workSatisfactionPersonStatisticsService.getWorkSatisfactionPersonStatisticsItem(paramMap);
			return ModelAndViewUtil.getJsonView(list);
		}catch(Exception e){

			return ModelAndViewUtil.getJsonView( ListUtil.getEmptyList(),
					LanguageUtil.getMessage("msg.alertSearchFail"));
		}
	}

	@RequestMapping(params="cmd=getWorkSatisfactionPersonStatisticsList", method = RequestMethod.POST )
	public ModelAndView getWorkSatisfactionPersonStatisticsList(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		ParameterMapUtil.loadGlobalValues(session, paramMap);
		Map<?, ?> conditionMap  = workSatisfactionPersonStatisticsService.getWorkSatisfactionPersonStatisticsSurveyItemStr(paramMap);

		String conditionStr = conditionMap != null && conditionMap.get("conditions") != null ? conditionMap.get("conditions").toString():"''";

		paramMap.put("conditions", conditionStr);
		//String Message = "";
		try{
			List<?> list = new ArrayList<>();
			if (conditionMap != null) {
				list = workSatisfactionPersonStatisticsService.getWorkSatisfactionPersonStatisticsList(paramMap);
			}
			return ModelAndViewUtil.getJsonView(list);
		}catch(Exception e){

			return ModelAndViewUtil.getJsonView( ListUtil.getEmptyList(),
					LanguageUtil.getMessage("msg.alertSearchFail"));
		}
	}

}
