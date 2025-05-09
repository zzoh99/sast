package com.hr.tim.annual.annualPlanCalendar;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 조직원연차계획현황 Service
 *
 * @author EW
 *
 */
@Service("AnnualPlanCalendarService")
public class AnnualPlanCalendarService{

	@Inject
	@Named("Dao")
	private Dao dao;
}
