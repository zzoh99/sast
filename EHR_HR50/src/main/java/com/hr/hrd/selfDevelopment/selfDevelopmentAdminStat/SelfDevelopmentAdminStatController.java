package com.hr.hrd.selfDevelopment.selfDevelopmentAdminStat;

import com.hr.common.language.Language;
import com.hr.common.logger.Log;
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
@RequestMapping(value="/SelfDevelopmentAdminStat.do", method=RequestMethod.POST )
public class SelfDevelopmentAdminStatController {
	@Inject
	@Named("Language")
	private Language language;


	@Inject
	@Named("SelfDevelopmentAdminStatService")
	private SelfDevelopmentAdminStatService selfDevelopmentAdminStatService;

	@RequestMapping(params="cmd=viewSelfDevelopmentAdminStat", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewSelfDevelopmentAdminStat(HttpSession session, HttpServletRequest request,@RequestParam Map<String, Object> paramMap) throws Exception {
		return "hrd/selfDevelopment/selfDevelopmentAdminStat/selfDevelopmentAdminStat";
	}

	@RequestMapping(params="cmd=getSelfDevelopmentAdminStat", method = RequestMethod.POST )
	public ModelAndView getSelfDevelopmentAdminStat(HttpSession session, HttpServletRequest request,	@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		List<?> list = new ArrayList<Object>();
		String Message = "";
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		try {
			list = selfDevelopmentAdminStatService.getSelfDevelopmentAdminStat(paramMap);
		} catch (Exception e) {
			Message = "조회에 실패 하였습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}

}
