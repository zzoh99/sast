package com.hr.common.popup.rdPopup;
import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import java.util.HashMap;
import java.util.Map;


/**
 * MRD 공통팝업 Controller
 * by JSG
 * @author JSG
 *
 */
@Controller

public class RdPopupController {

	/**
	 * RD 공통팝업 서비스
	 */
	@Inject
	@Named("RdPopupService")
	private RdPopupService rdPopupService;

	/**
	 * RD팝업 View
	 *
	 * @return String
	 * @throws Exception
	 */
	//@RequestMapping(params="cmd=viewRdPopup", method = {RequestMethod.POST, RequestMethod.GET} )
	@RequestMapping(value="/RdPopup.do", method=RequestMethod.POST )
	public String viewRdPopup() throws Exception {
		return "common/popup/rdPopup";
	}
	
	@RequestMapping(value="/viewRdSignLayer.do", method=RequestMethod.POST )
	public String viewRdSignLayer() throws Exception {
		return "common/popup/rdSignLayer";
	}

	/**
	 * RD iframe view
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(value="/RdIframe.do", method=RequestMethod.POST )
	public ModelAndView viewIframeRd(HttpSession session,
										@RequestParam Map<String, Object> paramMap,
										HttpServletRequest request) throws Exception {
		Map<String, Object> rdParam = new HashMap<>();

		if(paramMap.containsKey("path") && paramMap.containsKey("encryptParameter")) {
			rdParam.put("c", "Y");
			rdParam.put("p", paramMap.get("path"));
			rdParam.put("d", paramMap.get("encryptParameter"));
		} else {
			rdParam.put("c", "N");
		}

		ModelAndView mv = new ModelAndView();
		mv.setViewName("common/popup/rdPopupIframe");
		mv.addObject("rdParam", rdParam);
		return mv;
	}

	//@RequestMapping(params="cmd=viewRdPopup", method = {RequestMethod.POST, RequestMethod.GET} )
	@RequestMapping(value="/RdUpload2.do", method=RequestMethod.POST )
	public String viewRdUpload2() throws Exception {
		return "common/popup/rdUpload2";
	}
	

	//@RequestMapping(params="cmd=viewRdPopup", method = {RequestMethod.POST, RequestMethod.GET} )
	@RequestMapping(value="/RdUpload3.do", method=RequestMethod.POST )
	public String viewRdUpload3() throws Exception {
		return "common/popup/rdUpload3";
	}
	
	//@RequestMapping(params="cmd=viewRdPopup", method = {RequestMethod.POST, RequestMethod.GET} )
	@RequestMapping(value="/RdUpload4.do", method=RequestMethod.POST )
	public String viewRdUpload4() throws Exception {
		return "common/popup/rdUpload4";
	}	
}
