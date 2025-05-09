package com.hr.pap.config.appGradeSeqCd6;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 배분결과(2차) Service
 *
 * @author EW
 *
 */
@Service("AppGradeSeqCd6Service")
public class AppGradeSeqCd6Service{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 배분결과(2차) 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getAppGradeSeqCd6List(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getAppGradeSeqCd6List", paramMap);
	}

}
