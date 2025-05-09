package com.hr.cpn.payCalculate.payTransFileCre;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 은행이체자료다운 Service
 *
 * @author EW
 *
 */
@Service("PayTransFileCreService")
public class PayTransFileCreService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 은행이체자료다운 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPayTransFileCreList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getPayTransFileCreList", paramMap);
	}

	/**
	 * 은행이체자료다운상세 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPayTransFileCreListDetail(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getPayTransFileCreListDetail", paramMap);
	}

	/**
	 * 은행이체자료다운상세파일다운 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPayTransFileCreListFileDown(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getPayTransFileCreListFileDown", paramMap);
	}
}
