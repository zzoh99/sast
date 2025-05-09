package com.hr.ben.scholarship.schStd.tab1;

import java.util.Map;

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
 * 학자금기준관리 > 직책별 지원금액 tab Controller
 * @author gjyoo
 *
 */
@Controller
@RequestMapping({"/SchTab1Std.do", "/SchStd.do"})
public class SchTab1StdController extends ComController {

	/**
	 *  학자금기준관리 > 직책별 지원금액 tab View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewSchTab1Std", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewSchTab1Std() throws Exception {
		return "ben/scholarship/schStd/tab1/schTab1Std";
	}

	/**
	 * 학자금기준관리 > 직책별 지원금액 tab 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getSchTab1StdList", method = RequestMethod.POST )
	public ModelAndView getSchTab1StdList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}

	/**
	 * 학자금기준관리 > 직책별 지원금액 tab 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveSchTab1Std", method = RequestMethod.POST )
	public ModelAndView saveSchTab1Std(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return saveData(session, request, paramMap);
	}
}
