package com.hr.hrd.statistics.hopeWorkAssignState;

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
@RequestMapping(value="/HopeWorkAssignState.do", method=RequestMethod.POST )
public class HopeWorkAssignStateController {
	@Inject
	@Named("Language")
	private Language language;


	@Inject
	@Named("HopeWorkAssignStateService")
	private HopeWorkAssignStateService hopeWorkAssignStateService;

	@RequestMapping(params="cmd=viewHopeWorkAssignState", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewHopeWorkAssignState(
		HttpSession session, HttpServletRequest request,
		@RequestParam Map<String, Object> paramMap) throws Exception {
		return "hrd/statistics/hopeWorkAssignState/hopeWorkAssignState";
	}

	@RequestMapping(params="cmd=getHopeWorkAssignStateList", method = RequestMethod.POST )
	public ModelAndView getHopeWorkAssignStateList(
		HttpSession session, HttpServletRequest request,
		@RequestParam Map<String, Object> paramMap) throws Exception {
		ParameterMapUtil.loadGlobalValues(session, paramMap);
		List<?> list  = new ArrayList<Object>();
		String Message = "";

		try{
			return ModelAndViewUtil.getJsonView(hopeWorkAssignStateService.getHopeWorkAssignStateList(paramMap));
		}catch(Exception e){
			return ModelAndViewUtil.getJsonView( ListUtil.getEmptyList(),
					LanguageUtil.getMessage("msg.alertSearchFail", null, "조회 중 오류가 발생하였습니다."));
		}

	}

	@RequestMapping(params="cmd=getHopeWorkAssignStateDetailList", method = RequestMethod.POST )
	public ModelAndView getHopeWorkAssignStategetDetailList(
		HttpSession session, HttpServletRequest request,
		@RequestParam Map<String, Object> paramMap) throws Exception {
		ParameterMapUtil.loadGlobalValues(session, paramMap);
		List<?> list  = new ArrayList<Object>();
		String Message = "";

		try{
			return ModelAndViewUtil.getJsonView(hopeWorkAssignStateService.getHopeWorkAssignStateDetailList(paramMap));
		}catch(Exception e){
			return ModelAndViewUtil.getJsonView( ListUtil.getEmptyList(),
					LanguageUtil.getMessage("msg.alertSearchFail", null, "조회 중 오류가 발생하였습니다."));
		}

	}

}
