package com.hr.hrd.selfRating.selfRatingStatistics;

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
@RequestMapping(value="/SelfRatingStatisticsRating.do", method=RequestMethod.POST )
public class SelfRatingStatisticsRatingController {
	@Inject
	@Named("Language")
	private Language language;


	@Inject
	@Named("SelfRatingStatisticsRatingService")
	private SelfRatingStatisticsRatingService selfRatingStatisticsRatingService;

	@RequestMapping(params="cmd=viewSelfRatingStatisticsRating", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewSelfRatingStatisticsRating(
		HttpSession session, HttpServletRequest request,
		@RequestParam Map<String, Object> paramMap) throws Exception {
		return "hrd/selfRating/selfRatingStatistics/selfRatingStatisticsRating";
	}

	@RequestMapping(params="cmd=getSelfRatingStatisticsRatingList", method = RequestMethod.POST )
	public ModelAndView getSelfRatingStatisticsRatingList(
		HttpSession session, HttpServletRequest request,
		@RequestParam Map<String, Object> paramMap) throws Exception {
		ParameterMapUtil.loadGlobalValues(session, paramMap);

		try{
			return ModelAndViewUtil.getJsonView(selfRatingStatisticsRatingService.getSelfRatingStatisticsRatingList(paramMap));
		}catch(Exception e){
			return ModelAndViewUtil.getJsonView( ListUtil.getEmptyList(),
					LanguageUtil.getMessage("msg.alertSearchFail", null, "조회 중 오류가 발생하였습니다."));
		}

	}

}
