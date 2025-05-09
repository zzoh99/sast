package com.hr.hrm.psnalInfo.psnalEdu;
import java.util.ArrayList;
import java.util.HashMap;
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
 * 인사기본(교육) Controller
 *
 * @author 이름
 *
 */
@Controller
@RequestMapping(value="/PsnalEdu.do", method=RequestMethod.POST )
public class PsnalEduController {

	/**
	 * 인사기본(교육) 서비스
	 */
	@Inject
	@Named("PsnalEduService")
	private PsnalEduService psnalEduService;

	/**
	 * viewPsnalEdu View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewPsnalEdu", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewPsnalEdu() throws Exception {
		return "hrm/psnalInfo/psnalEdu/psnalEdu";
	}

	@RequestMapping(params="cmd=viewPsnalEduLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewPsnalEduLayer() throws Exception {
		return "hrm/psnalInfo/psnalEdu/psnalEduLayer";
	}

	/**
	 * 인사기본(교육) 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPsnalEduList", method = RequestMethod.POST )
	public ModelAndView getPsnalEduList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<Object>();
		Map<?, ?> map  = new HashMap<String,Object>();
		String Message = "";
		try{
			list = psnalEduService.getPsnalEduList(paramMap);
			/*map = psnalEduService.getPsnalEduScore(paramMap);*/
		}catch(Exception e){
			Message="조회에 실패하였습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		mv.addObject("Etc", map);
		Log.DebugEnd();
		return mv;
	}
}
