package com.hr.ben.psnalPension.psnalPenStd;
import java.util.ArrayList;
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
 * 개인연금기준관리 Controller 
 * 
 * @author 이름
 *
 */
@Controller
@RequestMapping(value="/PsnalPenStd.do", method=RequestMethod.POST )
public class PsnalPenStdController extends ComController {
	/**
	 * 개인연금기준관리 서비스
	 */
	@Inject
	@Named("PsnalPenStdService")
	private PsnalPenStdService psnalPenStdService;	
	
	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;
	
	
	/**
	 * 개인연금기준관리 View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewPsnalPenStd", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewPsnalPenStd() throws Exception {
		return "ben/psnalPension/psnalPenStd/psnalPenStd";
	}
	
	/**
	 * 개인연금기준관리 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPsnalPenStdList", method = RequestMethod.POST )
	public ModelAndView getPsnalPenStdList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}

	/**
	 * 개인연금기준관리 - 가입상품 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPsnalPenStdList2", method = RequestMethod.POST )
	public ModelAndView getPsnalPenStdList2(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}
	
	
	/**
	 * 개인연금기준관리 저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=savePsnalPenStd", method = RequestMethod.POST )
	public ModelAndView savePsnalPenStd(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();  
		
		 //테이블명, 컬럼명,  파라메터키, 데이터 타입
		String[] dupList= {"TBEN650", "ENTER_CD,JIKGUB_CD,SDATE", "ssnEnterCd,jikgubCd,sdate", "s,s,s"};
		paramMap.put("dupList", dupList);
		
		return saveData(session, request, paramMap);
	}
	
	
	/**
	 * 개인연금기준관리-가입상품 저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=savePsnalPenStd2", method = RequestMethod.POST )
	public ModelAndView savePsnalPenStd2(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();  
		return saveData(session, request, paramMap);
	}
}
