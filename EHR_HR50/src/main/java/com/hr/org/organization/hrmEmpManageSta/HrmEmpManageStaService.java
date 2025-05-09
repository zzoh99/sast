package com.hr.org.organization.hrmEmpManageSta;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 사원구분별 인원현황 Service
 *
 * @author 이름
 *
 */
@Service("HrmEmpManageStaService")
public class HrmEmpManageStaService {

	@Inject
	@Named("Dao")
	private Dao dao;
	
	/**
	 * 사원구분별 인원현황 TITLE 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getHrmEmpManageStaTitleList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getHrmEmpManageStaTitleList", paramMap);
	}
	
	/**
	 * 사원구분별 인원현황 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getHrmEmpManageStaList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getHrmEmpManageStaList", paramMap);
	}
}