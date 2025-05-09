package com.hr.common.popup.pwrSrchElemPopup;

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
 * 조건건색 코드항목 조회 Popup
 * 
 * @author ParkMoohun
 * 
 */
@Controller
@RequestMapping(value="/PwrSrchElemPopup.do", method=RequestMethod.POST )
public class PwrSrchElemPopupController {

	@Inject
	@Named("PwrSrchElemPopupService")
	private PwrSrchElemPopupService PwrSrchElemPopupService;

	/**
	 * 조건건색 코드항목 조회 Popup 화면
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=pwrSrchElemPopup", method = RequestMethod.POST )
	public String viewPwrSrchElemPopup(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.Debug("PwrSrchElemPopupController.pwrSrchElemPopup");
		return "common/popup/pwrSrchElemPopup";
	}

	@RequestMapping(params="cmd=pwrSrchElemLayer", method = RequestMethod.POST )
	public String viewPwrSrchElemLayer(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.Debug("PwrSrchElemPopupController.pwrSrchElemLayer");
		return "common/popup/pwrSrchElemLayer";
	}

	/**
	 * 조건건색 코드항목 조회 Popup 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPwrSrchElemPopupList", method = RequestMethod.POST )
	public ModelAndView getPwrSrchElemPopupList(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		List<?> list  = new ArrayList<Object>();
		String Message = "";
		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));
		try{
			list = PwrSrchElemPopupService.getPwrSrchElemPopupList(paramMap);
		}catch(Exception e){
			Message="조회에 실패하였습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("data", list);
		mv.addObject("Message", Message);
		
		Log.DebugEnd();
		return mv;
	}
}
