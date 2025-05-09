package com.hr.tra.outcome.required.requiredPromSta;
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
 * 승격대상자 필수교육이수현황 Service
 * 
 * @author 이름
 *
 */
@Service("RequiredPromStaService")  
public class RequiredPromStaService {
	@Inject
	@Named("Dao")
	private Dao dao;
	
}