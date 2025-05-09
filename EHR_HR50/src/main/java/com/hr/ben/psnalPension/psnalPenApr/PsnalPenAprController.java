package com.hr.ben.psnalPension.psnalPenApr;
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
 * 개인연금승인 Controller
 *
 * @author 이름
 *
 */
@Controller
@RequestMapping(value="/PsnalPenApr.do", method=RequestMethod.POST )
public class PsnalPenAprController extends ComController {
	/**
	 * 개인연금승인 서비스
	 */
	@Inject
	@Named("PsnalPenAprService")
	private PsnalPenAprService psnalPenAprService;


	/**
	 * 개인연금승인 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewPsnalPenApr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewPsnalPenApr() throws Exception {
		return "ben/psnalPension/psnalPenApr/psnalPenApr";
	}
	

	/**
	 * 개인연금승인 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPsnalPenAprList", method = RequestMethod.POST )
	public ModelAndView getPsnalPenAprList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}
	
	
	/**
	 * 개인연금승인 저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=savePsnalPenApr", method = RequestMethod.POST )
	public ModelAndView savePsnalPenApr(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return saveData(session, request, paramMap);
	}

}
