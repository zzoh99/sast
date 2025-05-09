package com.hr.hrd.selfDevelopment.selfDevelopmentAdminStat;

import com.hr.common.dao.Dao;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import javax.inject.Named;
import java.util.List;
import java.util.Map;

@Service("SelfDevelopmentAdminStatService")
public class SelfDevelopmentAdminStatService {
	@Inject
	@Named("Dao")
	private Dao dao;

	public List<?> getSelfDevelopmentAdminStat(Map<?, ?> paramMap) throws Exception {
		return (List<?>) dao.getList("getSelfDevelopmentAdminStat", paramMap);
	}



}
