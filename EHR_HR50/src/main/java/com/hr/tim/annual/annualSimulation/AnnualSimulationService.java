package com.hr.tim.annual.annualSimulation;

import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

import signgate.provider.ec.arithmetic.curves.exceptions.ECException;

@Service("AnnualSimulationService")
public class AnnualSimulationService {
	
	@Inject
	@Named("Dao")
	private Dao dao;

	public List<?> getAnnualSimulationList(Map<String, Object> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getAnnualHolidayList", paramMap);
	}
	
	

}
