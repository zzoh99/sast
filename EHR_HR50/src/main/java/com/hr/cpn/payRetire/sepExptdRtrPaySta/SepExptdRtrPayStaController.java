package com.hr.cpn.payRetire.sepExptdRtrPaySta;

import com.hr.common.com.ComController;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import javax.inject.Inject;
import javax.inject.Named;

/**
 * 예상퇴직금 Controller
 *
 * @author JM
 *
 */
@Controller
@RequestMapping(value="/SepExptdRtrPaySta.do", method= RequestMethod.POST )
public class SepExptdRtrPayStaController extends ComController {

	/**
	 * 예상퇴직금 서비스
	 */
	@Inject
	@Named("SepExptdRtrPayStaService")
	private SepExptdRtrPayStaService sepExptdRtrPayStaService;

	/**
	 * 예상퇴직금 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewSepExptdRtrPaySta", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewSepExptdRtrPaySta() throws Exception {
		return "cpn/payRetire/sepExptdRtrPaySta/sepExptdRtrPaySta";
	}
}