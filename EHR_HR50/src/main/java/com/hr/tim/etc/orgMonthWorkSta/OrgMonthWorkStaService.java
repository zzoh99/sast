package com.hr.tim.etc.orgMonthWorkSta;
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
 * 부서별월근태현황 Service
 * 
 * @author 이름
 *
 */
@Service("OrgMonthWorkStaService")  
public class OrgMonthWorkStaService {
	@Inject
	@Named("Dao")
	private Dao dao;

	@Inject
	@Named("ComService")
	private ComService comService;
	
	/**
	 * 부서별월근태현황 Title 조회
	 */
	public List<?> getOrgMonthWorkStaTitleList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getOrgMonthWorkStaTitleList", paramMap);
	}

	/**
	 * 부서별월근태현황 다건 조회
	 */
	public List<?> getOrgMonthWorkStaList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getOrgMonthWorkStaList", paramMap);
	}

	/**
	 * 조직콤보 조회
	 */
	public List<?> getOrgMonthWorkStaOrgList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getOrgMonthWorkStaOrgList", paramMap);
	}

	/**
	 * 부서별월근태현황 팝업 조회
	 */
	public List<?> getOrgMonthWorkStaPopList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getOrgMonthWorkStaPopList", paramMap);
	}
}