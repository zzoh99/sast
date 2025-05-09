package com.hr.common.getDataList;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * GetDataList Service
 *
 * @author RYU SIOONG
 *
 */
@Service("GetDataListService")
public class GetDataListService{
	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * GetDataList 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getDataList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return (List<?>) dao.getList(paramMap.get("cmd").toString(), paramMap);
	}
	
}