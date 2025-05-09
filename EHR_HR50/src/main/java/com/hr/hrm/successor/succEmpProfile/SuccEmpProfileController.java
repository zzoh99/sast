package com.hr.hrm.successor.succEmpProfile;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import com.hr.hrm.psnalInfo.psnalKeyword.PsnalKeywordService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.hr.common.com.ComController;
import com.hr.common.logger.Log;

/**
 * 임직원 Timeline 조회
 * @author gjyoo
 *
 */
@Controller
@RequestMapping(value="/SuccEmpProfile.do", method=RequestMethod.POST )
public class SuccEmpProfileController extends ComController {

	@Inject
	@Named("PsnalKeywordService")
	private PsnalKeywordService psnalKeywordService;

	
	/**
	 * 임직원 Timeline 조회 View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewSuccEmpProfile", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewSuccEmpProfile() throws Exception {
		return "hrm/successor/succEmpProfile/succEmpProfile";
	}

	/**
	 * 임직원 Timeline 조회 > 임직원 목록 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getSuccEmpProfileEmpList", method = RequestMethod.POST )
	public ModelAndView getSuccEmpProfileEmpList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}
	
	/**
	 * 임직원 Timeline 조회 > Timeline 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getSuccAppmtTimelineSrchTimelineList", method = RequestMethod.POST )
	public ModelAndView getAppmtTimelineSrchTimelineList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}
	
	/**
	 * 임직원 Timeline 조회 > 연봉 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getSuccAppmtTimelineSrchCpnChartList", method = RequestMethod.POST )
	public ModelAndView getAppmtTimelineSrchCpnChartList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}
	
	/**
	 * 임직원 Timeline 조회 > 성과 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getSuccAppmtTimelineSrchPapChartList", method = RequestMethod.POST )
	public ModelAndView getAppmtTimelineSrchPapChartList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}

	/**
	 * 임직원 Timeline 조회 > 근속연수 단건 조회 단건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getSuccAppmtTimelineSrchWorkYearChartList", method = RequestMethod.POST )
	public ModelAndView getAppmtTimelineSrchWorkYearChartList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataMap(session, request, paramMap);
	}

	/**
	 *  임직원 Timeline 조회 > 연차 단건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getSuccAppmtTimelineSrchVacationChartList", method = RequestMethod.POST )
	public ModelAndView getAppmtTimelineSrchVacationChartList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataMap(session, request, paramMap);
	}
	
	/**
	 * 임직원 Timeline 조회 > 임직원 목록 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getSuccEmpTimelineSrchEmpList", method = RequestMethod.POST )
	public ModelAndView getSuccEmpTimelineSrchEmpList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		String sabunStr = paramMap.get("searchSabunList").toString().replaceAll("&#39;", "");
		String[] sabunList = sabunStr.split(",");
		paramMap.put("searchSabunList", sabunList);
		return getDataList(session, request, paramMap);
	}

	/**
	 * psnalKeyword 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPsnalKeywordList", method = RequestMethod.POST )
	public ModelAndView getPsnalKeywordList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = psnalKeywordService.getPsnalKeywordList(paramMap);
		}catch(Exception e){
			Message="조회에 실패 하였습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}
}
