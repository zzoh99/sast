package com.hr.ben.occasion.occApr;
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
 * 경조승인 Controller
 *
 * @author 이름
 *
 */
@Controller
@RequestMapping(value="/OccApr.do", method=RequestMethod.POST )
public class OccAprController extends ComController {
	/**
	 * 경조승인 서비스
	 */
	@Inject
	@Named("OccAprService")
	private OccAprService occAprService;


	/**
	 * 경조승인 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewOccApr",method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewOccApr() throws Exception {
		return "ben/occasion/occApr/occApr";
	}
	

	/**
	 * 경조승인 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getOccAprList", method = RequestMethod.POST )
	public ModelAndView getOccAprList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}
	
	
	/**
	 * 경조승인 저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveOccApr", method = RequestMethod.POST )
	public ModelAndView saveOccApr(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return saveData(session, request, paramMap);
	}

}
