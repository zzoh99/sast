package com.hr.tim.code.holidayOccurStd.occurStd;
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
 * 휴가 발생조건 Controller
 *
 * @author bckim
 *
 */
@Controller
@RequestMapping(value="/OccurStd.do", method=RequestMethod.POST )
public class OccurStdController extends ComController {

	/**
	 * 휴가 발생조건 서비스
	 */
	@Inject
	@Named("OccurStdService")
	private OccurStdService occurStdService;

	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;

	/**
	 * 휴가 발생조건 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewOccurStd", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewOccurStd() throws Exception {
		return "tim/code/holidayOccurStd/occurStd/occurStd";
	}


	/**
	 * 휴가 발생조건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getOccurStdList", method = RequestMethod.POST )
	public ModelAndView getOccurStdList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}

	/**
	 * 휴가 발생조건 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveOccurStd", method = RequestMethod.POST )
	public ModelAndView saveOccurStd(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return saveData(session, request, paramMap);
	}
}
