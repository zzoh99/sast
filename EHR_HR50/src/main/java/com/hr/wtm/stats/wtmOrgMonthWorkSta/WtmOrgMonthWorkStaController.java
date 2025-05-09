package com.hr.wtm.stats.wtmOrgMonthWorkSta;

import com.hr.common.com.ComController;
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
import java.util.List;
import java.util.Map;

/**
 * 부서별월근태현황 Controller 
 * 
 * @author 이름
 *
 */
@Controller
@RequestMapping(value="/WtmOrgMonthWorkSta.do", method=RequestMethod.POST )
public class WtmOrgMonthWorkStaController extends ComController {
	/**
	 * 부서별월근태현황 서비스
	 */
	@Inject
	@Named("WtmOrgMonthWorkStaService")
	private WtmOrgMonthWorkStaService wtmOrgMonthWorkStaService;

	/**
	 * 부서별월근태현황 View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewWtmOrgMonthWorkSta",method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewWtmOrgMonthWorkSta() throws Exception {
		return "wtm/stats/wtmOrgMonthWorkSta/wtmOrgMonthWorkSta";
	}
	
	/**
	 * 부서별월근태현황 -세부내역팝업 View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewWtmOrgMonthWorkStaLayer",method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewWtmOrgMonthWorkStaLayer() throws Exception {
		return "wtm/stats/wtmOrgMonthWorkSta/wtmOrgMonthWorkStaLayer";
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
	@RequestMapping(params="cmd=getWtmOrgMonthWorkStaOrgList", method = RequestMethod.POST )
	public ModelAndView getWtmOrgMonthWorkStaOrgList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<>();
		String Message = "";
		try{
			list = wtmOrgMonthWorkStaService.getWtmOrgMonthWorkStaOrgList(paramMap);
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
	@RequestMapping(params="cmd=getWtmOrgMonthWorkStaTitleList", method = RequestMethod.POST )
	public ModelAndView getWtmOrgMonthWorkStaTitleList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<>();
		String Message = "";
		try{
			list = wtmOrgMonthWorkStaService.getWtmOrgMonthWorkStaTitleList(paramMap);
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
	@RequestMapping(params="cmd=getWtmOrgMonthWorkStaList", method = RequestMethod.POST )
	public ModelAndView getWtmOrgMonthWorkStaList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		List<?> titleList = wtmOrgMonthWorkStaService.getWtmOrgMonthWorkStaTitleList(paramMap);
		paramMap.put("titles", titleList);

		List<?> list  = new ArrayList<>();
		String Message = "";
		try{
			list = wtmOrgMonthWorkStaService.getWtmOrgMonthWorkStaList(paramMap);
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
	@RequestMapping(params="cmd=getWtmOrgMonthWorkStaPopList", method = RequestMethod.POST )
	public ModelAndView getWtmOrgMonthWorkStaPopList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<>();
		String Message = "";
		try{
			list = wtmOrgMonthWorkStaService.getWtmOrgMonthWorkStaPopList(paramMap);
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
