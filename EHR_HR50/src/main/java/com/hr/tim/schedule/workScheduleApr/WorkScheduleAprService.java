package com.hr.tim.schedule.workScheduleApr;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 근무스케쥴승인 Service
 *
 * @author EW
 *
 */
@Service("WorkScheduleAprService")
public class WorkScheduleAprService{

	@Inject
	@Named("Dao")
	private Dao dao;
}