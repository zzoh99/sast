package com.hr.cpn.personalPay.psnalSalaryMasterUser;

import com.hr.common.logger.Log;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 개인임금마스터 Controller
 *
 */
@Controller
@RequestMapping(value="/PsnalSalaryMasterUser.do", method=RequestMethod.POST )
public class PsnalSalaryMasterUserController {

	/**
	 * 개인임금마스터 서비스
	 */
	@Inject
	@Named("PsnalSalaryMasterUserService")
	private PsnalSalaryMasterUserService psnalSalaryMasterUserService;

	/**
	 * 개인임금마스터 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewPsnalSalaryMasterUser", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewPsnalSalaryMasterUser() throws Exception {
		return "cpn/personalPay/psnalSalaryMasterUser/psnalSalaryMasterUser";
	}

	/**
	 * 개인임금마스터 히스토리 Layer
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewPsnalSalaryMasterUserHistoryLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewPsnalSalaryMasterUserHistoryLayer() throws Exception {
		return "cpn/personalPay/psnalSalaryMasterUser/psnalSalaryMasterUserHistoryLayer";
	}

	/**
	 * 개인임금마스터 기본사항 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPsnalSalaryMasterUserBasic", method = RequestMethod.POST )
	public ModelAndView getPsnalSalaryMasterUserBasic(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnLocaleCd", session.getAttribute("ssnLocaleCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		String Message = "";

		Map<String, Object> result  = new HashMap<>();
		try{
			result = psnalSalaryMasterUserService.getPsnalSalaryMasterUserBasic(paramMap);
		}catch(Exception e){
			Message="조회에 실패 하였습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", result);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 개인임금마스터 지급/공제내역 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPsnalSalaryMasterUserPay", method = RequestMethod.POST )
	public ModelAndView getPsnalSalaryMasterUserPay(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnLocaleCd", session.getAttribute("ssnLocaleCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		String Message = "";

		Map<String, Object> result  = new HashMap<>();
		try{
			result = psnalSalaryMasterUserService.getPsnalSalaryMasterUserPay(paramMap);
		}catch(Exception e){
			Message="조회에 실패 하였습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", result);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 개인임금마스터 연봉이력 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPsnalSalaryMasterUserSalary", method = RequestMethod.POST )
	public ModelAndView getPsnalSalaryMasterUserSalary(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnLocaleCd", session.getAttribute("ssnLocaleCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		String Message = "";

		Map<String, Object> result  = new HashMap<>();
		try{
			result = psnalSalaryMasterUserService.getPsnalSalaryMasterUserSalary(paramMap);
		}catch(Exception e){
			Message="조회에 실패 하였습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", result);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 개인임금마스터 급여압류 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPsnalSalaryMasterUserPayGrns", method = RequestMethod.POST )
	public ModelAndView getPsnalSalaryMasterUserPayGrns(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnLocaleCd", session.getAttribute("ssnLocaleCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		String Message = "";

		Map<String, Object> result  = new HashMap<>();
		try{
			result = psnalSalaryMasterUserService.getPsnalSalaryMasterUserPayGrns(paramMap);
		}catch(Exception e){
			Message="조회에 실패 하였습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", result);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 개인임금마스터 사회보험 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPsnalSalaryMasterUserInsr", method = RequestMethod.POST )
	public ModelAndView getPsnalSalaryMasterUserInsr(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnLocaleCd", session.getAttribute("ssnLocaleCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		String Message = "";

		Map<String, Object> result  = new HashMap<>();
		try{
			result = psnalSalaryMasterUserService.getPsnalSalaryMasterUserInsr(paramMap);
		}catch(Exception e){
			Message="조회에 실패 하였습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", result);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 개인임금마스터 이력 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPsnalSalaryMasterUserPeak", method = RequestMethod.POST )
	public ModelAndView getPsnalSalaryMasterUserPeak(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnLocaleCd", session.getAttribute("ssnLocaleCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		String Message = "";

		List<?> result  = new ArrayList<>();
		try{
			result = psnalSalaryMasterUserService.getPsnalSalaryMasterUserPeak(paramMap);
		}catch(Exception e){
			Message="조회에 실패 하였습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", result);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 개인임금마스터 이력 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPsnalSalaryMasterUserHistory", method = RequestMethod.POST )
	public ModelAndView getPsnalSalaryMasterUserHistory(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnLocaleCd", session.getAttribute("ssnLocaleCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		String Message = "";

		List<?> result  = new ArrayList<>();
		try{
			result = psnalSalaryMasterUserService.getPsnalSalaryMasterUserHistory(paramMap);
		}catch(Exception e){
			Message="조회에 실패 하였습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", result);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}
}
