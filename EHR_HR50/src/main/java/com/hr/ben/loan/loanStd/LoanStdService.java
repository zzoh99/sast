package com.hr.ben.loan.loanStd;

import com.hr.common.dao.Dao;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import javax.inject.Named;

/**
 * 대출기준관리 Service
 *
 * @author
 *
 */
@Service("LoanStdService")
public class LoanStdService{

	@Inject
	@Named("Dao")
	private Dao dao;

}