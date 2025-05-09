package com.hr.hrd.selfDevelopment.selfDevelopmentTRM;

import com.hr.common.language.Language;
import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;
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
@RequestMapping(value="/SelfDevelopmentTRM.do", method=RequestMethod.POST )
public class SelfDevelopmentTRMController {
	@Inject
	@Named("Language")
	private Language language;


	@Inject
	@Named("SelfDevelopmentTRMService")
	private SelfDevelopmentTRMService selfDevelopmentTRMService;

	@RequestMapping(params="cmd=viewSelfDevelopmentTRMPopup", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewSelfDevelopmentTRMPopup(HttpSession session, HttpServletRequest request,@RequestParam Map<String, Object> paramMap) throws Exception {
		return "hrd/selfDevelopment/selfDevelopmentTRM/selfDevelopmentTRMPopup";
	}


	@RequestMapping(params="cmd=getSelfDevelopmentTRM", method = RequestMethod.POST )
	public ModelAndView getSelfDevelopmentTRM(HttpSession session, HttpServletRequest request,	@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		List<?> list = new ArrayList<Object>();
		String Message = "";
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		try {
			list = selfDevelopmentTRMService.getSelfDevelopmentTRM(paramMap);
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
