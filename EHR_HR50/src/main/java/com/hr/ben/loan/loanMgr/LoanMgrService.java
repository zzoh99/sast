package com.hr.ben.loan.loanMgr;

import com.hr.common.dao.Dao;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import javax.inject.Named;

/**
 * 대출마감관리 Service
 *
 * @author JM
 *
 */
@Service("LoanMgrService")
public class LoanMgrService{
	@Inject
	@Named("Dao")
	private Dao dao;

}