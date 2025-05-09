package com.hr.org.organization.hrmEmpJikgubSta;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 직급별 인원현황 Service
 *
 * @author 이름
 *
 */
@Service("HrmEmpJikgubStaService")
public class HrmEmpJikgubStaService {

	@Inject
	@Named("Dao")
	private Dao dao;
	
	/**
	 * 직급별 인원현황 TITLE 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getHrmEmpJikgubStaTitleList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getHrmEmpJikgubStaTitleList", paramMap);
	}
	
	/**
	 * 직급별 인원현황 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getHrmEmpJikgubStaList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getHrmEmpJikgubStaList", paramMap);
	}
}