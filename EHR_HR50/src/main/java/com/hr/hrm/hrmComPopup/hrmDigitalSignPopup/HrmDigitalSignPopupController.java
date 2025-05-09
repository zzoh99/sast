package com.hr.hrm.hrmComPopup.hrmDigitalSignPopup;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod; 
/**
 * 전자서명양식검색 팝업 Controller
 *
 * @author bckim
 *
 */
@Controller
@RequestMapping(value="/HrmDigitalSignPopup.do", method=RequestMethod.POST )
public class HrmDigitalSignPopupController {

	/**
	 * 전자서명양식검색 팝업 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewHrmDigitalSignPopup", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewHrmDigitalSignPopup() throws Exception {
		return "hrm/hrmComPopup/hrmDigitalSignPopup/hrmDigitalSignPopup";
	}
}
