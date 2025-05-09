package com.hr.tim.annual.annualPlanAgrApr;
import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;

/**
 * 경조승인 Service
 *
 * @author EW
 *
 */
@Service("AnnualPlanAgrAprService")
public class AnnualPlanAgrAprService{

	@Inject
	@Named("Dao")
	private Dao dao;
}
