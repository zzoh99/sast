package com.hr.wtm.stats.wtmOrgMonthWorkSta;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import javax.inject.Named;
import java.util.List;
import java.util.Map;

/**
 * 부서별월근태현황 Service
 * 
 * @author 이름
 *
 */
@Service("WtmOrgMonthWorkStaService")
public class WtmOrgMonthWorkStaService {
	@Inject
	@Named("Dao")
	private Dao dao;
	
	/**
	 * 부서별월근태현황 Title 조회
	 */

	public List<?> getWtmOrgMonthWorkStaTitleList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getWtmOrgMonthWorkStaTitleList", paramMap);
	}

	/**
	 * 부서별월근태현황 다건 조회
	 */
	public List<?> getWtmOrgMonthWorkStaList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getWtmOrgMonthWorkStaList", paramMap);
	}

	/**
	 * 조직콤보 조회
	 */
	public List<?> getWtmOrgMonthWorkStaOrgList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getWtmOrgMonthWorkStaOrgList", paramMap);
	}

	/**
	 * 부서별월근태현황 팝업 조회
	 */
	public List<?> getWtmOrgMonthWorkStaPopList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getWtmOrgMonthWorkStaPopList", paramMap);
	}
}