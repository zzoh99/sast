package com.hr.hrm.empPap.empPapHistMgr;
import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;

/**
 * JobKnowledgePopup Service
 *
 * @author jy
 *
 */
@Service("EmpPapHistMgrService")
public class EmpPapHistMgrService{

	@Inject
	@Named("Dao")
	private Dao dao;
	
}
