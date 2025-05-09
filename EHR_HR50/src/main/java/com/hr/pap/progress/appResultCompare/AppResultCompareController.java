package com.hr.pap.progress.appResultCompare;

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
 * 평가결과비교 Controller
 * 
 * @author gjyoo
 *
 */
@Controller
@RequestMapping(value="/AppResultCompare.do", method=RequestMethod.POST )
public class AppResultCompareController extends ComController {

	/**
	 * 평가결과비교 View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewAppResultCompare", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewAppResultCompare() throws Exception {
		return "pap/progress/appResultCompare/appResultCompare";
	}

	/**
	 * 평가결과비교 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAppResultCompareList", method = RequestMethod.POST )
	public ModelAndView getAppResultCompareList(HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}
}
