package com.hr.hrd.statistics.careerPathWorkAssignStat;

import com.hr.common.dao.Dao;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import javax.inject.Named;
import java.util.List;
import java.util.Map;

@Service("CareerPathWorkAssignStatService")
public class CareerPathWorkAssignStatService {
	@Inject
	@Named("Dao")
	private Dao dao;

	public List<?> getCareerPathWorkAssignStat(Map<?, ?> paramMap) throws Exception {
		return (List<?>) dao.getList("getCareerPathWorkAssignStat", paramMap);
	}

}
