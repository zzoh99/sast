package com.hr.hrm.other.empCardPrt2;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 인사카드출력 Service
 *
 * @author bckim
 *
 */
@Service("EmpCardPrt2Service")
public class EmpCardPrt2Service{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 인사카드출력 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getEmpCardPrt2AuthList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getEmpCardPrt2AuthList", paramMap);
	}
	
	/**
	 * getEmpCardPrt2List 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getEmpCardPrt2List(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getEmpCardPrt2List", paramMap);
	}
}