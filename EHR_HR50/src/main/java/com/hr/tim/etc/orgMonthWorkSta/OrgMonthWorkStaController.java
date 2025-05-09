package com.hr.tim.etc.orgMonthWorkSta;
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
import com.hr.common.com.ComController;
import com.hr.common.logger.Log;

/**
 * 부서별월근태현황 Controller 
 * 
 * @author 이름
 *
 */
@Controller
@RequestMapping(value="/OrgMonthWorkSta.do", method=RequestMethod.POST )
public class OrgMonthWorkStaController extends ComController {
	/**
	 * 부서별월근태현황 서비스
	 */
	@Inject
	@Named("OrgMonthWorkStaService")
	private OrgMonthWorkStaService requiredStaService;	
	
	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;
	
	
	/**
	 * 부서별월근태현황 View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewOrgMonthWorkSta", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewOrgMonthWorkSta() throws Exception {
		return "tim/etc/orgMonthWorkSta/orgMonthWorkSta";
	}
	
	/**
	 * 부서별월근태현황 -세부내역팝업 View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewOrgMonthWorkStaPop", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewOrgMonthWorkStaPop() throws Exception {
		return "tim/etc/orgMonthWorkSta/orgMonthWorkStaPop";
	}

	@RequestMapping(params="cmd=viewOrgMonthWorkStaLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewOrgMonthWorkStaLayer() throws Exception {
		return "tim/etc/orgMonthWorkSta/orgMonthWorkStaLayer";
	}

	/**
	 * 조직콤보 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getOrgMonthWorkStaOrgList", method = RequestMethod.POST )
	public ModelAndView getOrgMonthWorkStaOrgList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = requiredStaService.getOrgMonthWorkStaOrgList(paramMap);
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
	 * 부서별월근태현황 Title 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getOrgMonthWorkStaTitleList", method = RequestMethod.POST )
	public ModelAndView getOrgMonthWorkStaTitleList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = requiredStaService.getOrgMonthWorkStaTitleList(paramMap);
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
	 * 부서별월근태현황 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getOrgMonthWorkStaList", method = RequestMethod.POST )
	public ModelAndView getOrgMonthWorkStaList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		List<?> titleList = requiredStaService.getOrgMonthWorkStaTitleList(paramMap);
		paramMap.put("titles", titleList);

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = requiredStaService.getOrgMonthWorkStaList(paramMap);
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
	 * 부서별월근태현황 팝업 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getOrgMonthWorkStaPopList", method = RequestMethod.POST )
	public ModelAndView getOrgMonthWorkStaPopList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = requiredStaService.getOrgMonthWorkStaPopList(paramMap);
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
