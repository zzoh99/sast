package com.hr.tra.lectureRst.lectureRstApr;
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
 * 사내교육결과보고승인 Controller
 *
 * @author JSG
 *
 */
@Controller
@RequestMapping(value="/LectureRstApr.do", method=RequestMethod.POST )
public class LectureRstAprController extends ComController {
	/**
	 * 사내교육결과보고승인 서비스
	 */
	@Inject
	@Named("LectureRstAprService")
	private LectureRstAprService lectureRstAprService;

	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;

	/**
	 *  사내교육결과보고승인 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewLectureRstApr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewLectureRstApr() throws Exception {
		return "tra/lectureRst/lectureRstApr/lectureRstApr";
	}

	/**
	 * 사내교육결과보고신청 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getLectureRstAprList", method = RequestMethod.POST )
	public ModelAndView getLectureRstAprList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}

}
