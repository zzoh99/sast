package com.hr.hrd.statistics.workSatisfactionPositionStatistics;

import com.hr.common.dao.Dao;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import javax.inject.Named;
import java.util.List;
import java.util.Map;

@Service("WorkSatisfactionPositionStatisticsService")
public class WorkSatisfactionPositionStatisticsService {
	@Inject
	@Named("Dao")
	private Dao dao;

	public List<?> getWorkSatisfactionPositionStatisticsItem(Map<?, ?> paramMap) throws Exception {
		return (List<?>) dao.getList("getWorkSatisfactionPositionStatisticsItem", paramMap);
	}

	public List<?> getWorkSatisfactionPositionStatisticsSurveyItemList(Map<?, ?> paramMap) throws Exception {
		return (List<?>) dao.getList("getWorkSatisfactionPositionStatisticsSurveyItemList", paramMap);
	}

	public Map<?,?> getWorkSatisfactionPositionStatisticsSurveyItemStr(Map<?, ?> paramMap) throws Exception {
		return (Map<?,?>) dao.getMap("getWorkSatisfactionPositionStatisticsSurveyItemStr", paramMap);
	}

	public List<?> getWorkSatisfactionPositionStatisticsList(Map<?, ?> paramMap) throws Exception {
		return (List<?>) dao.getList("getWorkSatisfactionPositionStatisticsList", paramMap);
	}
}
