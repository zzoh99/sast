package com.hr.ben.health.healthMgr;

import com.hr.common.dao.Dao;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import javax.inject.Named;

/**
 * 건강검진대상자관리 Service
 *
 * @author JY
 *
 */
@Service("HealthMgrService")
public class HealthMgrService{

	@Inject
	@Named("Dao")
	private Dao dao;
	
}
