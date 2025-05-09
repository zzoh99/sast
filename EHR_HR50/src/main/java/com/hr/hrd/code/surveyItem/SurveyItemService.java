package com.hr.hrd.code.surveyItem;

import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

@Service("SurveyItemService")
public class SurveyItemService {
	@Inject
	@Named("Dao")
	private Dao dao;

	public List<?> getSurveyItemList(Map<?, ?> paramMap) throws Exception {
		return (List<?>) dao.getList("getSurveyItemList", paramMap);
	}

	public int saveSurveyItem(Map<?, ?> convertMap) throws Exception {
	int cnt=0;

		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteSurveyItem", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveSurveyItem", convertMap);
		}

		return cnt;
	}

	public int deleteSurveyItem(Map<?, ?> paramMap) throws Exception {
		return dao.delete("deleteSurveyItem", paramMap);
	}

}
