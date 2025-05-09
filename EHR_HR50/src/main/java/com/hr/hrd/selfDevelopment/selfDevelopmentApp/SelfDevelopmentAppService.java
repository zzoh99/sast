package com.hr.hrd.selfDevelopment.selfDevelopmentApp;

import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;

@Service("SelfDevelopmentAppService")
public class SelfDevelopmentAppService {
	@Inject
	@Named("Dao")
	private Dao dao;

	public List<?> getSelfDevelopmentList(Map<?, ?> paramMap) throws Exception {
		return (List<?>) dao.getList("getSelfDevelopmentList", paramMap);
	}

	public List<?> getWorkAssignList(Map<?, ?> paramMap) throws Exception {
		return (List<?>) dao.getList("getWorkAssignList", paramMap);
	}

	public List<?> getSelfSkillAndDevPlanList(Map<?, ?> paramMap) throws Exception {
		return (List<?>) dao.getList("getSelfSkillAndDevPlanList", paramMap);
	}

	public List<?> getSelfReportMoveHopeList(Map<?, ?> paramMap) throws Exception {
		return (List<?>) dao.getList("getSelfReportMoveHopeList", paramMap);
	}

	public int saveSelfDevelopment(Map<?, ?> convertMap) throws Exception {

		int cnt=0;

		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteSelfDevelopmentApp", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveSelfDevelopmentApp", convertMap);
		}

		return cnt;
	}

	public int saveSelfSkillAndDevPlan(Map<?, ?> convertMap) throws Exception {

		int cnt=0;

		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteSelfSkillAndDevPlanApp", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveSelfSkillAndDevPlanApp", convertMap);
		}

		return cnt;
	}

	public List<?> getSelfDevelopmentPrevStepStatusList(Map<?, ?> paramMap) throws Exception {
		return (List<?>) dao.getList("getSelfDevelopmentPrevStepStatusList", paramMap);
	}


}
