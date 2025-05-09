package com.hr.common.error;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;


@Service("ErrorService") 
public class ErrorService{
 
	@Inject
	@Named("Dao")
	private Dao dao;
	
	/**
	 *  MAP 조회 한건의 결과를 Map 형태로 반환
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getErrorChargeInfo(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>)dao.getList("getErrorChargeInfo", paramMap);
	}
	
}