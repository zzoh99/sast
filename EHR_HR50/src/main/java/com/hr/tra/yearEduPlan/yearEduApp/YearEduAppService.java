package com.hr.tra.yearEduPlan.yearEduApp;

import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 연간교육계획작성 Service
 *
 */
@Service("YearEduAppService")
public class YearEduAppService{

	@Inject
	@Named("Dao")
	private Dao dao;
	
	public int saveYearEduApp(Map<?, ?> paramMap, Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		
		int cnt=0;
		
		dao.delete("deleteYearEduApp", paramMap);
		cnt = dao.update("saveYearEduApp", convertMap);

		return cnt;
	}

}
