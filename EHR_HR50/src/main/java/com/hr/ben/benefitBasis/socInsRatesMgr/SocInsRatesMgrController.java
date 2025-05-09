package com.hr.ben.benefitBasis.socInsRatesMgr;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
 /* 통합취득신고 Controller
 *
 * @author LDH
 *
 */
@Controller
@RequestMapping(value="/SocInsRatesMgr.do", method=RequestMethod.POST )
public class SocInsRatesMgrController {

	/**
	 * 기본사항  View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewSocInsRatesMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewSocInsRatesMgr() throws Exception {
		return "ben/benefitBasis/socInsMultiMgr/socInsRatesMgr";
	}
}