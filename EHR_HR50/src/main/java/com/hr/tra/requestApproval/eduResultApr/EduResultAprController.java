package com.hr.tra.requestApproval.eduResultApr;
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

import com.hr.common.code.CommonCodeService;
import com.hr.common.com.ComController;
import com.hr.common.language.LanguageUtil;
import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;

/**
 * 교육결과보고승인 Controller
 *
 * @author EW
 *
 */
@Controller
@RequestMapping(value="/EduResultApr.do", method=RequestMethod.POST )
public class EduResultAprController extends ComController {
	/**
	 * 교육결과보고승인 서비스
	 */
	@Inject
	@Named("EduResultAprService")
	private EduResultAprService eduResultAprService;

	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;

	/**
	 * 교육결과보고승인 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewEduResultApr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewEduResultApr() throws Exception {
		return "tra/requestApproval/eduResultApr/eduResultApr";
	}
	/**
	 * 교육결과보고승인 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getEduResultAprList", method = RequestMethod.POST )
	public ModelAndView getEduResultAprList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}


}
