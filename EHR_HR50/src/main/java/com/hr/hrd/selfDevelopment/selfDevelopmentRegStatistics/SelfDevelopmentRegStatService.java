package com.hr.hrd.selfDevelopment.selfDevelopmentRegStatistics;

import com.hr.common.dao.Dao;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import javax.inject.Named;
import java.util.List;
import java.util.Map;

@Service("SelfDevelopmentRegStatService")
public class SelfDevelopmentRegStatService {
	@Inject
	@Named("Dao")
	private Dao dao;

	public List<?> getSelfDevelopmentRegStat(Map<?, ?> paramMap) throws Exception {
		return (List<?>) dao.getList("getSelfDevelopmentRegStat", paramMap);
	}



}
