package com.hr.wtm.stats.wtmPsnlWeekWorkSta;

import com.hr.common.com.ComService;
import com.hr.common.dao.Dao;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import javax.inject.Named;

/**
 * 개인별주근무현황 Service
 * 
 * @author 이름
 *
 */
@Service("WtmPsnlWeekWorkStaService")
public class WtmPsnlWeekWorkStaService {
	@Inject
	@Named("Dao")
	private Dao dao;

	@Inject
	@Named("ComService")
	private ComService comService;

}