package com.hr.common.atuhTable;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;


@Service("AuthTableService") 
public class AuthTableService{
 
	@Inject
	@Named("Dao")
	private Dao dao;
	


	/**
	 * 공통 Auth Result 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getAuthQueryMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getAuthQueryMap", paramMap);
	}
	
	
}