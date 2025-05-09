package com.hr.tra.requestApproval.eduApr;
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
import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;

/**
 * 교육승인 Controller
 *
 * @author JSG
 *
 */
@Controller
@RequestMapping(value="/EduApr.do", method=RequestMethod.POST )
public class EduAprController extends ComController {
	/**
	 * 교육승인 서비스
	 */
	@Inject
	@Named("EduAprService")
	private EduAprService eduAprService;

	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;

	/**
	 *  교육승인 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewEduApr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewEduApr() throws Exception {
		return "tra/requestApproval/eduApr/eduApr";
	}

	/**
	 * 교육신청 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getEduAprList", method = RequestMethod.POST )
	public ModelAndView getEduAprList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}

}
