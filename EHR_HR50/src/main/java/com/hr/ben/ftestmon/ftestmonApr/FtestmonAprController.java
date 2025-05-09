package com.hr.ben.ftestmon.ftestmonApr;
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

/**
 * 어학시험응시료승인 Controller
 *
 * @author 이름
 *
 */
@Controller
@RequestMapping(value="/FtestmonApr.do", method=RequestMethod.POST )
public class FtestmonAprController extends ComController {
	/**
	 * 어학시험응시료승인 서비스
	 */
	@Inject
	@Named("FtestmonAprService")
	private FtestmonAprService ftestmonAprService;

	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;

	/**
	 * 어학시험응시료승인 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewFtestmonApr",method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewFtestmonApr() throws Exception {
		return "ben/ftestmon/ftestmonApr/ftestmonApr";
	}

	/**
	 * 어학시험응시료승인 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getFtestmonAprList", method = RequestMethod.POST )
	public ModelAndView getFtestmonAprList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}
	
	
	/**
	 * 어학시험응시료승인 저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveFtestmonApr", method = RequestMethod.POST )
	public ModelAndView saveFtestmonApr(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return saveData(session, request, paramMap);
	}

}
