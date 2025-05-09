package com.hr.hrd.selfReport.SelfReportRegist;

import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

@Service("CareerPathPopupService")
public class CareerPathPopupService {
	@Inject
	@Named("Dao")
	private Dao dao;

	public List<?> getCareerPathPopupList(Map<?, ?> paramMap) throws Exception {
		return (List<?>) dao.getList("getCareerPathPopupList", paramMap);
	}

	public List<?> getCareerPathPopupDetailList(Map<?, ?> paramMap) throws Exception {
		return (List<?>) dao.getList("getCareerPathPopupDetailList", paramMap);
	}

}
