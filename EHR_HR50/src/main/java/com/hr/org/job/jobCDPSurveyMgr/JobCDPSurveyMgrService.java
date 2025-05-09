package com.hr.org.job.jobCDPSurveyMgr;
import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
/**
 * 희망직무현황 Service
 *
 * @author jy
 *
 */
@Service("JobCDPSurveyMgrService")
public class JobCDPSurveyMgrService{
	@Inject
	@Named("Dao")
	private Dao dao;
	
}