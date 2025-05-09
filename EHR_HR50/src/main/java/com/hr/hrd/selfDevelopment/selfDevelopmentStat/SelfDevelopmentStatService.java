package com.hr.hrd.selfDevelopment.selfDevelopmentStat;

import com.hr.common.dao.Dao;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import javax.inject.Named;
import java.util.List;
import java.util.Map;

@Service("SelfDevelopmentStatService")
public class SelfDevelopmentStatService {
	@Inject
	@Named("Dao")
	private Dao dao;

	public List<?> getSelfDevelopmentStat(Map<?, ?> paramMap) throws Exception {
		return (List<?>) dao.getList("getSelfDevelopmentStat", paramMap);
	}



}
