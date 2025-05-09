package com.hr.tim.annual.annualPlanAgrMgr;
import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
/**
 * 연차촉진 관리 Service
 * 
 * @author 이름
 *
 */
@Service("AnnualPlanAgrMgrService")  
public class AnnualPlanAgrMgrService{
	@Inject
	@Named("Dao")
	private Dao dao;
}