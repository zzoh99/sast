package com.hr.pap.progress.empPapResultLst;
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

import com.hr.common.com.ComController;
import com.hr.common.logger.Log;
/**
 * 직원평과결과 Controller 
 * 
 * @author JSG
 *
 */
@Controller
@RequestMapping(value="/EmpPapResultLst.do", method=RequestMethod.POST )
public class EmpPapResultLstController extends ComController {
	/**
	 * 사용할 서비스 선언
	 */
	@Inject
	@Named("EmpPapResultLstService")
	private EmpPapResultLstService empPapResultLstService;
	
	/**
	 *  View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewEmpPapResultLst", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewEmpPapResultLst() throws Exception {
		return "pap/progress/empPapResultLst/empPapResultLst";
	}
	
	/**
	 *  View Layer
	 *    
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewEmpPapResultLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewEmpPapResultLayer() throws Exception {
		return "pap/progress/empPapResultLst/empPapResultLayer";
	}

	/**
	 * 직원평과결과 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getEmpPapResultLst", method = RequestMethod.POST )
	public ModelAndView getEmpPapResultLst(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}
	
	/**
	 * 직원평과결과 조직 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPapOrgList", method = RequestMethod.POST )
	public ModelAndView getPapOrgList(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		paramMap.put("ssnGrpCd", session.getAttribute("ssnGrpCd"));
		List<?> result = empPapResultLstService.getPapOrgList(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("codeList", result);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 평가결과피드백 의견 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getEmpPapResultPopMap", method = RequestMethod.POST )
	public ModelAndView getEmpPapResultPopMap(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		Map<?, ?> map = empPapResultLstService.getEmpPapResultPopMap(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("map", map);
		Log.DebugEnd();
		return mv;
	}
	
	/**
	 * 평가결과 피드백 상세 팝업 View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewEmpPapResultPop", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewEmpPapResultPop() throws Exception {
		return "pap/progress/empPapResultLst/empPapResultPop";
	}

	/**
	 * 평가결과 피드백 상세(업적) 팝업 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getEmpPapResultPopList1", method = RequestMethod.POST )
	public ModelAndView getEmpPapResultPopList1(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}

	/**
	 * 평가결과 피드백 상세(역량) 팝업 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getEmpPapResultPopList2", method = RequestMethod.POST )
	public ModelAndView getEmpPapResultPopList2(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}
}
