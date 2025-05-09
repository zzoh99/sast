package com.hr.cpn.personalPay.perPayYearLst;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 연봉관리 Service
 *
 * @author JSG
 *
 */
@Service("PerPayYearLstService")
public class PerPayYearLstService{
	@Inject
	@Named("Dao")
	private Dao dao;
	/**
	 * 연봉관리 title 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPerPayYearLstEleList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getPerPayYearLstEleList", paramMap);
	}
	
	/**
	 * 연봉관리 title 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPerPayYearLstList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getPerPayYearLstList", paramMap);
	}
	

}