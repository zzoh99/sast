package com.hr.ben.loan.loanAppDet;

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
@Service("LoanAppDetService")
public class LoanAppDetService{

	@Inject
	@Named("Dao")
	private Dao dao;


}