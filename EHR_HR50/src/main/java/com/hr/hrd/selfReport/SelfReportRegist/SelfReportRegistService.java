package com.hr.hrd.selfReport.SelfReportRegist;

import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

@Service("SelfReportRegistService")
public class SelfReportRegistService {
	@Inject
	@Named("Dao")
	private Dao dao;

	public List<?> getSelfReportRegistPopupList(Map<?, ?> paramMap) throws Exception {
		return (List<?>) dao.getList("getSelfReportRegistPopupList", paramMap);
	}

	public List<?> getSelfReportRegistList(Map<?, ?> paramMap) throws Exception {
		return (List<?>) dao.getList("getSelfReportRegistList", paramMap);
	}

	public int saveSelfReportRegist(Map<?, ?> convertMap) throws Exception {
		return dao.update("saveSelfReportRegist", convertMap);
	}

	public int deleteSelfReportRegist(Map<?, ?> paramMap) throws Exception {
		return dao.delete("deleteSelfReportRegist", paramMap);
	}

	public List<?> getSurveyPointList(Map<?, ?> paramMap) throws Exception {
		return (List<?>) dao.getList("getSurveyPointList", paramMap);
	}

	public int saveSurveyPoint(Map<?, ?> convertMap) throws Exception {
		int cnt = 0;

		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveSurveyPoint", convertMap);
		}

		return cnt;
	}

}
