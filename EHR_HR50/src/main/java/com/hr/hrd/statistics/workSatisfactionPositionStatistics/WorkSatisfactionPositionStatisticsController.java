package com.hr.hrd.statistics.workSatisfactionPositionStatistics;

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
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping(value="/WorkSatisfactionPositionStatistics.do", method=RequestMethod.POST )
public class WorkSatisfactionPositionStatisticsController {
	@Inject
	@Named("Language")
	private Language language;


	@Inject
	@Named("WorkSatisfactionPositionStatisticsService")
	private WorkSatisfactionPositionStatisticsService workSatisfactionPositionStatisticsService;

	@RequestMapping(params="cmd=viewWorkSatisfactionPositionStatistics", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewWorkSatisfactionPositionStatistics(
		HttpSession session, HttpServletRequest request,
		@RequestParam Map<String, Object> paramMap) throws Exception {
		return "hrd/statistics/workSatisfactionPositionStatistics/workSatisfactionPositionStatistics";
	}

	@RequestMapping(params="cmd=getWorkSatisfactionPositionStatisticsSurveyItemList", method = RequestMethod.POST )
	public ModelAndView getWorkSatisfactionPositionStatisticsSurveyItemList(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		ParameterMapUtil.loadGlobalValues(session, paramMap);
		try{
			List<?> list = workSatisfactionPositionStatisticsService.getWorkSatisfactionPositionStatisticsSurveyItemList(paramMap);
			return ModelAndViewUtil.getJsonView(list);
		}catch(Exception e){

			return ModelAndViewUtil.getJsonView( ListUtil.getEmptyList(),
					LanguageUtil.getMessage("msg.alertSearchFail"));
		}
	}

	@RequestMapping(params="cmd=getWorkSatisfactionPositionStatisticsItem", method = RequestMethod.POST )
	public ModelAndView getWorkSatisfactionPositionStatisticsItem(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		ParameterMapUtil.loadGlobalValues(session, paramMap);
		try{
			List<?> list = workSatisfactionPositionStatisticsService.getWorkSatisfactionPositionStatisticsItem(paramMap);
			return ModelAndViewUtil.getJsonView(list);
		}catch(Exception e){

			return ModelAndViewUtil.getJsonView( ListUtil.getEmptyList(),
					LanguageUtil.getMessage("msg.alertSearchFail"));
		}
	}

	@RequestMapping(params="cmd=getWorkSatisfactionPositionStatisticsList", method = RequestMethod.POST )
	public ModelAndView getWorkSatisfactionPositionStatisticsList(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		ParameterMapUtil.loadGlobalValues(session, paramMap);
		Map<?, ?> conditionMap  = workSatisfactionPositionStatisticsService.getWorkSatisfactionPositionStatisticsSurveyItemStr(paramMap);

		String conditionStr = conditionMap != null && conditionMap.get("conditions") != null ? conditionMap.get("conditions").toString():"''";

		paramMap.put("conditions", conditionStr);
		//String Message = "";
		try{
			List<?> list = workSatisfactionPositionStatisticsService.getWorkSatisfactionPositionStatisticsList(paramMap);
			return ModelAndViewUtil.getJsonView(list);
		}catch(Exception e){

			return ModelAndViewUtil.getJsonView( ListUtil.getEmptyList(),
					LanguageUtil.getMessage("msg.alertSearchFail"));
		}
	}

}
