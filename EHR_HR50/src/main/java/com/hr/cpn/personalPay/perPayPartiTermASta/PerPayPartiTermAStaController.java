package com.hr.cpn.personalPay.perPayPartiTermASta;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.HashMap;
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
import com.hr.common.language.LanguageUtil;
import com.hr.common.logger.Log;
/**
 * 메뉴명 Controller
 *
 * @author 이름
 *
 */
@Controller
@RequestMapping({"/PerPayPartiTermASta.do", "/PerPayPartiTermUSta.do"})
public class PerPayPartiTermAStaController {
	/**
	 * 메뉴명 서비스
	 */
	@Inject
	@Named("PerPayPartiTermAStaService")
	private PerPayPartiTermAStaService perPayPartiTermAStaService;

	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;


	/**
	 * 메뉴명 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewPerPayPartiTermASta", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewPerPayPartiTermASta() throws Exception {
		return "cpn/personalPay/perPayPartiTermASta/perPayPartiTermASta";
	}
	/**
	 * 메뉴명 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewPerPayPartiTermASta2", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewPerPayPartiTermASta2() throws Exception {
		return "perPayPartiTermASta/perPayPartiTermASta";
	}

	/**
	 * Popup View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewPerPayPartiTermAStaPopup", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewPerPayPartiTermAStaPopup() throws Exception {
		return "cpn/personalPay/perPayPartiTermASta/perPayPartiTermAStaPopup";
	}
	@RequestMapping(params="cmd=viewPerPayPartiTermAStaLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewPerPayPartiTermAStaLayer() throws Exception {
		return "cpn/personalPay/perPayPartiTermASta/perPayPartiTermAStaLayer";
	}

	/**
	 * 기간별급여세부내역(관리자) 항목리스트 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPerPayPartiTermAStaTitleList", method = RequestMethod.POST )
	public ModelAndView getPerPayPartiTermAStaTitleList(
				HttpSession session
			, 	HttpServletRequest request
			,	@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",  session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnLocaleCd", session.getAttribute("ssnLocaleCd"));

		List<?> list = new ArrayList<Object>();
		String Message = "";

		try {
			list = perPayPartiTermAStaService.getPerPayPartiTermAStaTitleList(paramMap);
		}catch(Exception e){
			Message=LanguageUtil.getMessage("msg.alertSearchFail", null, "조회 중 오류가 발생하였습니다.");
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
//	@RequestMapping(params="cmd=getPerPayPartiTermAStaList", method = RequestMethod.POST )
//	public ModelAndView getPerPayPartiTermAStaList(
//				HttpSession session
//			,  	HttpServletRequest request
//			,	@RequestParam Map<String, Object> paramMap ) throws Exception {
//		Log.DebugStart();
//
//		List<?> list  = new ArrayList<Object>();
//		paramMap.put("ssnSabun",   session.getAttribute("ssnSabun"));
//		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
//
//		String Message = "";
//		try {
//			list = perPayPartiTermAStaService.getPerPayPartiTermAStaList(paramMap);
//		} catch(Exception e) {
//			Message="조회에 실패하였습니다.";
//		}
//
//		ModelAndView mv = new ModelAndView();
//		mv.setViewName("jsonView");
//		mv.addObject("DATA", list);
//		mv.addObject("Message", Message);
//
//		Log.DebugEnd();
//
//		return mv;
//	}

	@RequestMapping(params="cmd=getPerPayPartiTermAStaList", method = RequestMethod.POST )
	public ModelAndView getPerPayPartiTermAStaList(
				HttpSession session
			,  	HttpServletRequest request
			,	@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnSabun",    session.getAttribute("ssnSabun"));
		paramMap.put("ssnLocaleCd", session.getAttribute("ssnLocaleCd"));
		paramMap.put("ssnEnterCd",  session.getAttribute("ssnEnterCd"));

		HashMap<String, String> mapElement = null;
		List<?> titleList = new ArrayList<Object>();
		List<Serializable> titles = new ArrayList<Serializable>();
		List<?> list = new ArrayList<Object>();
		String	Message = "";

		try {
			// 기간별급여세부내역(관리자) 항목리스트 다건 조회
			titleList = perPayPartiTermAStaService.getPerPayPartiTermAStaTitleList(paramMap);

			for(int i = 0 ; i < titleList.size() ; i++) {
				mapElement = new HashMap<String, String>();
				Map<String, String> map = (Map)titleList.get(i);
				mapElement.put("elementCd", map.get("elementCd").toString());
				titles.add(mapElement);
				paramMap.put("titles", titleList);
			}

			list = perPayPartiTermAStaService.getPerPayPartiTermAStaList(paramMap);
		} catch(Exception e) {
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
