package com.hr.hrd.selfRating.selfRatingStatistics;

import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

@Service("SelfRatingStatisticsRegistService")
public class SelfRatingStatisticsRegistService {
	@Inject
	@Named("Dao")
	private Dao dao;

	public List<?> getSelfRatingStatisticsRegistList(Map<?, ?> paramMap) throws Exception {
		return (List<?>) dao.getList("getSelfRatingStatisticsRegistList", paramMap);
	}

}
