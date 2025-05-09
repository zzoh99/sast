package com.hr.org.job.orgKnowledgeMgr;
import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.hr.common.com.ComController;
import com.hr.org.job.orgKnowledgeReg.OrgKnowledgeRegService;
import org.springframework.web.bind.annotation.RequestMethod;

/**
 * 조직의지식조회 Controller
 *
 * @author jy
 *
 */
@Controller
@RequestMapping(value="/OrgKnowledgeMgr.do", method= RequestMethod.POST )
public class OrgKnowledgeMgrController extends ComController {
	
	/**
	 * 조직의지식조회 서비스
	 */
	@Inject
	@Named("OrgKnowledgeRegService")
	private OrgKnowledgeRegService orgKnowledgeRegService;
	
	/**
	 * 조직의지식조회 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewOrgKnowledgeMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewOrgKnowledgeMgr() throws Exception {
		return "org/job/orgKnowledgeMgr/orgKnowledgeMgr";
	}

}
