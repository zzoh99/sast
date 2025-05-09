package com.hr.hrd.selfRating.selfRatingApproval;

import com.hr.common.dao.Dao;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import javax.inject.Named;
import java.util.List;
import java.util.Map;

@Service("SelfRatingApprovalService")
public class SelfRatingApprovalService {
	@Inject
	@Named("Dao")
	private Dao dao;

	public List<?> getSelfRatingApprovalList(Map<?, ?> paramMap) throws Exception {
		return (List<?>) dao.getList("getSelfRatingApprovalList", paramMap);
	}

	public List<?> getSelfRatingApprovalDetailList1(Map<?, ?> paramMap) throws Exception {
		return (List<?>) dao.getList("getSelfRatingApprovalDetailList1", paramMap);
	}

	public List<?> getSelfRatingApprovalDetailList2(Map<?, ?> paramMap) throws Exception {
		return (List<?>) dao.getList("getSelfRatingApprovalDetailList2", paramMap);
	}

	public List<?> getSelfRatingApprovalDetailList3(Map<?, ?> paramMap) throws Exception {
		return (List<?>) dao.getList("getSelfRatingApprovalDetailList3", paramMap);
	}

	public int saveSelfRatingApproval(Map<?, ?> convertMap) throws Exception {
	int cnt=0;

		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteSelfRatingApproval", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveSelfRatingApproval", convertMap);
		}

		return cnt;
	}

	public int saveSelfRatingApprovalDetail1(Map<?, ?> convertMap) throws Exception {
	int cnt=0;

		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteSelfRatingApprovalDetail1", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveSelfRatingApprovalDetail1", convertMap);
		}

		return cnt;
	}

	public int saveSelfRatingApprovalDetail2(Map<?, ?> convertMap) throws Exception {
		int cnt=0;

		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteSelfRatingApprovalDetail2", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveSelfRatingApprovalDetail2", convertMap);
		}

		return cnt;
	}

	public int saveSelfRatingApprovalDetail3(Map<?, ?> convertMap) throws Exception {
		int cnt=0;

		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteSelfRatingApprovalDetail2", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveSelfRatingApprovalDetail2", convertMap);
		}

		return cnt;
	}

}
