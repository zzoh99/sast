package com.hr.hrm.other.jobStateChart;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;

/**
 * 통계 조회 Service
 * @author gjyoo
 *
 */
@Service("JobStateChartService")
public class JobStateChartService {
	@Inject
	@Named("Dao")
	private Dao dao;

}
