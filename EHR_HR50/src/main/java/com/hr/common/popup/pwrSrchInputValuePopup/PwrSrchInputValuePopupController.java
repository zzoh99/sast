package com.hr.common.popup.pwrSrchInputValuePopup;

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
 * 검색조건 항목코드 팝업
 * 
 * @author ParkMoohun
 */
@Controller
@RequestMapping(value="/PwrSrchInputValuePopup.do", method=RequestMethod.POST )
public class PwrSrchInputValuePopupController {

	@Inject
	@Named("PwrSrchInputValuePopupService")
	private PwrSrchInputValuePopupService pwrSrchInputValuePopupService;
	
	/**
	 * 검색조건 항목코드 팝업
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=pwrSrchInputValuePopup", method = RequestMethod.POST )
	public ModelAndView pwrSrchInputValuePopup(@RequestParam Map<String, Object> paramMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("common/popup/pwrSrchInputValuePopup");
		mv.addObject("adminFlag", paramMap.get("adminFlag"));
		return mv;
	}
	
	 /**
     * 검색조건 항목코드 팝업 레이어
     * 
     * @return String
     * @throws Exception
     */
    @RequestMapping(params="cmd=viewPwrSrchInputValueLayer", method = {RequestMethod.POST, RequestMethod.GET} )
    public ModelAndView pwrSrchInputValueLayer(@RequestParam Map<String, Object> paramMap) throws Exception {
        ModelAndView mv = new ModelAndView();
        mv.setViewName("common/popup/pwrSrchInputValueLayer");
        mv.addObject("adminFlag", paramMap.get("adminFlag"));
        return mv;
    }
	
	/**
	 * 검색조건 항목코드 팝업 조회
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
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));
		try{
			list = pwrSrchInputValuePopupService.getPwrSrchInputValuePopupList(paramMap);
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
	
	
	/**
	 * 검색조건 항목코드 팝업 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPwrSrchInputValueTmpList", method = RequestMethod.POST )
	public ModelAndView getPwrSrchInputValueTmpList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		List<?> list  = new ArrayList<Object>();
		String Message = "";
		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));
		
		Map<?, ?> query = pwrSrchInputValuePopupService.getTmpQueryMap(paramMap);
		//Log.Debug("+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
		//Log.Debug("query.get=> "+ query.get("query"));
		//Log.Debug("+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
		if(query != null) {
			paramMap.put("selectViewQuery",query.get("query"));
		}
		
		try{
			list = pwrSrchInputValuePopupService.getPwrSrchInputValueTmpList(paramMap);
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