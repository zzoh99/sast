package com.hr.ben.loan.loanRepAppDet;

import com.hr.common.dao.Dao;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import javax.inject.Named;

/**
 * 대출금 세부내역 Service
 *
 * @author bckim
 *
 */
@Service("LoanRepAppDetService")
public class LoanRepAppDetService{

	@Inject
	@Named("Dao")
	private Dao dao;


}