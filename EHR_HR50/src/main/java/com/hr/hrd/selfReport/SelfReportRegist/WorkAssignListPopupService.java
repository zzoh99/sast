package com.hr.hrd.selfReport.SelfReportRegist;

import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

@Service("WorkAssignListPopupService")
public class WorkAssignListPopupService {
	@Inject
	@Named("Dao")
	private Dao dao;

	public List<?> getWorkAssignListPopupList(Map<?, ?> paramMap) throws Exception {
		return (List<?>) dao.getList("getWorkAssignListPopupList", paramMap);
	}

	public int saveWorkAssignListPopup(Map<?, ?> convertMap) throws Exception {
	int cnt=0;

		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteWorkAssignListPopup", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveWorkAssignListPopup", convertMap);
		}

		return cnt;
	}

}
