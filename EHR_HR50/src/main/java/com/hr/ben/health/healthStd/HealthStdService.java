package com.hr.ben.health.healthStd;

import com.hr.common.dao.Dao;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import javax.inject.Named;

/**
 * 건강검진기준관리 Service
 *
 * @author JY
 *
 */
@Service("HealthStdService")
public class HealthStdService{

	@Inject
	@Named("Dao")
	private Dao dao;
}
