package com.hr.hrd.statistics.successorState;

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
@RequestMapping(value="/SuccessorState.do", method=RequestMethod.POST )
public class SuccessorStateController {
	@Inject
	@Named("Language")
	private Language language;


	@Inject
	@Named("SuccessorStateService")
	private SuccessorStateService successorStateService;

	@RequestMapping(params="cmd=viewSuccessorState", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewSelfRatingStatisticsRegist(
		HttpSession session, HttpServletRequest request,
		@RequestParam Map<String, Object> paramMap) throws Exception {
		return "hrd/statistics/successorState/successorState";
	}

	@RequestMapping(params="cmd=getSuccessorStateList", method = RequestMethod.POST )
	public ModelAndView getSelfRatingStatisticsRegistList(
		HttpSession session, HttpServletRequest request,
		@RequestParam Map<String, Object> paramMap) throws Exception {
		ParameterMapUtil.loadGlobalValues(session, paramMap);
		List<?> list  = new ArrayList<Object>();
		String Message = "";

		try{
			return ModelAndViewUtil.getJsonView(successorStateService.getSuccessorStateList(paramMap));
		}catch(Exception e){
			return ModelAndViewUtil.getJsonView( ListUtil.getEmptyList(),
					LanguageUtil.getMessage("msg.alertSearchFail", null, "조회 중 오류가 발생하였습니다."));
		}

	}

}
