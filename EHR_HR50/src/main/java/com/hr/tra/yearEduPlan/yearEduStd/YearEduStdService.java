package com.hr.tra.yearEduPlan.yearEduStd;

import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 연간교육계획기준관리 Service
 */
@Service("YearEduStdService")
public class YearEduStdService{

	@Inject
	@Named("Dao")
	private Dao dao;

}
