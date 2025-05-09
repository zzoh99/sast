package com.hr.common.popup.payUdfMasterPopup;

import java.util.ArrayList;
import java.util.HashMap;
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
import com.hr.common.util.ParamUtils;

/**
 * 공통 팝업
 * @author ParkMoohun
 */
@Controller
@RequestMapping(value="/PayUdfMasterPopup.do", method=RequestMethod.POST )
public class PayUdfMasterPopupController {

	@Inject
	@Named("PayUdfMasterPopupService")
	private PayUdfMasterPopupService payUdfMasterPopupService;
	
	/**
	 * 급여항목명
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=payUdfMasterPopup", method = RequestMethod.POST )
	public String payUdfMasterPopup() throws Exception {
		return "common/popup/payUdfMasterPopup";
	}
	@RequestMapping(params="cmd=viewPayUdfMasterLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public String payUdfMasterLayer() throws Exception {
		return "common/popup/payUdfMasterLayer";
	}
	
	/**
	 * 급여항목명
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPayUdfMasterList", method = RequestMethod.POST )
	public ModelAndView getPayUdfMasterList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		List<?> list  = new ArrayList<Object>();
		String Message = "";
		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		
		try{
			list = payUdfMasterPopupService.getPayUdfMasterList(paramMap);
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