package com.hr.common.getDataMap;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * GetDataMap Service
 *
 * @author RYU SIOONG
 *
 */
@Service("GetDataMapService")
public class GetDataMapService{
	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 *  GetDataMap 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getDataMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap(paramMap.get("cmd").toString(), paramMap);
		Log.Debug();
		return resultMap;
	}

}