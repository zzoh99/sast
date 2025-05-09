package com.hr.hrm.hrmComPopup.hrmAcaMajPopup;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod; 
/**
 * 전공 팝업 Controller
 *
 * @author bckim
 *
 */
@Controller
@RequestMapping(value="/HrmAcaMajPopup.do", method=RequestMethod.POST )
public class HrmAcaMajPopupController {

	/**
	 * 전공 팝업 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewHrmAcaMajPopup", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewHrmAcaMajPopup() throws Exception {
		return "hrm/hrmComPopup/hrmAcaMajPopup/hrmAcaMajPopup";
	}

}
