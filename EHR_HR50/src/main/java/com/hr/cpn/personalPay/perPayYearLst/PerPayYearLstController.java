package com.hr.cpn.personalPay.perPayYearLst;

import com.hr.common.atuhTable.AuthTableService;
import com.hr.common.code.CommonCodeService;
import com.hr.common.com.ComController;
import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;
import com.hr.common.util.StringUtil;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.io.Serializable;
import java.net.URLDecoder;
import java.util.*;
import java.util.stream.Collectors;

/**
 * 연봉관리 Controller
 *
 * @author JSG
 *
 */
@Controller
//@SuppressWarnings("unchecked")
@RequestMapping(value="/PerPayYearLst.do", method=RequestMethod.POST )
public class PerPayYearLstController extends ComController {
	/**
	 * 연봉관리 서비스
	 */
	@Inject
	@Named("PerPayYearLstService")
	private PerPayYearLstService perPayYearLstService;

	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;

	@Inject
	@Named("AuthTableService")
	private AuthTableService authTableService;

	/**
	 * 월별급여지급현황 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewPerPayYearLst", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewPerPayYearLst() throws Exception {
		return "cpn/personalPay/perPayYearLst/perPayYearLst";
	}
	/**
	 *  다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPerPayYearLstTitleList", method = RequestMethod.POST )
	public ModelAndView getPerPayYearLstTitleList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}
	
	/**
	 *  다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPerPayYearLstEleList", method = RequestMethod.POST )
	public ModelAndView getPerPayYearLstEleList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		paramMap.put("columnInfo", URLDecoder.decode(paramMap.get("columnInfo").toString().replaceAll("&#39;", "'"), "UTF-8"));
		
		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = perPayYearLstService.getPerPayYearLstEleList(paramMap);
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
	
	/**
	 *  다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPerPayYearLstList", method = RequestMethod.POST )
	public ModelAndView getPerPayYearLstList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
//		paramMap.put("columnInfo", URLDecoder.decode(paramMap.get("columnInfo").toString().replaceAll("&#39;", "'"), "UTF-8"));
		List<String> elementCd = Arrays.asList(paramMap.get("searchElementCdHidden").toString().split(","));

		List<String> columnInfo = elementCd.stream()
				.map(element -> "'" + element + "' AS ELE_" + element)
				.collect(Collectors.toList());

		paramMap.put("columnInfo", columnInfo);
		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = perPayYearLstService.getPerPayYearLstList(paramMap);
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
