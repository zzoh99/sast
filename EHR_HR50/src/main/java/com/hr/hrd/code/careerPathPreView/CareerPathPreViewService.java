package com.hr.hrd.code.careerPathPreView;

import com.hr.common.dao.Dao;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import javax.inject.Named;
import java.util.List;
import java.util.Map;

@Service("CareerPathPreViewService")
public class CareerPathPreViewService {
	@Inject
	@Named("Dao")
	private Dao dao;

	public List<Map<String,Object>> getCareerPathPreViewList(Map<?, ?> paramMap) throws Exception {
		return (List<Map<String,Object>>) dao.getList("getCareerPathPreViewList", paramMap);
	}

	public List<Map<String,Object>> getCareerPathPreViewTitleList(Map<?, ?> paramMap) throws Exception {
		return (List<Map<String,Object>>) dao.getList("getCareerPathPreViewTitleList", paramMap);
	}


}
