package com.hr.pap.config.appGradeKpiRateMgr;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 평가등급/조직별인원배분 Service
 *
 * @author jcy
 *
 */
@Service("AppGradeKpiRateMgrService")
public class AppGradeKpiRateMgrService{
	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 평가등급/조직별인원배분 조직코드 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws  Exception
	 */
	public List<?> getAppGradeKpiRateMgrGrpIdList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getAppGradeKpiRateMgrGrpIdList", paramMap);
	}

}