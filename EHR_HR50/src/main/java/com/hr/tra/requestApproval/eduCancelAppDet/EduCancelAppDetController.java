package com.hr.tra.requestApproval.eduCancelAppDet;
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

import com.hr.common.com.ComController;
import com.hr.common.logger.Log;

/**
 * 교육취소신청 세부내역 Controller
 *
 * @author bckim
 *
 */
@Controller
@RequestMapping({"/EduCancelApp.do","/EduCancelAppDet.do"})
public class EduCancelAppDetController extends ComController {

	/**
	 * 교육취소신청 세부내역 서비스
	 */
	@Inject
	@Named("EduCancelAppDetService")
	private EduCancelAppDetService eduCancelAppDetService;

	/**
	 * 교육취소신청 세부내역 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewEduCancelAppDet", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewEduCancelAppDet() throws Exception {
		return "tra/requestApproval/eduCancelAppDet/eduCancelAppDet";
	}

	/**
	 * 교육취소신청 세부내역 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getEduCancelAppDetMap", method = RequestMethod.POST )
	public ModelAndView getEduCancelAppDetMap(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataMap(session, request, paramMap);
	}


	/**
	 * 교육취소신청 세부내역 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveEduCancelAppDet", method = RequestMethod.POST )
	public ModelAndView saveEduCancelAppDet(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return saveData(session, request, paramMap);
	}

}
