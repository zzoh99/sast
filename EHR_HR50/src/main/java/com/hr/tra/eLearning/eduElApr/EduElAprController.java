package com.hr.tra.eLearning.eduElApr;
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

import com.hr.common.code.CommonCodeService;
import com.hr.common.com.ComController;
import com.hr.common.logger.Log;

/**
 * 이러닝승인 Controller
 *
 * @author 이름
 *
 */
@Controller
@RequestMapping(value="/EduElApr.do", method=RequestMethod.POST )
public class EduElAprController extends ComController {
	/**
	 * 이러닝승인 서비스
	 */
	@Inject
	@Named("EduElAprService")
	private EduElAprService eduElAprService;

	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;

	/**
	 * 이러닝승인 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewEduElApr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewEduElApr() throws Exception {
		return "tra/eLearning/eduElApr/eduElApr";
	}

	/**
	 * 이러닝승인 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getEduElAprList", method = RequestMethod.POST )
	public ModelAndView getEduElAprList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}
	

}
