package com.hr.tim.annual.annualPlanAgrStd;
import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
/**
 * 경조기준관리 Service
 * 
 * @author 이름
 *
 */
@Service("AnnualPlanAgrStdService")  
public class AnnualPlanAgrStdService{
	@Inject
	@Named("Dao")
	private Dao dao;
}