package com.hr.tim.request.bizTripExpenApr;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;

/**
 * 출장보고서 승인 Service
 *
 * @author EW
 *
 */
@Service("BizTripExpenAprService")
public class BizTripExpenAprService{

	@Inject
	@Named("Dao")
	private Dao dao;


}
