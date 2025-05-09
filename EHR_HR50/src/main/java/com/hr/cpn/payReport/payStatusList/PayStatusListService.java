package com.hr.cpn.payReport.payStatusList;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 연봉현황리스트 Service
 *
 * @author
 *
 */
@Service("PayStatusListService")
public class PayStatusListService{
	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 연봉현황리스트 title 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPayStatusListTitleList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return (List<?>) dao.getList("getPayStatusListTitleList", paramMap);
	}

	/**
	 * 연봉현황리스트 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPayStatusListList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return (List<?>) dao.getList("getPayStatusListList", paramMap);
	}

	/**
	 * 연봉현황리스트 급여구분 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPayStatusListCpnPayCdList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return (List<?>) dao.getList("getPayStatusListCpnPayCdList", paramMap);
	}
}