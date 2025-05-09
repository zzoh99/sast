package com.hr.ben.scholarship.schApr;
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
 * 학자금승인 Controller
 *
 * @author 이름
 *
 */
@Controller
@RequestMapping(value="/SchApr.do", method=RequestMethod.POST )
public class SchAprController extends ComController {
	/**
	 * 학자금승인 서비스
	 */
	@Inject
	@Named("SchAprService")
	private SchAprService schAprService;
	
	/**
	 * 학자금승인 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewSchApr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewSchApr() throws Exception {
		return "ben/scholarship/schApr/schApr";
	}

	/**
	 * 학자금승인 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getSchAprList", method = RequestMethod.POST )
	public ModelAndView getSchAprList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}
	
	/**
	 * 학자금승인 저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveSchApr", method = RequestMethod.POST )
	public ModelAndView saveSchApr(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return saveData(session, request, paramMap);
	}
}
