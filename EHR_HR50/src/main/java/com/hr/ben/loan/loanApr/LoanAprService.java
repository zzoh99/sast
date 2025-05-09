package com.hr.ben.loan.loanApr;

import com.hr.common.dao.Dao;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import javax.inject.Named;
/**
 * 대출승인관리 Service
 *
 * @author 이름
 *
 */
@Service("LoanAprService")
public class LoanAprService{
	@Inject
	@Named("Dao")
	private Dao dao;
}