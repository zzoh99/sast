package com.hr.pap.degreeFeedback.degreeFeedbackResult;

import com.hr.common.com.ComController;
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

/**
 * 다면평가결과조회 Controller
 *
 * @author JCY
 *
 */
@Controller
@RequestMapping(value="/DegreeFeedbackResult.do", method=RequestMethod.POST )
public class DegreeFeedbackResultController extends ComController {

	/**
	 * 다면평가결과조회 서비스
	 */
	@Inject
	@Named("DegreeFeedbackResultService")
	private DegreeFeedbackResultService degreeFeedbackResultService;
	
	/**
	 * 다면평가결과조회 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewDegreeFeedbackResult", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewCompAppResult() throws Exception {
		return "pap/degreeFeedback/degreeFeedbackResult/degreeFeedbackResult";
	}
	
	/**
	 * 다면평가결과조회 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getDegreeFeedbackResultList", method = RequestMethod.POST )
	public ModelAndView getDegreeFeedbackResultList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		List<?> list  = new ArrayList<Object>();
		String Message = "";
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));

		try {
			list = degreeFeedbackResultService.getDegreeFeedbackResultList(paramMap);
		} catch(Exception e) {
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
