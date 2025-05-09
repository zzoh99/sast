package com.hr.hrm.hrmComPopup.appmtConfirmPopup;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod; 
/**
 * 품의서 팝업 Controller
 *
 * @author bckim
 *
 */
@Controller
@RequestMapping(value="/AppmtConfirmPopup.do", method=RequestMethod.POST )
public class AppmtConfirmPopupController {

	/**
	 * 품의서 팝업 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewAppmtConfirmPopup", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewAppmtConfirmPopup() throws Exception {
		return "hrm/hrmComPopup/appmtConfirmPopup/appmtConfirmPopup";
	}
}
