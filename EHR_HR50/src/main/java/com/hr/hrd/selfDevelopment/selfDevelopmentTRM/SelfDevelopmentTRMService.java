package com.hr.hrd.selfDevelopment.selfDevelopmentTRM;

import com.hr.common.dao.Dao;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import javax.inject.Named;
import java.util.List;
import java.util.Map;

@Service("SelfDevelopmentTRMService")
public class SelfDevelopmentTRMService {
	@Inject
	@Named("Dao")
	private Dao dao;

	public List<?> getSelfDevelopmentTRM(Map<?, ?> paramMap) throws Exception {
		return (List<?>) dao.getList("getSelfDevelopmentTRM", paramMap);
	}


}
