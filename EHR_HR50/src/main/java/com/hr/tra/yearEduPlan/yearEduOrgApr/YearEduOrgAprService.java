package com.hr.tra.yearEduPlan.yearEduOrgApr;

import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 연간교육계획 승인 Service
 */
@Service("YearEduOrgAprService")
public class YearEduOrgAprService{

	@Inject
	@Named("Dao")
	private Dao dao;

}
