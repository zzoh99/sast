package com.hr.tim.etc.psnlWeekWorkSta;
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
 * 개인별주근무현황 Service
 * 
 * @author 이름
 *
 */
@Service("PsnlWeekWorkStaService")  
public class PsnlWeekWorkStaService {
	@Inject
	@Named("Dao")
	private Dao dao;

	@Inject
	@Named("ComService")
	private ComService comService;

}