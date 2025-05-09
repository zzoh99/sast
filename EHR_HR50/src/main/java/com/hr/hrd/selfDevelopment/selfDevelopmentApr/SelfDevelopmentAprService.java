package com.hr.hrd.selfDevelopment.selfDevelopmentApr;

import com.hr.common.dao.Dao;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import javax.inject.Named;
import java.util.List;
import java.util.Map;

@Service("SelfDevelopmentAprService")
public class SelfDevelopmentAprService {
	@Inject
	@Named("Dao")
	private Dao dao;

	public List<?> getSelfDevelopmentArpList(Map<?, ?> paramMap) throws Exception {
		return (List<?>) dao.getList("getSelfDevelopmentArpList", paramMap);
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
			cnt += dao.delete("deleteSelfDevelopmentApr", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveSelfDevelopment", convertMap);
		}

		return cnt;
	}

	public int saveSelfDevelopmentAprCancel(Map<?, ?> convertMap) throws Exception {

		int cnt=0;

		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveSelfDevelopmentAprCancel", convertMap);
		}

		return cnt;
	}

	public int saveSelfDevelopmentAprConfirmOrReject(Map<?, ?> convertMap) throws Exception {

		int cnt=0;

		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveSelfDevelopmentAprConfirmOrReject", convertMap);
		}

		return cnt;
	}

	public int saveSelfSkillAndDevPlan(Map<?, ?> convertMap) throws Exception {

		int cnt=0;

		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteSelfSkillAndDevPlan", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveSelfSkillAndDevPlan", convertMap);
		}

		return cnt;
	}



}
