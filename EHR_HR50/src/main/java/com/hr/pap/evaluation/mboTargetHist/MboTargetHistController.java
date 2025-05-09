package com.hr.pap.evaluation.mboTargetHist;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;
/**
 * 목표등록,중간점검등록 HISTORY Controller
 */
@Controller
@RequestMapping(value="/MboTargetHist.do", method=RequestMethod.POST )
public class MboTargetHistController {

	/**
	 * 목표등록,중간점검등록 View(Main 화면 로드)
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewMboTargetHist", method = {RequestMethod.POST, RequestMethod.GET} )
	public ModelAndView mboTargetHist(
		HttpSession session,  HttpServletRequest request,
		@RequestParam Map<String, Object> paramMap ) throws Exception {

		ModelAndView mv = new ModelAndView();
		mv.setViewName("pap/evaluation/mboTargetHist/mboTargetHist");
		mv.addObject("map", paramMap);

		return mv;
	}
}
