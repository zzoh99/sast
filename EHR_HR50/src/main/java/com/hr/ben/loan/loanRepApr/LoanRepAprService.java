package com.hr.ben.loan.loanRepApr;

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
@Service("LoanRepAprService")
public class LoanRepAprService{
	@Inject
	@Named("Dao")
	private Dao dao;
}