package com.hr.hrd.statistics.hopeWorkAssignState;

import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

@Service("HopeWorkAssignStateService")
public class HopeWorkAssignStateService {
	@Inject
	@Named("Dao")
	private Dao dao;

	public List<?> getHopeWorkAssignStateList(Map<?, ?> paramMap) throws Exception {
		return (List<?>) dao.getList("getHopeWorkAssignStateList", paramMap);
	}

	public List<?> getHopeWorkAssignStateDetailList(Map<?, ?> paramMap) throws Exception {
		return (List<?>) dao.getList("getHopeWorkAssignStateDetailList", paramMap);
	}

}
