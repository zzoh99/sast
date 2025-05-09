package com.hr.common.language;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
//import java.util.HashMap;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.hr.common.com.ComService;
import com.hr.common.logger.Log;

/**
 * 언어관리 Controller
 *
 * @author CBS
 *
 */
@Controller
@RequestMapping(value="/LangId.do", method=RequestMethod.POST )
public class LangIdController {
	/**
	 * 언어관리 서비스
	 */
	@Inject
	@Named("LangIdService")
	private LangIdService LangIdService;

	/*ComService */
	@Inject
	@Named("ComService")
	private ComService comService;

	/**
	 * 언어관리 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getLangIdList", method = RequestMethod.POST )
	public ModelAndView getLangIdList(
		HttpSession session,  HttpServletRequest request,
		@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		List<?> list  = new ArrayList<Object>();
		String message = "";
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		try{
		list = LangIdService.getLangIdList(paramMap);
		}catch(Exception e){
		message = "kkkk1"; //MultiLangMsg.getMultiLangMsg2Str(request, "MSG_SYS_SELECT_FAIL_001", session.getAttribute("ssnLangId"));
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", message);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 사용 언어관리 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getUseLangIdList", method = RequestMethod.POST )
	public ModelAndView getUseLangIdList(
		HttpSession session,  HttpServletRequest request,
		@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		List<?> list  = new ArrayList<Object>();
		String message = "";
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		try{
		list = LangIdService.getUseLangIdList(paramMap);
		}catch(Exception e){
		message = "kkkk2"; //MultiLangMsg.getMultiLangMsg2Str(request, "MSG_SYS_SELECT_FAIL_001", session.getAttribute("ssnLangId"));
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", message);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 기본 사용언어 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getDefaultUseLangId", method = RequestMethod.POST )
	public ModelAndView getDefaultLangIdList(
		HttpSession session,  HttpServletRequest request,
		@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		Map<?, ?> map = LangIdService.getDefaultUseLangId(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("map", map);
		Log.DebugEnd();
		return mv;
	}



	/**
	 * 언어코드 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getLangIdCodeList", method = RequestMethod.POST )
	public ModelAndView getLangIdCodeList(
		HttpSession session,  HttpServletRequest request,
		@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		List<?> list  = new ArrayList<Object>();
		String message = "";
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		try{
		list = LangIdService.getLangIdCodeList(paramMap);
		}catch(Exception e){
		message = "kkkk3"; //MultiLangMsg.getMultiLangMsg2Str(request, "MSG_SYS_SELECT_FAIL_001", session.getAttribute("ssnLangId"));
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", message);
		Log.DebugEnd();
		return mv;
	}


	@RequestMapping(params="cmd=getMessage", method = RequestMethod.POST )
	public ModelAndView getMessage(
		HttpSession session,  HttpServletRequest request,
		@RequestParam Map<String, Object> paramMap ) throws Exception {
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnLocaleCd", session.getAttribute("ssnLocaleCd"));
		paramMap.put("keyLevel", paramMap.get("keyLevel"));

		if(paramMap.get("convReturn") != null && "Y".equals(paramMap.get("convReturn")) ) {
			paramMap.put("convReturn", "Y");
		} else {
			paramMap.put("convReturn", "N");
		}

		Log.DebugStart();
		List<?> list  = new ArrayList<Object>();


		String chkLocaleQueryId =  (String.valueOf(session.getAttribute("ssnLocaleCd")).equals("") ? "getNullLocaleMessageMap" : "getLocaleMessageMap");
		list =  comService.getComQueryList(paramMap,chkLocaleQueryId);

//		Log.Debug(list.toString());
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("msg", list);
		Log.DebugEnd();
		return mv;
	}

	@RequestMapping(params="cmd=getLoinMessageMap", method = RequestMethod.POST )
	public ModelAndView getLoinMessageMap(
		HttpSession session,  HttpServletRequest request,
		@RequestParam Map<String, Object> paramMap ) throws Exception {
		ModelAndView mv = null;
		paramMap.put("localeCd", paramMap.get("localeCd"));
		paramMap.put("keyLevel", paramMap.get("keyLevel"));
		
		Log.DebugStart();
		List<?> list = comService.getComQueryList(paramMap,"common.language.getLoinMessageMap");
		mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("msg", list);
		Log.DebugEnd();
		return mv;
	}


	/**
	 * 사용언어 조회
	 *
	 * @param paramMap
	 * @param request
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getLocaleList", method = RequestMethod.POST )
	public ModelAndView getLocaleList(HttpSession session,HttpServletRequest request ,
						@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		String enterCd = paramMap.get("enterCd")==null ? "": paramMap.get("enterCd").toString();
		paramMap.put("ssnEnterCd",  enterCd.equals("") ? session.getAttribute("ssnEnterCd") : enterCd);
		paramMap.put("ssnLocaleCd", session.getAttribute("ssnLocaleCd"));
		List<?> result = comService.getComQueryList(paramMap, "getLocaleList");
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("list", result);
		Log.DebugEnd();
		return mv;
	}

	@RequestMapping(params="cmd=changeLocale", method = RequestMethod.POST )
	public ModelAndView languageChange(
		HttpSession session,
		HttpServletResponse response,
		HttpServletRequest request,
		@RequestParam Map<String, Object> paramMap) throws Exception {
		paramMap.put("ssnEnterCd",	session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",	session.getAttribute("ssnSabun"));
		paramMap.put("ssnGrpCd",	session.getAttribute("ssnGrpCd"));
		paramMap.put("ssnLocaleCd",	paramMap.get("strLocale").toString());

		Map<?,?> langSub = comService.getComQueryMap(paramMap,"getchangeLocaleSub");
		if(langSub != null) {
			session.removeAttribute("ssnGrpNm");
			session.setAttribute("ssnGrpNm", langSub.get("ssnGrpNm"));
			
			session.removeAttribute("ssnName");
			session.setAttribute("ssnName", langSub.get("ssnName"));
			
			session.removeAttribute("ssnEnterNm");
			session.setAttribute("ssnEnterNm", langSub.get("ssnEnterNm"));
			
			comService.changeLocale(session, request, response, paramMap);
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("success", "yes");
		return mv;
	}


	@RequestMapping(params="cmd=getSequence", method = RequestMethod.POST )
	public ModelAndView getSequence(
			HttpSession session,
			@RequestParam Map<String, Object> paramMap ) throws Exception {

		String seqNum = LangIdService.langCdSequence();
		Map<String, String> map = new HashMap<String, String>();
		map.put("seqNum", seqNum);

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("map", map);
		return mv;
	}

	@RequestMapping(params="cmd=getLangCdTword", method = RequestMethod.POST )
	public ModelAndView getLangCdTword(
			HttpSession session,
			@RequestParam Map<String, Object> paramMap ) throws Exception {

		String seqNumTword = LangIdService.getLangCdTword(paramMap);
		Map<String, String> map = new HashMap<String, String>();

		map.put("seqNumTword", seqNumTword);

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("map", map);
		return mv;
	}



}