package com.hr.org.organization.orgSchemeIBOrgSrchO;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.hr.common.code.CommonCodeService;
import com.hr.org.organization.orgSchemeIBOrgSrch.OrgSchemeIBOrgSrchService;
import org.springframework.web.bind.annotation.RequestMethod;

/**
 * 화상조직도
 *
 * @author ParkMoohun
 */
@Controller
@RequestMapping(value="/OrgSchemeIBOrgSrchO.do", method= RequestMethod.POST )
public class OrgSchemeIBOrgSrchOController{

	@Inject
	@Named("OrgSchemeIBOrgSrchService")
	private OrgSchemeIBOrgSrchService orgSchemeIBOrgSrchService;

	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;

	/**
	 * orgSchemeIBOrgSrch View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewOrgSchemeIBOrgSrchO", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewOrgSchemeIBOrgSrchO() throws Exception {
		return "org/organization/orgSchemeIBOrgSrchO/orgSchemeIBOrgSrchO";
	}

}