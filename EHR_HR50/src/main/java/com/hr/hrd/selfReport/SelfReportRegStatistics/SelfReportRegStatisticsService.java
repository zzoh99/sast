package com.hr.hrd.selfReport.SelfReportRegStatistics;

import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

@Service("SelfReportRegStatisticsService")
public class SelfReportRegStatisticsService {
	@Inject
	@Named("Dao")
	private Dao dao;

	public List<?> getSelfReportRegStatisticsList(Map<?, ?> paramMap) throws Exception {
		return (List<?>) dao.getList("getSelfReportRegStatisticsList", paramMap);
	}

}
