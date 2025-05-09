package com.hr.hrd.selfRating.selfRatingRegist;

import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

@Service("SelfRatingRegistService")
public class SelfRatingRegistService {
	@Inject
	@Named("Dao")
	private Dao dao;

	public List<?> getSelfRatingRegistList(Map<?, ?> paramMap) throws Exception {
		return (List<?>) dao.getList("getSelfRatingRegistList", paramMap);
	}

	public List<?> getSelfRatingRegistDetailList1(Map<?, ?> paramMap) throws Exception {
		return (List<?>) dao.getList("getSelfRatingRegistDetailList1", paramMap);
	}

	public List<?> getSelfRatingRegistDetailList2(Map<?, ?> paramMap) throws Exception {
		return (List<?>) dao.getList("getSelfRatingRegistDetailList2", paramMap);
	}

	public List<?> getSelfRatingRegistDetailList3(Map<?, ?> paramMap) throws Exception {
		return (List<?>) dao.getList("getSelfRatingRegistDetailList3", paramMap);
	}

	public int saveSelfRatingRegist(Map<?, ?> convertMap) throws Exception {
	int cnt=0;

		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteSelfRatingRegist", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveSelfRatingRegist", convertMap);
		}

		return cnt;
	}

	public int saveSelfRatingRegistDetail1(Map<?, ?> convertMap) throws Exception {
	int cnt=0;

		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteSelfRatingRegistDetail1", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveSelfRatingRegistDetail1", convertMap);
		}

		return cnt;
	}

	public int saveSelfRatingRegistDetail2(Map<?, ?> convertMap) throws Exception {
		int cnt=0;

		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteSelfRatingRegistDetail2", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveSelfRatingRegistDetail2", convertMap);
		}

		return cnt;
	}

	public int saveSelfRatingRegistDetail3(Map<?, ?> convertMap) throws Exception {
		int cnt=0;

		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteSelfRatingRegistDetail2", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveSelfRatingRegistDetail2", convertMap);
		}

		return cnt;
	}

}
