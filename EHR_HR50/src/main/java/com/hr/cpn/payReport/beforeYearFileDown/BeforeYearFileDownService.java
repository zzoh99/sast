package com.hr.cpn.payReport.beforeYearFileDown;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 원천징수영수증파일다운 Service
 *
 * @author EW
 *
 */
@Service("BeforeYearFileDownService")
public class BeforeYearFileDownService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 원천징수영수증파일다운 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getBeforeYearFileDownList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getBeforeYearFileDownList", paramMap);
	}

}
