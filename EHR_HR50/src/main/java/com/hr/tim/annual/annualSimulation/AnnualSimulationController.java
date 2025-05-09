package com.hr.tim.annual.annualSimulation;

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

import com.hr.common.logger.Log;

@Controller
@RequestMapping(value="/AnnualSimulation.do", method=RequestMethod.POST )
public class AnnualSimulationController {
	
	@Inject
	@Named("AnnualSimulationService")
	private AnnualSimulationService annualSimulationService;

	@RequestMapping(params="cmd=viewAnnualSimulation", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewAnnualSimulation() throws Exception {
		return "tim/annual/annualSimulation/annualSimulation";
	}
	
	@RequestMapping(params="cmd=getAnnualSimulationList", method = RequestMethod.POST )
	public ModelAndView getAnnualSimulationList(HttpSession session,  HttpServletRequest request,
		@RequestParam Map<String, Object> paramMap) throws Exception {
		
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnLocaleCd",	session.getAttribute("ssnLocaleCd"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));
		paramMap.put("ssnGrpCd", session.getAttribute("ssnGrpCd"));
		
		List<?> list = new ArrayList<>();
		String Message = "";
		try {
			list = annualSimulationService.getAnnualSimulationList(paramMap);
			
			Log.Info(list+"zxczxc");
		}catch( Exception e ){
			Message="조회에 실패 하였습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		
		return mv;
	}
	
}
