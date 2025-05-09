package com.hr.api.m.tim.stats;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import javax.inject.Named;
import java.util.List;
import java.util.Map;

@Service("ApiEmpInOutService")
public class ApiEmpInOutService {

	@Inject
    @Named("Dao")
    private Dao dao;
	
	/**
	 * getEmpInOutList 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getEmpInOutList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getEmpInOutList", paramMap);
	}
	
	/**
	 * 부서원근태현황 헤더 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getEmpInOutHeaderList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getEmpInOutHeaderList", paramMap);
	}
}
