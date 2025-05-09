package com.hr.hrm.successor.succOrgList;

import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

@Service("SuccOrgListService")
public class SuccOrgListService{

	@Inject
	@Named("Dao")
	private Dao dao;


	public List<?> getSuccOrgList(Map<?, ?> paramMap, String searchType) throws Exception {
		Log.DebugStart();
		return (List<?>)dao.getList("getSuccOrgList"+searchType, paramMap);
	}
	
}