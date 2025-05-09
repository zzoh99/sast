package com.hr.tra.yearEduPlan.yearEduOrgAppDet;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;

/**
 * 연간교육계획신청 신청 Service
 */
@Service("YearEduOrgAppDetService")
public class YearEduOrgAppDetService{

	@Inject
	@Named("Dao")
	private Dao dao;
	
}