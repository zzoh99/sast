package com.hr.ben.scholarship.schAppDet;
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
 * 학자금신청 세부내역 Controller
 *
 * @author bckim
 *
 */
@Controller
@RequestMapping({"/SchAppDet.do", "/SchApp.do"})
public class SchAppDetController extends ComController {

	/**
	 * 학자금신청 세부내역 서비스
	 */
	@Inject
	@Named("SchAppDetService")
	private SchAppDetService schAppDetService;

	/**
	 * 학자금신청 세부내역 View
	 *
	 * @param paramMap
	 * @param request
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewSchAppDet", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewSchAppDet() throws Exception {
		return "ben/scholarship/schAppDet/schAppDet";
	}
	
	/**
	 * 경조신청 상세 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getSchAppDetMap", method = RequestMethod.POST )
	public ModelAndView getSchAppDetMap(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataMap(session, request, paramMap);
	}
	
	/**
	 * 학자금신청 중복 체크 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getSchAppDupChk", method = RequestMethod.POST )
	public ModelAndView getSchAppDupChk(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataMap(session, request, paramMap);
	}
	
	/**
	 * 학자금 담당자 저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveSchAppDetAdmin", method = RequestMethod.POST )
	public ModelAndView saveSchAppDetAdmin(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return saveData(session, request, paramMap);
	}
	
	/**
	 * 학자금 저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveSchAppDet", method = RequestMethod.POST )
	public ModelAndView saveSchAppDet(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return saveData(session, request, paramMap);
	}
	
	/**
	 * 학자금신청 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getSchAppDetList", method = RequestMethod.POST )
	public ModelAndView getSchAppDetList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}
	
	/**
	 * 신청기준 목록 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getSchAppDetStdDataList", method = RequestMethod.POST )
	public ModelAndView getSchAppDetStdDataList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}
}
