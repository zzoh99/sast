package com.hr.tra.basis.eduEmpStat;

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
 * 강사찾기팝업 Controller
 *
 * @author JSG
 *
 */
@Controller
@RequestMapping(value="/EduEmpStat.do", method=RequestMethod.POST )
public class EduEmpStatController {
	/**
	 * 과정별수강인원현황 서비스
	 */
	@Inject
	@Named("EduEmpStatService")
	private EduEmpStatService eduEmpStatService;

	/**
	 * 과정별수강인원현황 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewEduEmpStat", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewEduEmpStat() throws Exception {
		return "tra/basis/eduEmpStat/eduEmpStat";
	}

	/**
	 * 과정별수강인원현황 다건조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getEduEmpStatList", method = RequestMethod.POST )
	public ModelAndView getEduEmpStatList(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

		List<?> list = new ArrayList<Object>();
		String Message = "";

		try{
			list = eduEmpStatService.getEduEmpStatList(paramMap);
		}catch(Exception e){
			Message="조회에 실패하였습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}

}
