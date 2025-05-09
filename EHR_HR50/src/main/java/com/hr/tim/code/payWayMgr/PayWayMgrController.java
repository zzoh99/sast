package com.hr.tim.code.payWayMgr;
import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod; 
/**
 * 근무지급방법설정(탭메인) Controller
 *
 * @author bckim
 *
 */
@Controller
@RequestMapping(value="/PayWayMgr.do", method=RequestMethod.POST )
public class PayWayMgrController {

	/**
	 * 근무지급방법설정(탭메인) 서비스
	 */
	@Inject
	@Named("PayWayMgrService")
	private PayWayMgrService payWayMgrService;

	/**
	 * 근무지급방법설정(탭메인) View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewPayWayMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewPayWayMgr() throws Exception {
		return "tim/code/payWayMgr/payWayMgr";
	}
}
