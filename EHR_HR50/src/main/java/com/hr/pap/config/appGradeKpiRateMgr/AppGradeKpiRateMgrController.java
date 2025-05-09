package com.hr.pap.config.appGradeKpiRateMgr;
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
import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;
/**
 * 평가등급/조직별인원배분 Controller
 *
 * @author jcy
 *
 */
@Controller
@RequestMapping(value="/AppGradeKpiRateMgr.do", method=RequestMethod.POST )
public class AppGradeKpiRateMgrController {

	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;


	/**
	 * 평가등급/조직별인원배분 서비스
	 */
	@Inject
	@Named("AppGradeKpiRateMgrService")
	private AppGradeKpiRateMgrService appGradeKpiRateMgrService;

	
	/**
	 * 평가등급/조직별인원배분 조직코드 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAppGradeKpiRateMgrGrpIdList", method = RequestMethod.POST )
	public ModelAndView getAppGradeKpiRateMgrGrpIdList(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		List<?> result = appGradeKpiRateMgrService.getAppGradeKpiRateMgrGrpIdList(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("codeList", result);
		Log.DebugEnd();
		return mv;
	}

}
