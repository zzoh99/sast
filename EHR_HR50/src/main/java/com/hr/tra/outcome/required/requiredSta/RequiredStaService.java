package com.hr.tra.outcome.required.requiredSta;
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
 * 필수교육이수현황 Service
 * 
 * @author 이름
 *
 */
@Service("RequiredStaService")  
public class RequiredStaService {
	@Inject
	@Named("Dao")
	private Dao dao;

	@Inject
	@Named("ComService")
	private ComService comService;
	
	/**
	 * 달력 타이틀
	 */
	public List<?> getRequiredStaTitleList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getRequiredStaTitleList", paramMap);
	}

}