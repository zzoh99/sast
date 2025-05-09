package com.hr.pap.evaluation.appSelfHist;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

@Controller
@RequestMapping(value="/AppSelfHist.do", method=RequestMethod.POST )
public class AppSelfHistController {

	/**
	 * 본인평가 History View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewAppSelfHist", method = {RequestMethod.POST, RequestMethod.GET} )
	public ModelAndView viewAppSelfHist(
		HttpSession session,  HttpServletRequest request,
		@RequestParam Map<String, Object> paramMap ) throws Exception {

		if(paramMap.get("searchAppSeqCd") == null) {
			paramMap.put("searchAppSeqCd", "0");
		}

		ModelAndView mv = new ModelAndView();
		mv.setViewName("pap/evaluation/appSelfHist/appSelfHist");
		mv.addObject("map", paramMap);

		return mv;
	}
}
