package com.hr.cpn.payRetroact.retroCalcWorkSta;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 소급작업결과조회 Service
 *
 * @author JM
 *
 */
@Service("RetroCalcWorkStaService")
public class RetroCalcWorkStaService{
	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 소급작업결과조회 급여구분별 항목리스트 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getRetroCalcWorkStaTitleList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return (List<?>) dao.getList("getRetroCalcWorkStaTitleList", paramMap);
	}

	/**
	 * 소급작업결과조회 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getRetroCalcWorkStaList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return (List<?>) dao.getList("getRetroCalcWorkStaList", paramMap);
	}
}