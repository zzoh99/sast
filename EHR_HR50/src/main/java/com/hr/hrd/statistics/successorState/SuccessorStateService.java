package com.hr.hrd.statistics.successorState;

import com.hr.common.dao.Dao;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import javax.inject.Named;
import java.util.List;
import java.util.Map;

@Service("SuccessorStateService")
public class SuccessorStateService {
	@Inject
	@Named("Dao")
	private Dao dao;

	public List<?> getSuccessorStateList(Map<?, ?> paramMap) throws Exception {
		return (List<?>) dao.getList("getSuccessorStateList", paramMap);
	}

}
