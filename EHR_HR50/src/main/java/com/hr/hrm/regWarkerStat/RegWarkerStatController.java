package com.hr.hrm.regWarkerStat;
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

/**
 * 월별근로자수(\C774\C218) Controller
 *
 * @author EW
 *
 */
@Controller
@RequestMapping(value="/RegWarkerStat.do", method=RequestMethod.POST )
public class RegWarkerStatController {
	/**
	 * 월별근로자수(\C774\C218) 서비스
	 */
	@Inject
	@Named("RegWarkerStatService")
	private RegWarkerStatService regWarkerStatService;

	/**
	 * 월별근로자수(\C774\C218) View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewRegWarkerStat", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewRegWarkerStat() throws Exception {
		return "hrm/regWarkerStat/regWarkerStat";
	}

	/**
	 * 월별근로자수(\C774\C218) 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getRegWarkerStatList", method = RequestMethod.POST )
	public ModelAndView getRegWarkerStatList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = regWarkerStatService.getRegWarkerStatList(paramMap);
		}catch(Exception e){
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

