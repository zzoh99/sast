package com.hr.hrd.selfRating.selfRatingStatistics;

import com.hr.common.dao.Dao;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import javax.inject.Named;
import java.util.List;
import java.util.Map;

@Service("SelfRatingStatisticsRatingService")
public class SelfRatingStatisticsRatingService {
	@Inject
	@Named("Dao")
	private Dao dao;

	public List<?> getSelfRatingStatisticsRatingList(Map<?, ?> paramMap) throws Exception {
		return (List<?>) dao.getList("getSelfRatingStatisticsRatingList", paramMap);
	}

}
