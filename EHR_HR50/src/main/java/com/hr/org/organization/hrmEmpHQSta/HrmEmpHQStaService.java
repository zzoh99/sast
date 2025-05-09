package com.hr.org.organization.hrmEmpHQSta;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 본부별 인원현황 Service
 *
 * @author 이름
 *
 */
@Service("HrmEmpHQStaService")
public class HrmEmpHQStaService {

	@Inject
	@Named("Dao")
	private Dao dao;
	
	/**
	 * 본부별 인원현황 TITLE 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getHrmEmpHQStaTitleList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getHrmEmpHQStaTitleList", paramMap);
	}
	
	/**
	 * 본부별 인원현황 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getHrmEmpHQStaList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getHrmEmpHQStaList", paramMap);
	}
}