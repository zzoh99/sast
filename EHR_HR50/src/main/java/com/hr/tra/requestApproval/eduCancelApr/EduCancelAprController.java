package com.hr.tra.requestApproval.eduCancelApr;
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
 * 교육취소승인 Controller
 *
 * @author JSG
 *
 */
@Controller
@RequestMapping(value="/EduCancelApr.do", method=RequestMethod.POST )
public class EduCancelAprController extends ComController {
	/**
	 * 교육취소승인 서비스
	 */
	@Inject
	@Named("EduCancelAprService")
	private EduCancelAprService eduCancelAprService;

	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;

	/**
	 *  교육취소승인 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewEduCancelApr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewEduCancelApr() throws Exception {
		return "tra/requestApproval/eduCancelApr/eduCancelApr";
	}

	/**
	 * 교육취소승인 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getEduCancelAprList", method = RequestMethod.POST )
	public ModelAndView getEduCancelAprList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}

}
