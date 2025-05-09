package com.hr.tim.etc.annualYearStats;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.com.ComService;
import com.hr.common.dao.Dao;
import com.hr.common.exception.HrException;
import com.hr.common.logger.Log;
import com.hr.common.util.DateUtil;
import com.hr.common.util.ParamUtils;
/**
 * 연차사용현황 Service
 * 
 * @author 이름
 *
 */
@Service("AnnualYearStaService")  
public class AnnualYearStaService {
	@Inject
	@Named("Dao")
	private Dao dao;

	@Inject
	@Named("ComService")
	private ComService comService;
	
	/**
	 * 달력 타이틀
	 */
	public List<?> getAnnualYearStaTitleList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getAnnualYearStaTitleList", paramMap);
	}

}