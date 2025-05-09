package com.hr.common.popup.searchMenuAllLayer;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import javax.inject.Named;
import java.util.List;
import java.util.Map;

@Service("SearchMenuAllLayerService")
public class SearchMenuAllLayerService {
	@Inject
	@Named("Dao")
	
	private Dao dao;


	/**
	 * getSearchMenuAllLayerList 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getSearchMenuAllLayerList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getSearchMenuAllLayerList", paramMap);
	}
}