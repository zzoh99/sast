package com.hr.common.database;

import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;


@Service("DatabaseService")
public class DatabaseService{

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
	public Map<?, ?> getColumnInfo(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getColumnInfo", paramMap);
	}

}