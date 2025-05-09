package com.hr.eis.statsSrch.statsSrch;

import javax.inject.Inject;
import javax.inject.Named;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.hr.common.logger.Log;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.hr.common.com.ComController;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import java.util.Map;

/**
 * 통계그래프 > 통계 조회 Controller
 * @author gjyoo
 *
 */
@Controller
@RequestMapping(value="/StatsSrch.do", method= RequestMethod.POST )
public class StatsSrchController extends ComController {
	
	@Inject
	@Named("StatsSrchService")
	private StatsSrchService statsSrchService;
	
	/**
	 * 통계 조회 View
	 * 
	 * @return Stringm
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewStatsSrch", method = {RequestMethod.POST, RequestMethod.GET} )
	public ModelAndView viewStatsMng(@RequestParam Map<String, Object> paramMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("eis/statsSrch/statsSrch/statsSrch");
		mv.addObject("map", paramMap);
		return mv;
	}

}
