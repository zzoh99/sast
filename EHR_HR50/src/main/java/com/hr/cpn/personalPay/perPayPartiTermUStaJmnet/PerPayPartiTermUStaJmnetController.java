package com.hr.cpn.personalPay.perPayPartiTermUStaJmnet;
import java.util.ArrayList;
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
/**
 * 메뉴명 Controller
 *
 * @author 이름
 *
 */
@Controller
@RequestMapping(value="/PerPayPartiTermUStaJmnet.do", method=RequestMethod.POST )
public class PerPayPartiTermUStaJmnetController {
	/**
	 * 메뉴명 서비스
	 */
	@Inject
	@Named("PerPayPartiTermUStaJmnetService")
	private PerPayPartiTermUStaJmnetService perPayPartiTermUStaJmnetService;

	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;


	/**
	 * 메뉴명 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewPerPayPartiTermUStaJmnet", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewPerPayPartiTermUStaJmnet() throws Exception {
		return "cpn/personalPay/perPayPartiTermUStaJmnet/perPayPartiTermUStaJmnet";
	}


	/**
	 * 메뉴명 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPerPayPartiTermUStaJmnetList", method = RequestMethod.POST )
	public ModelAndView getPerPayPartiTermUStaJmnetList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		List<?> list  = new ArrayList<Object>();
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

		String Message = "";
		try{
			list = perPayPartiTermUStaJmnetService.getPerPayPartiTermUStaJmnetList(paramMap);
		}catch(Exception e){
			Message="조회에 실패하였습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}
	/**
	 * 메뉴명 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPerPayPartiTermUStaJmnetListFirst", method = RequestMethod.POST )
	public ModelAndView getPerPayPartiTermUStaJmnetListFirst(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		List<?> list  = new ArrayList<Object>();
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

		String Message = "";
		try{
			list = perPayPartiTermUStaJmnetService.getPerPayPartiTermUStaJmnetListFirst(paramMap);
		}catch(Exception e){
			Message="조회에 실패하였습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}
	/**
	 * 메뉴명 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPerPayPartiTermUStaJmnetListSecond", method = RequestMethod.POST )
	public ModelAndView getPerPayPartiTermUStaJmnetListSecond(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		List<?> list  = new ArrayList<Object>();
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

		String Message = "";
		try{
			list = perPayPartiTermUStaJmnetService.getPerPayPartiTermUStaJmnetListSecond(paramMap);
		}catch(Exception e){
			Message="조회에 실패하였습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}

}
