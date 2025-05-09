package com.hr.cpn.personalPay.psnalPayUser;

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
 * 개인급여내역 Controller
 *
 */
@Controller
@RequestMapping(value="/PsnalPayUser.do", method=RequestMethod.POST )
public class PsnalPayUserController {

	/**
	 * 개인급여내역 서비스
	 */
	@Inject
	@Named("PsnalPayUserService")
	private PsnalPayUserService psnalPayUserService;

	/**
	 * 개인급여내역 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewPsnalPayUser", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewPsnalPayUser() throws Exception {
		return "cpn/personalPay/psnalPayUser/psnalPayUser";
	}

	/**
	 * 개인급여내역 급여상세 Layer View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewPsnalPayDetailUserLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewPsnalPayDetailUserLayer() throws Exception {
		return "cpn/personalPay/psnalPayUser/psnalPayDetailUserLayer";
	}

	/**
	 * 개인급여내역 항목별세부내역 Layer View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewPsnalPayItemDetailUserLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewPsnalPayItemDetailUserLayer() throws Exception {
		return "cpn/personalPay/psnalPayUser/psnalPayItemDetailUserLayer";
	}

	/**
	 * 개인급여내역 급여계산방법 View Layer
	 *
	 * @return String
	 * @throws Exception
	 */

	@RequestMapping(params="cmd=viewPsnalPayFormulaUserLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewPsnalPayFormulaUserLayer() throws Exception {
		return "cpn/personalPay/psnalPayUser/psnalPayFormulaUserLayer";
	}

	/**
	 * 개인별급여내역 기간별 합산 단건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPsnalPayUserBaseInfo", method = RequestMethod.POST )
	public ModelAndView getPsnalPayUserBaseInfo(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");

		try {
			Map<String, Object> map = psnalPayUserService.getPsnalPayUserBaseInfo(paramMap);
			mv.addObject("map", map);
		} catch(Exception e) {
			Log.Error(" ** 개인별 급여내역 중 기본내역 조회 시 오류가 발생하였습니다. >> " + e.getLocalizedMessage());
			mv.addObject("msg", "조회에 실패하였습니다.");
			mv.addObject("map", new HashMap<String, Object>());
		}

		Log.DebugEnd();
		return mv;
	}

	/**
	 * 개인별급여내역 급여내역 상세리스트 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPsnalPayUserDetailList", method = RequestMethod.POST )
	public ModelAndView getPsnalPayUserDetailList(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");

		try {
			Map<String, Object> map = psnalPayUserService.getPsnalPayUserDetailList(paramMap);
			mv.addObject("map", map);
		} catch(Exception e) {
			Log.Error(" ** 개인별 급여내역 중 상세리스트 조회 시 오류가 발생하였습니다. >> " + e.getLocalizedMessage());
			mv.addObject("msg", "조회에 실패하였습니다.");
			mv.addObject("map", new HashMap<String, Object>());
		}

		Log.DebugEnd();
		return mv;
	}

	/**
	 * 개인별급여내역 급여상세레이어 급여 리스트 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPsnalPayDetailUserPayActionList", method = RequestMethod.POST )
	public ModelAndView getPsnalPayDetailUserPayActionList(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");

		try {
			List<Map<String, Object>> list = psnalPayUserService.getPsnalPayDetailUserPayActionList(paramMap);
			mv.addObject("list", list);
		} catch(Exception e) {
			Log.Error(" ** 개인별 급여내역 중 항목별 계산방법 조회 시 오류가 발생하였습니다. >> " + e.getLocalizedMessage());
			mv.addObject("msg", "조회에 실패하였습니다.");
			mv.addObject("list", new ArrayList<>());
		}

		Log.DebugEnd();
		return mv;
	}

	/**
	 * 개인별급여내역 급여상세레이어 단건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPsnalPayDetailUser", method = RequestMethod.POST )
	public ModelAndView getPsnalPayDetailUser(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");

		try {
			Map<String, Object> map = psnalPayUserService.getPsnalPayDetailUser(paramMap);
			mv.addObject("map", map);
		} catch(Exception e) {
			Log.Error(" ** 개인별 급여내역 중 급여상세 조회 시 오류가 발생하였습니다. >> " + e.getLocalizedMessage());
			mv.addObject("msg", "조회에 실패하였습니다.");
			mv.addObject("map", new HashMap<String, Object>());
		}

		Log.DebugEnd();
		return mv;
	}

	/**
	 * 개인별급여내역 항목별 세부내역 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPsnalPayItemDetailUser", method = RequestMethod.POST )
	public ModelAndView getPsnalPayItemDetailUser(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");

		try {
			Map<String, Object> map = psnalPayUserService.getPsnalPayItemDetailUser(paramMap);
			mv.addObject("map", map);
		} catch(Exception e) {
			Log.Error(" ** 개인별 급여내역 중 항목별 세부내역 조회 시 오류가 발생하였습니다. >> " + e.getLocalizedMessage());
			mv.addObject("msg", "조회에 실패하였습니다.");
			mv.addObject("map", new HashMap<String, Object>());
		}

		Log.DebugEnd();
		return mv;
	}

	/**
	 * 개인별급여내역 항목별 계산방법 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPsnalPayFormulaUser", method = RequestMethod.POST )
	public ModelAndView getPsnalPayFormulaUser(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");

		try {
			Map<String, Object> map = psnalPayUserService.getPsnalPayFormulaUser(paramMap);
			mv.addObject("map", map);
		} catch(Exception e) {
			Log.Error(" ** 개인별 급여내역 중 항목별 계산방법 조회 시 오류가 발생하였습니다. >> " + e.getLocalizedMessage());
			mv.addObject("msg", "조회에 실패하였습니다.");
			mv.addObject("map", new HashMap<String, Object>());
		}

		Log.DebugEnd();
		return mv;
	}
}
