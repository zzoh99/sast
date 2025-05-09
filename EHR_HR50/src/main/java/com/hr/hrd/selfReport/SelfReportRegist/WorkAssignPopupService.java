package com.hr.hrd.selfReport.SelfReportRegist;

import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

@Service("WorkAssignPopupService")
public class WorkAssignPopupService {
	@Inject
	@Named("Dao")
	private Dao dao;

	public List<?> getWorkAssignPopupList(Map<?, ?> paramMap) throws Exception {
		return (List<?>) dao.getList("getworkAssignPopupList", paramMap);
	}

}
