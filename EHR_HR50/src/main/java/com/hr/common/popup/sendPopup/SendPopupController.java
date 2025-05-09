package com.hr.common.popup.sendPopup;

import java.util.HashMap;
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

import com.hr.common.other.OtherService;

@Controller
@RequestMapping(value="/SendPopup.do", method=RequestMethod.POST )
public class SendPopupController {
	
	@Inject
	@Named("OtherService")
	private OtherService otherService;
	
	
	/**
	 * 메일발송 popup 
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewMailMgrPopup", method = {RequestMethod.POST, RequestMethod.GET} )
	public ModelAndView mailMgrPopup(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		//Map<?, ?> map = recNoticeMgrService.getRecNoticeMgrMap(paramMap);
		ModelAndView mv = new ModelAndView();
		Map<String, Object> editorMap = new HashMap<String, Object>();
		
		editorMap.put("formNm", "dataForm");
		editorMap.put("contentNm", "mailContent");
		editorMap.put("minusHeight", 400);
		
		mv.addObject("editor", editorMap);
		//mv.addObject("map", map);
		mv.setViewName("common/popup/mailMgrPopup");
		return mv;
	}
	
	   /**
     * 메일발송 popup 
     * 
     * @return String
     * @throws Exception
     */
    @RequestMapping(params="cmd=viewMailMgrLayer", method = {RequestMethod.POST, RequestMethod.GET} )
    public ModelAndView mailMgrLayer(
            HttpSession session,  HttpServletRequest request, 
            @RequestParam Map<String, Object> paramMap ) throws Exception {
        //Map<?, ?> map = recNoticeMgrService.getRecNoticeMgrMap(paramMap);
        ModelAndView mv = new ModelAndView();
        Map<String, Object> editorMap = new HashMap<String, Object>();
        
        editorMap.put("formNm", "dataForm");
        editorMap.put("contentNm", "mailContent");
        editorMap.put("minusHeight", 400);
        
        mv.addObject("editor", editorMap);
        //mv.addObject("map", map);
        mv.setViewName("common/popup/mailMgrLayer");
        return mv;
    }
    
	
	/**
	 * SMS발송 popup 
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=smsMgrPopup", method = RequestMethod.POST )
	public String smsMgrPopup() throws Exception {
		return "common/popup/smsMgrPopup";
	}
	
	   
    /**
     * SMS발송 Layer
     * 
     * @return String
     * @throws Exception
     */
    @RequestMapping(params="cmd=viewSmsMgrLayer", method = {RequestMethod.POST, RequestMethod.GET} )
    public String smsMgrLayer() throws Exception {
        return "common/popup/smsMgrLayer";
    }
}