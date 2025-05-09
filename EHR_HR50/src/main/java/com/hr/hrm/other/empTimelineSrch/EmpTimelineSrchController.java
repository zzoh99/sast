package com.hr.hrm.other.empTimelineSrch;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import com.hr.common.rd.EncryptRdService;
import com.hr.hrm.psnalInfo.psnalKeyword.PsnalKeywordService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
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
@RequestMapping(value="/EmpTimelineSrch.do", method=RequestMethod.POST )
public class EmpTimelineSrchController extends ComController {

	@Inject
	@Named("EncryptRdService")
	private EncryptRdService encryptRdService;

	@Inject
	@Named("PsnalKeywordService")
	private PsnalKeywordService psnalKeywordService;

	
	/**
	 * 임직원 Timeline 조회 View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewEmpTimelineSrch", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewEmpTimelineSrch() throws Exception {
		return "hrm/other/empTimelineSrch/empTimelineSrch";
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
	@RequestMapping(params="cmd=getEmpTimelineSrchEmpList", method = RequestMethod.POST )
	public ModelAndView getEmpTimelineSrchEmpList(
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
	@RequestMapping(params="cmd=getAppmtTimelineSrchTimelineList", method = RequestMethod.POST )
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
	@RequestMapping(params="cmd=getAppmtTimelineSrchCpnChartList", method = RequestMethod.POST )
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
	@RequestMapping(params="cmd=getAppmtTimelineSrchPapChartList", method = RequestMethod.POST )
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
	@RequestMapping(params="cmd=getAppmtTimelineSrchWorkYearChartList", method = RequestMethod.POST )
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
	@RequestMapping(params="cmd=getAppmtTimelineSrchVacationChartList", method = RequestMethod.POST )
	public ModelAndView getAppmtTimelineSrchVacationChartList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataMap(session, request, paramMap);
	}

	/**
	 * RD 데이터 암호화
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getEncryptRd", method = RequestMethod.POST )
	public ModelAndView getEncryptRd(
			HttpSession session, HttpServletRequest request
			, @RequestBody Map<String, Object> paramMap) throws Exception{
		Log.DebugStart();

		String mrdPath = "/hrm/empcard/SuccessorCard.mrd";
		String param = "/rp " + paramMap.get("parameters");

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		try {
			mv.addObject("DATA", encryptRdService.encrypt(mrdPath, param));
			mv.addObject("Message", "");
		} catch (Exception e) {
			mv.addObject("Message", "암호화에 실패했습니다.");
		}

		Log.DebugEnd();
		return mv;
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
