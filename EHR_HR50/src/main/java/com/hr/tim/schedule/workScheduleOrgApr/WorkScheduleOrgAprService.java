package com.hr.tim.schedule.workScheduleOrgApr;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 부서근무스케쥴승인 Service
 *
 * @author EW
 *
 */
@Service("WorkScheduleOrgAprService")
public class WorkScheduleOrgAprService{

	@Inject
	@Named("Dao")
	private Dao dao;

}
