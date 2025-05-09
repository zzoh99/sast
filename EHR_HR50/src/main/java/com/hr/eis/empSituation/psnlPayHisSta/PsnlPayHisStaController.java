package com.hr.eis.empSituation.psnlPayHisSta;
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

import com.hr.common.logger.Log;
/**
 *  Controller 
 * 
 * @author JSG
 *
 */
@Controller
@RequestMapping(value="/PsnlPayHisSta.do", method=RequestMethod.POST )
public class PsnlPayHisStaController {

	@Inject
	@Named("PsnlPayHisStaService")
	private PsnlPayHisStaService psnlPayHisStaService;
	
	/**
	 * viewPsnlPayHisSta View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewPsnlPayHisSta", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewPsnlPayHisSta() throws Exception {
		return "eis/empSituation/psnlPayHisSta/psnlPayHisSta";
	}
	
	/**
	 * 3123123 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPsnlPayHisStaList", method = RequestMethod.POST )
	public ModelAndView getPsnlPayHisStaList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = psnlPayHisStaService.getPsnlPayHisStaList(paramMap);
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
	 * getPsnlPayHisStaPopupList 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPsnlPayHisStaPopupList", method = RequestMethod.POST )
	public ModelAndView getPsnlPayHisStaPopupList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		
		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = psnlPayHisStaService.getPsnlPayHisStaPopupList(paramMap);
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
	
	@RequestMapping(params="cmd=viewPsnlPayHisStaPopup", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewPsnlPayHisStaPopup(HttpSession session,
			@RequestParam Map<String, Object> paramMap,
			HttpServletRequest request) throws Exception {
		Log.Debug("PsnlPayHisStaController.psnlPayHisStaPopup");
		return "eis/empSituation/psnlPayHisSta/psnlPayHisStaPopup";
	}
	
}
